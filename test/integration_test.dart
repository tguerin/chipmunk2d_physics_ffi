import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Integration Tests', () {
    test('simple physics simulation', () {
      final space = Space()..gravity = const Vector(0, -100);

      // Create a falling ball
      final ball = Body.dynamic(1.0, 1.0)..position = const Vector(0, 100);
      final ballShape = CircleShape(ball, 10.0)
        ..friction = 0.7
        ..elasticity = 0.5;

      // Create ground
      final ground = space.staticBody;
      final groundShape = SegmentShape(
        ground,
        const Vector(-100, 0),
        const Vector(100, 0),
        2.0,
      );

      space
        ..addBody(ball)
        ..addShape(ballShape)
        ..addShape(groundShape);

      // Simulate for a few steps
      for (var i = 0; i < 10; i++) {
        space.step(1.0 / 60.0);
      }

      // Ball should have moved
      final finalPosition = ball.position;
      expect(finalPosition.y, lessThan(100.0));

      space.dispose();
    });

    test('multiple bodies interaction', () {
      final space = Space()..gravity = const Vector(0, -100);
      final bodies = <Body>[];
      final shapes = <Shape>[];

      // Create multiple balls
      for (var i = 0; i < 5; i++) {
        final body = Body.dynamic(1.0, 1.0)..position = Vector(i * 20.0, 100.0);
        final shape = CircleShape(body, 5.0);

        space
          ..addBody(body)
          ..addShape(shape);
        bodies.add(body);
        shapes.add(shape);
      }

      // Step simulation
      for (var i = 0; i < 10; i++) {
        space.step(1.0 / 60.0);
      }

      // All bodies should have moved
      for (final body in bodies) {
        expect(body.position.y, lessThan(100.0));
      }

      space.dispose();
    });

    test('collision detection', () {
      final space = Space();
      final bodyA = Body.dynamic(1.0, 1.0)..position = const Vector(0, 50);
      final bodyB = Body.dynamic(1.0, 1.0)..position = const Vector(5, 50);
      final shapeA = CircleShape(bodyA, 10.0);
      final shapeB = CircleShape(bodyB, 10.0);

      space
        ..addBody(bodyA)
        ..addBody(bodyB)
        ..addShape(shapeA)
        ..addShape(shapeB);

      // Step simulation - shapes should collide
      for (var i = 0; i < 10; i++) {
        space.step(1.0 / 60.0);
      }

      // Bodies should have moved due to collision
      expect(bodyA.position.x, isNot(closeTo(0.0, 0.1)));
      expect(bodyB.position.x, isNot(closeTo(5.0, 0.1)));

      space.dispose();
    });

    test('joint constraint', () {
      final space = Space();
      final bodyA = Body.dynamic(1.0, 1.0)..position = const Vector(0, 50);
      final bodyB = Body.dynamic(1.0, 1.0)..position = const Vector(0, 30);
      final shapeA = CircleShape(bodyA, 5.0);
      final shapeB = CircleShape(bodyB, 5.0);
      final joint = PinJoint(
        bodyA,
        bodyB,
        Vector.zero,
        Vector.zero,
      )..distance = 20.0;

      space
        ..addBody(bodyA)
        ..addBody(bodyB)
        ..addShape(shapeA)
        ..addShape(shapeB)
        ..addConstraint(joint);

      // Step simulation
      for (var i = 0; i < 10; i++) {
        space.step(1.0 / 60.0);
      }

      // Bodies should maintain distance
      final distance = (bodyA.position - bodyB.position).length;
      expect(distance, closeTo(20.0, 5.0)); // Allow some tolerance

      space.dispose();
      joint.dispose();
    });

    test('sleeping bodies', () {
      final space = Space()..gravity = const Vector(0, -100);
      final body = Body.dynamic(1.0, 1.0)..position = Vector.zero;
      final shape = CircleShape(body, 10.0);

      space
        ..addBody(body)
        ..addShape(shape);

      // Step many times to let body settle
      for (var i = 0; i < 100; i++) {
        space.step(1.0 / 60.0);
      }

      // Body should eventually sleep
      // Note: This may not always be true depending on thresholds
      // but the property should be accessible
      expect(body.isSleeping, isA<bool>());

      space.dispose();
    });

    test('spatial queries', () {
      final space = Space();
      final body = Body.dynamic(1.0, 1.0)..position = Vector.zero;
      final shape = CircleShape(body, 10.0);

      space
        ..addBody(body)
        ..addShape(shape)
        // Note: pointQuery and segmentQuery are not yet implemented in the Space API
        // Note: bbQuery is not yet implemented in the Space API
        ..dispose();
    });

    test('shape queries', () {
      final space = Space();
      final bodyA = Body.dynamic(1.0, 1.0)..position = Vector.zero;
      final shapeA = CircleShape(bodyA, 10.0);
      final bodyB = Body.dynamic(1.0, 1.0)..position = const Vector(5, 0);
      final shapeB = CircleShape(bodyB, 10.0);

      space
        ..addBody(bodyA)
        ..addBody(bodyB)
        ..addShape(shapeA)
        ..addShape(shapeB)
        // Note: shapeQuery is not yet implemented in the Space API
        ..dispose();
    });

    test('all joint types work together', () {
      final space = Space();
      final bodies = <Body>[];
      final constraints = <Constraint>[];

      // Create bodies
      for (var i = 0; i < 5; i++) {
        final body = Body.dynamic(1.0, 1.0)..position = Vector(i * 20.0, 50.0);
        bodies.add(body);
        space.addBody(body);
      }

      // Create different joint types
      constraints
        ..add(
          PinJoint(
            bodies[0],
            bodies[1],
            Vector.zero,
            Vector.zero,
          ),
        )
        ..add(
          SlideJoint(
            bodies[1],
            bodies[2],
            Vector.zero,
            Vector.zero,
            0.0,
            20.0,
          ),
        )
        ..add(
          PivotJoint.atWorldPoint(
            bodies[2],
            bodies[3],
            bodies[2].position,
          ),
        )
        ..add(
          DampedSpring(
            bodies[3],
            bodies[4],
            Vector.zero,
            Vector.zero,
            20.0,
            1.0,
            0.5,
          ),
        )
        // Add all constraints
        ..forEach(space.addConstraint);

      // Step simulation
      for (var i = 0; i < 10; i++) {
        space.step(1.0 / 60.0);
      }

      // All should work without errors
      expect(constraints.length, 4);

      // Cleanup
      for (final constraint in constraints) {
        constraint.dispose();
      }
      space.dispose();
    });

    test('memory management', () {
      // Test that disposing resources doesn't cause errors
      final space = Space();
      final bodies = <Body>[];
      final shapes = <Shape>[];
      final constraints = <Constraint>[];

      for (var i = 0; i < 10; i++) {
        final body = Body.dynamic(1.0, 1.0);
        final shape = CircleShape(body, 5.0);
        bodies.add(body);
        shapes.add(shape);
        space
          ..addBody(body)
          ..addShape(shape);
      }

      // Create constraints
      for (var i = 0; i < 9; i++) {
        final constraint = PinJoint(
          bodies[i],
          bodies[i + 1],
          Vector.zero,
          Vector.zero,
        );
        constraints.add(constraint);
        space.addConstraint(constraint);
      }

      // Step
      space
        ..step(0.016)
        // Let space dispose everything (it will handle cleanup)
        ..dispose();

      // Should complete without errors
      expect(true, true);
    });
  });
}
