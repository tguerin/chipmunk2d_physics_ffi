import 'dart:async';
import 'dart:math' as math;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:show_fps/show_fps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Object? initError;
  StackTrace? initStackTrace;

  try {
    await initializeChipmunk();
    if (!isChipmunkInitialized) {
      initError = StateError('initializeChipmunk() completed but isChipmunkInitialized is false');
    }
  } on Object catch (e, stackTrace) {
    initError = e;
    initStackTrace = stackTrace;
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: initError != null ? ErrorScreen(error: initError, stackTrace: initStackTrace) : const LogoSmashDemo(),
    ),
  );
}

/// Error screen displayed when Chipmunk2D initialization fails.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.error, super.key, this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      appBar: AppBar(title: const Text('Initialization Error'), backgroundColor: Colors.red.shade800),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Failed to initialize Chipmunk2D', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
              child: SelectableText(error.toString(), style: const TextStyle(fontFamily: 'monospace')),
            ),
            if (stackTrace != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                child: SelectableText(
                  stackTrace.toString(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

const int _imageWidth = 188;
const int _imageHeight = 35;
const int _imageRowLength = 24;

const List<int> _imageBitmap = [
  15,
  -16,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  7,
  -64,
  15,
  63,
  -32,
  -2,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  31,
  -64,
  15,
  127,
  -125,
  -1,
  -128,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  127,
  -64,
  15,
  127,
  15,
  -1,
  -64,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  -1,
  -64,
  15,
  -2,
  31,
  -1,
  -64,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  -1,
  -64,
  0,
  -4,
  63,
  -1,
  -32,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  -1,
  -64,
  15,
  -8,
  127,
  -1,
  -32,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  -1,
  -64,
  0,
  -8,
  -15,
  -1,
  -32,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  -31,
  -1,
  -64,
  15,
  -8,
  -32,
  -1,
  -32,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  7,
  -15,
  -1,
  -64,
  9,
  -15,
  -32,
  -1,
  -32,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  31,
  -15,
  -1,
  -64,
  0,
  -15,
  -32,
  -1,
  -32,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  63,
  -7,
  -1,
  -64,
  9,
  -29,
  -32,
  127,
  -61,
  -16,
  63,
  15,
  -61,
  -1,
  -8,
  31,
  -16,
  15,
  -8,
  126,
  7,
  -31,
  -8,
  31,
  -65,
  -7,
  -1,
  -64,
  9,
  -29,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -1,
  -2,
  63,
  -8,
  31,
  -4,
  -1,
  15,
  -13,
  -4,
  63,
  -1,
  -3,
  -1,
  -64,
  9,
  -29,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -1,
  -2,
  63,
  -8,
  31,
  -4,
  -1,
  15,
  -13,
  -2,
  63,
  -1,
  -3,
  -1,
  -64,
  9,
  -29,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -1,
  -1,
  63,
  -4,
  63,
  -4,
  -1,
  15,
  -13,
  -2,
  63,
  -33,
  -1,
  -1,
  -32,
  9,
  -25,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -1,
  -1,
  63,
  -4,
  63,
  -4,
  -1,
  15,
  -13,
  -1,
  63,
  -33,
  -1,
  -1,
  -16,
  9,
  -25,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -1,
  -1,
  63,
  -4,
  63,
  -4,
  -1,
  15,
  -13,
  -1,
  63,
  -49,
  -1,
  -1,
  -8,
  9,
  -57,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -8,
  -1,
  63,
  -2,
  127,
  -4,
  -1,
  15,
  -13,
  -1,
  -65,
  -49,
  -1,
  -1,
  -4,
  9,
  -57,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -8,
  -1,
  63,
  -2,
  127,
  -4,
  -1,
  15,
  -13,
  -1,
  -65,
  -57,
  -1,
  -1,
  -2,
  9,
  -57,
  -32,
  0,
  7,
  -8,
  127,
  -97,
  -25,
  -8,
  -1,
  63,
  -2,
  127,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -57,
  -1,
  -1,
  -1,
  9,
  -57,
  -32,
  0,
  7,
  -1,
  -1,
  -97,
  -25,
  -8,
  -1,
  63,
  -1,
  -1,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -61,
  -1,
  -1,
  -1,
  -119,
  -57,
  -32,
  0,
  7,
  -1,
  -1,
  -97,
  -25,
  -8,
  -1,
  63,
  -1,
  -1,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -61,
  -1,
  -1,
  -1,
  -55,
  -49,
  -32,
  0,
  7,
  -1,
  -1,
  -97,
  -25,
  -8,
  -1,
  63,
  -1,
  -1,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -63,
  -1,
  -1,
  -1,
  -23,
  -49,
  -32,
  127,
  -57,
  -1,
  -1,
  -97,
  -25,
  -1,
  -1,
  63,
  -1,
  -1,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -63,
  -1,
  -1,
  -1,
  -16,
  -49,
  -32,
  -1,
  -25,
  -1,
  -1,
  -97,
  -25,
  -1,
  -1,
  63,
  -33,
  -5,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -64,
  -1,
  -9,
  -1,
  -7,
  -49,
  -32,
  -1,
  -25,
  -8,
  127,
  -97,
  -25,
  -1,
  -1,
  63,
  -33,
  -5,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -64,
  -1,
  -13,
  -1,
  -32,
  -49,
  -32,
  -1,
  -25,
  -8,
  127,
  -97,
  -25,
  -1,
  -2,
  63,
  -49,
  -13,
  -4,
  -1,
  15,
  -13,
  -1,
  -1,
  -64,
  127,
  -7,
  -1,
  -119,
  -17,
  -15,
  -1,
  -25,
  -8,
  127,
  -97,
  -25,
  -1,
  -2,
  63,
  -49,
  -13,
  -4,
  -1,
  15,
  -13,
  -3,
  -1,
  -64,
  127,
  -8,
  -2,
  15,
  -17,
  -1,
  -1,
  -25,
  -8,
  127,
  -97,
  -25,
  -1,
  -8,
  63,
  -49,
  -13,
  -4,
  -1,
  15,
  -13,
  -3,
  -1,
  -64,
  63,
  -4,
  120,
  0,
  -17,
  -1,
  -1,
  -25,
  -8,
  127,
  -97,
  -25,
  -8,
  0,
  63,
  -57,
  -29,
  -4,
  -1,
  15,
  -13,
  -4,
  -1,
  -64,
  63,
  -4,
  0,
  15,
  -17,
  -1,
  -1,
  -25,
  -8,
  127,
  -97,
  -25,
  -8,
  0,
  63,
  -57,
  -29,
  -4,
  -1,
  -1,
  -13,
  -4,
  -1,
  -64,
  31,
  -2,
  0,
  0,
  103,
  -1,
  -1,
  -57,
  -8,
  127,
  -97,
  -25,
  -8,
  0,
  63,
  -57,
  -29,
  -4,
  -1,
  -1,
  -13,
  -4,
  127,
  -64,
  31,
  -2,
  0,
  15,
  103,
  -1,
  -1,
  -57,
  -8,
  127,
  -97,
  -25,
  -8,
  0,
  63,
  -61,
  -61,
  -4,
  127,
  -1,
  -29,
  -4,
  127,
  -64,
  15,
  -8,
  0,
  0,
  55,
  -1,
  -1,
  -121,
  -8,
  127,
  -97,
  -25,
  -8,
  0,
  63,
  -61,
  -61,
  -4,
  127,
  -1,
  -29,
  -4,
  63,
  -64,
  15,
  -32,
  0,
  0,
  23,
  -1,
  -2,
  3,
  -16,
  63,
  15,
  -61,
  -16,
  0,
  31,
  -127,
  -127,
  -8,
  31,
  -1,
  -127,
  -8,
  31,
  -128,
  7,
  -128,
  0,
  0,
];

/// Get pixel value from bitmap (1 = pixel set, 0 = empty)
int _getPixel(int x, int y) {
  if (x < 0 || x >= _imageWidth || y < 0 || y >= _imageHeight) return 0;
  final byteIndex = (x >> 3) + y * _imageRowLength;
  if (byteIndex < 0 || byteIndex >= _imageBitmap.length) return 0;
  final byte = _imageBitmap[byteIndex];
  final unsignedByte = byte < 0 ? byte + 256 : byte;
  return (unsignedByte >> (~x & 0x7)) & 1;
}

class LogoSmashDemo extends StatefulWidget {
  const LogoSmashDemo({super.key});

  @override
  State<LogoSmashDemo> createState() => _LogoSmashDemoState();
}

class _Ball {
  _Ball(this.body, this.shape, this.radius, {this.isSmashBall = false});

  final Body body;
  final Shape shape;
  final double radius;
  final bool isSmashBall;
}

class _LogoSmashDemoState extends State<LogoSmashDemo> with SingleTickerProviderStateMixin {
  Space? _space;
  final List<_Ball> _balls = [];
  Ticker? _ticker;
  Duration _lastTime = Duration.zero;
  final ValueNotifier<int> _frameCounter = ValueNotifier(0);

  bool _isInitialized = false;
  final double _scale = 2;
  int _ballCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initPhysics();
      _startLoop();
      _isInitialized = true;
    }
  }

  void _initPhysics() {
    if (!isChipmunkInitialized) {
      throw StateError('Chipmunk2D is not initialized.');
    }

    final space = _space = Space()
      ..gravity = Vector
          .zero // No gravity in original
      ..iterations = 1
      ..damping = 1.0;

    _createLogoBalls(space);
    _createSmashBall(space);
  }

  void _createLogoBalls(Space space) {
    final random = math.Random();
    const ballRadius = 0.95;
    const maxBalls = 2500;

    final pixels = <(int, int)>[];
    for (var y = 0; y < _imageHeight; y++) {
      for (var x = 0; x < _imageWidth; x++) {
        if (_getPixel(x, y) != 0) {
          pixels.add((x, y));
        }
      }
    }

    pixels.shuffle(random);
    final selectedPixels = pixels.take(maxBalls);

    for (final (x, y) in selectedPixels) {
      final xJitter = 0.05 * random.nextDouble();
      final yJitter = 0.05 * random.nextDouble();

      final px = _scale * (x - _imageWidth / 2 + xJitter);
      final py = _scale * (_imageHeight / 2 - y + yJitter);

      final body = Body.dynamic(1, double.infinity)..position = Vector(px, py);

      final shape = CircleShape(body, ballRadius * _scale)
        ..elasticity = 0.0
        ..friction = 0.0;

      space
        ..addBody(body)
        ..addShape(shape);
      _balls.add(_Ball(body, shape, ballRadius * _scale));
      _ballCount++;
    }
  }

  void _createSmashBall(Space space) {
    final body = Body.dynamic(1000000000, double.infinity)
      ..position =
          const Vector(-500, 0) // Start far left
      ..velocity = const Vector(800, 0); // Move right very fast like a bullet

    final bulletRadius = 2 * _scale; // Small like a bullet
    final shape = CircleShape(body, bulletRadius)
      ..elasticity = 0.0
      ..friction = 0.0;

    space
      ..addBody(body)
      ..addShape(shape);
    _balls.add(_Ball(body, shape, bulletRadius, isSmashBall: true));
  }

  void _resetDemo() {
    for (final ball in _balls) {
      _space?.removeShape(ball.shape);
      _space?.removeBody(ball.body);
      ball.shape.dispose();
      ball.body.dispose();
    }
    _balls.clear();
    _ballCount = 0;

    if (_space != null) {
      _createLogoBalls(_space!);
      _createSmashBall(_space!);
    }
  }

  void _startLoop() {
    _ticker = createTicker(_onTick);
    unawaited(_ticker?.start());
  }

  void _onTick(Duration elapsed) {
    if (!mounted || _space == null) return;

    final rawDt = _lastTime == Duration.zero ? 1 / 60 : (elapsed - _lastTime).inMicroseconds / 1000000;
    final dt = math.min(math.max(rawDt, 0), 1 / 30);
    _lastTime = elapsed;

    if (dt <= 0 || dt > 1.0) return;

    _space!.step(1.0 / 60.0);

    _frameCounter.value++;
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF002B36), // Solarized dark background
      body: Stack(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _frameCounter,
            builder: (context, frame, child) {
              return CustomPaint(size: size, painter: _LogoPainter(_balls, _scale));
            },
          ),
          Positioned(
            top: safePadding.top,
            right: safePadding.right,
            child: const ShowFPS(
              child: SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: safePadding.top + 20,
            left: safePadding.left + 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LOGO SMASH',
                  style: TextStyle(
                    color: Color(0xFFEEE8D5), // Solarized light
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Balls: $_ballCount', style: const TextStyle(color: Color(0xFF93A1A1), fontSize: 14)),
              ],
            ),
          ),
          Positioned(
            bottom: safePadding.bottom + 20,
            right: safePadding.right + 20,
            child: FloatingActionButton.extended(
              onPressed: _resetDemo,
              backgroundColor: const Color(0xFF268BD2), // Solarized blue
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ticker?.dispose();
    for (final ball in _balls) {
      _space?.removeShape(ball.shape);
      _space?.removeBody(ball.body);
      ball.shape.dispose();
      ball.body.dispose();
    }
    _balls.clear();
    _space?.dispose();
    _frameCounter.dispose();
    super.dispose();
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter(this.balls, this.scale);

  final List<_Ball> balls;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..scale(1, -1); // Y up

    const logoColor = Color(0xFFEEE8D5); // Light cream for logo balls
    const smashColor = Color(0xFFDC322F); // Red for smash ball

    final logoPaint = Paint()..color = logoColor;
    final smashPaint = Paint()..color = smashColor;

    for (final ball in balls) {
      final x = ball.body.positionX;
      final y = ball.body.positionY;

      if (!x.isFinite || !y.isFinite) continue;

      final paint = ball.isSmashBall ? smashPaint : logoPaint;
      canvas.drawCircle(Offset(x, y), ball.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => true;
}
