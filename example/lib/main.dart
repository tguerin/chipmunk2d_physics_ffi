import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';

void main() => runApp(const MaterialApp(home: PhysicsDemo()));

/// A demo showcasing Chipmunk2D physics with bouncing particles.
class PhysicsDemo extends StatefulWidget {
  const PhysicsDemo({super.key});

  @override
  State<PhysicsDemo> createState() => _PhysicsDemoState();
}

class Particle {
  final Body body;
  final Shape shape;
  final double radius;

  Particle(this.body, this.shape, this.radius);
}

class _PhysicsDemoState extends State<PhysicsDemo>
    with SingleTickerProviderStateMixin {
  Space? _space;
  final List<Particle> _particles = [];
  Ticker? _ticker;
  Duration _lastTime = Duration.zero;
  final ValueNotifier<int> _frameCounter = ValueNotifier(0);

  double _halfH = 0;
  double _halfW = 0;
  double _floorY = 0;
  double _ceilingY = 0;
  int _targetParticleCount = 100;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final size = MediaQuery.of(context).size;
      _initPhysics(size);
      _startLoop();
      _isInitialized = true;
    }
  }

  void _initPhysics(Size screenSize) {
    _halfH = screenSize.height / 2;
    _halfW = screenSize.width / 2;

    // Create physics space
    final space = _space = Space()
      ..gravity = const Vector(0, -980)
      ..setIterations(20)
      ..setCollisionSlop(0.1)
      ..setCollisionBias(math.pow(1.0 - 0.1, 60.0).toDouble())
      ..setSleepTimeThreshold(0.5)
      ..setCollisionPersistence(3)
      ..setDamping(0.99)
      ..setIdleSpeedThreshold(0.0);

    // Create boundaries
    final staticBody = space.staticBody;
    _floorY = -_halfH + 10;
    _ceilingY = _halfH - 10;

    // Floor
    final floorShape = SegmentShape(
      staticBody,
      Vector(-_halfW, _floorY),
      Vector(_halfW, _floorY),
      1.0,
    );
    floorShape.elasticity = 0.8;
    floorShape.friction = 0.1;
    space.addShape(floorShape);

    // Left wall
    final leftWallShape = SegmentShape(
      staticBody,
      Vector(-_halfW, _floorY),
      Vector(-_halfW, _ceilingY),
      1.0,
    );
    leftWallShape.elasticity = 0.8;
    leftWallShape.friction = 0.1;
    space.addShape(leftWallShape);

    // Right wall
    final rightWallShape = SegmentShape(
      staticBody,
      Vector(_halfW, _floorY),
      Vector(_halfW, _ceilingY),
      1.0,
    );
    rightWallShape.elasticity = 0.8;
    rightWallShape.friction = 0.1;
    space.addShape(rightWallShape);

    // Create initial particles
    _updateParticleCount(_targetParticleCount);
  }

  void _updateParticleCount(int targetCount) {
    final currentCount = _particles.length;

    if (targetCount > currentCount) {
      // Add particles
      _addParticles(targetCount - currentCount);
    } else if (targetCount < currentCount) {
      // Remove particles
      _removeParticles(currentCount - targetCount);
    }
  }

  void _addParticles(int count) {
    const radius = 5.0;
    const mass = 1.0;
    final moment = 0.5 * mass * radius * radius;
    final random = math.Random();

    for (int i = 0; i < count; i++) {
      final body = Body.dynamic(mass, moment);
      final x = (random.nextDouble() - 0.5) * _halfW * 1.5;
      final y = _halfH - 50 + (random.nextDouble() * 100);
      body.position = Vector(x, y);

      final shape = CircleShape(body, radius);
      shape.elasticity = 0.9;
      shape.friction = 0.1;

      _space!.addBody(body);
      _space!.addShape(shape);
      _particles.add(Particle(body, shape, radius));
    }
  }

  void _removeParticles(int count) {
    for (int i = 0; i < count && _particles.isNotEmpty; i++) {
      final particle = _particles.removeLast();
      _space!.removeShape(particle.shape);
      _space!.removeBody(particle.body);
      particle.shape.dispose();
      particle.body.dispose();
    }
  }

  void _startLoop() {
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    if (_space case final space?) {
      final rawDt = _lastTime == Duration.zero
          ? 1 / 60
          : (elapsed - _lastTime).inMicroseconds / 1000000;
      final dt = math.min(math.max(rawDt, 0.0), 1 / 30);
      _lastTime = elapsed;

      if (dt <= 0 || dt > 1.0) return;

      // Sub-step to prevent tunneling through walls
      const maxSubStep = 1.0 / 120.0;
      final numSubSteps = (dt / maxSubStep).ceil();
      final subStep = dt / numSubSteps;

      // Step physics
      for (int i = 0; i < numSubSteps; i++) {
        space.stepUnsafe(subStep);
      }

      // Clean up out-of-bounds particles
      _cleanupOutOfBounds();

      // Trigger repaint
      _frameCounter.value++;
    }
  }

  void _cleanupOutOfBounds() {
    const boundsMargin = 50.0;
    if (_space case final space?) {
      for (int i = _particles.length - 1; i >= 0; i--) {
        final particle = _particles[i];
        final x = particle.body.positionX;
        final y = particle.body.positionY;

        if (!x.isFinite ||
            !y.isFinite ||
            x < -_halfW - boundsMargin ||
            x > _halfW + boundsMargin ||
            y < _floorY - boundsMargin ||
            y > _ceilingY + boundsMargin) {
          space.removeShape(particle.shape);
          space.removeBody(particle.body);
          particle.shape.dispose();
          particle.body.dispose();
          _particles.removeAt(i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Physics visualization
          ValueListenableBuilder<int>(
            valueListenable: _frameCounter,
            builder: (context, frame, child) {
              return CustomPaint(
                size: size,
                painter: ParticlePainter(_particles, size),
              );
            },
          ),
          // Controls overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withValues(alpha: 0.9),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Particles: ${_particles.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _targetParticleCount.toDouble(),
                      min: 0,
                      max: 2500,
                      divisions: 50,
                      label: _targetParticleCount.toString(),
                      onChanged: (value) {
                        setState(() {
                          _targetParticleCount = value.round();
                          _updateParticleCount(_targetParticleCount);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ticker?.dispose();
    for (final particle in _particles) {
      _space?.removeShape(particle.shape);
      _space?.removeBody(particle.body);
      particle.shape.dispose();
      particle.body.dispose();
    }
    _particles.clear();
    _space?.dispose();
    _frameCounter.dispose();
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Size screenSize;

  ParticlePainter(this.particles, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    // Transform to physics coordinates (center origin, Y up)
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(1.0, -1.0);

    // Draw boundaries
    final halfW = size.width / 2;
    final halfH = size.height / 2;
    final floorY = -halfH + 10;
    final ceilingY = halfH - 10;
    final boundaryPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(-halfW, floorY),
      Offset(halfW, floorY),
      boundaryPaint,
    );
    canvas.drawLine(
      Offset(-halfW, floorY),
      Offset(-halfW, ceilingY),
      boundaryPaint,
    );
    canvas.drawLine(
      Offset(halfW, floorY),
      Offset(halfW, ceilingY),
      boundaryPaint,
    );

    // Draw particles
    final particlePaint = Paint()..color = Colors.blue;
    for (final particle in particles) {
      final x = particle.body.positionX;
      final y = particle.body.positionY;
      if (x.isFinite && y.isFinite) {
        canvas.drawCircle(Offset(x, y), particle.radius, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
