import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Space', () {
    test('creates space', () {
      final space = Space();
      expect(space, isNotNull);
      space.dispose();
    });

    test('sets and gets gravity', () {
      final space = Space();
      const gravity = Vector(0, -100);
      space.gravity = gravity;
      final retrieved = space.gravity;
      expect(retrieved.x, closeTo(0.0, 0.001));
      expect(retrieved.y, closeTo(-100.0, 0.001));
      space.dispose();
    });

    test('sets and gets iterations', () {
      final space = Space()..setIterations(20);
      expect(space.iterations, 20);
      space.dispose();
    });

    test('sets and gets damping', () {
      final space = Space()..setDamping(0.9);
      expect(space.damping, closeTo(0.9, 0.001));
      space.dispose();
    });

    test('sets and gets collision slop', () {
      final space = Space()..setCollisionSlop(0.2);
      expect(space.collisionSlop, closeTo(0.2, 0.001));
      space.dispose();
    });

    test('sets and gets collision bias', () {
      final space = Space()..setCollisionBias(0.1);
      expect(space.collisionBias, closeTo(0.1, 0.001));
      space.dispose();
    });

    test('sets and gets idle speed threshold', () {
      final space = Space()..setIdleSpeedThreshold(0.5);
      expect(space.idleSpeedThreshold, closeTo(0.5, 0.001));
      space.dispose();
    });

    test('sets and gets sleep time threshold', () {
      final space = Space()..setSleepTimeThreshold(0.5);
      expect(space.sleepTimeThreshold, closeTo(0.5, 0.001));
      space.dispose();
    });

    test('sets and gets collision persistence', () {
      final space = Space()..setCollisionPersistence(3);
      expect(space.collisionPersistence, 3);
      space.dispose();
    });

    test('gets static body', () {
      final space = Space();
      final staticBody = space.staticBody;
      expect(staticBody, isNotNull);
      expect(staticBody.type, BodyType.static);
      space.dispose();
    });

    test('adds and removes body', () {
      final space = Space();
      final body = Body.dynamic(1.0, 1.0);
      space.addBody(body);
      expect(space.containsBody(body), true);
      space.removeBody(body);
      expect(space.containsBody(body), false);
      body.dispose();
      space.dispose();
    });

    test('adds and removes shape', () {
      final space = Space();
      final body = Body.dynamic(1.0, 1.0);
      final shape = CircleShape(body, 10.0);
      space
        ..addBody(body)
        ..addShape(shape);
      expect(space.containsShape(shape), true);
      space.removeShape(shape);
      expect(space.containsShape(shape), false);
      // Dispose manually since we removed from space
      shape.dispose();
      body.dispose();
      // Space dispose won't try to dispose already-removed items
      space.dispose();
    });

    test('adds and removes constraint', () {
      final space = Space();
      final bodyA = Body.dynamic(1.0, 1.0);
      final bodyB = Body.dynamic(1.0, 1.0);
      final constraint = PinJoint(
        bodyA,
        bodyB,
        Vector.zero,
        Vector.zero,
      );
      space
        ..addBody(bodyA)
        ..addBody(bodyB)
        ..addConstraint(constraint);
      expect(space.containsConstraint(constraint), true);
      space.removeConstraint(constraint);
      expect(space.containsConstraint(constraint), false);
      // Dispose manually since we removed from space
      constraint.dispose();
      bodyA.dispose();
      bodyB.dispose();
      // Space dispose won't try to dispose already-removed items
      space.dispose();
    });

    test('steps simulation', () {
      final space = Space();
      final body = Body.dynamic(1.0, 1.0)..position = const Vector(0, 100);
      final shape = CircleShape(body, 10.0);
      space
        ..addBody(body)
        ..addShape(shape);
      expect(() => space.step(1.0 / 60.0), returnsNormally);
      // Let space dispose everything
      space.dispose();
    });

    test('gets current time step', () {
      final space = Space()..step(0.016);
      final timeStep = space.currentTimeStep;
      expect(timeStep, closeTo(0.016, 0.001));
      space.dispose();
    });

    test('isLocked returns false when not stepping', () {
      final space = Space();
      expect(space.isLocked, false);
      space.dispose();
    });

    test('reindexStatic', () {
      final space = Space();
      expect(space.reindexStatic, returnsNormally);
      space.dispose();
    });

    test('reindexShape', () {
      final space = Space();
      final body = Body.static();
      final shape = CircleShape(body, 10.0);
      space
        ..addBody(body)
        ..addShape(shape);
      expect(() => space.reindexShape(shape), returnsNormally);
      // Let space dispose everything
      space.dispose();
    });

    test('reindexShapesForBody', () {
      final space = Space();
      final body = Body.static();
      final shape = CircleShape(body, 10.0);
      space
        ..addBody(body)
        ..addShape(shape);
      expect(() => space.reindexShapesForBody(body), returnsNormally);
      // Let space dispose everything
      space.dispose();
    });

    // Note: Query methods (pointQuery, segmentQuery, bbQuery, shapeQuery) and
    // iteration methods (eachBody, eachShape, eachConstraint) are not yet
    // implemented in the Space API. These tests are commented out until
    // those features are added.

    test('throws error after disposal', () {
      final space = Space()..dispose();
      expect(() => space.step(0.016), throwsStateError);
      expect(() => space.gravity, throwsStateError);
      expect(() => space.iterations, throwsStateError);
    });

    test('toString', () {
      final space = Space();
      final body = Body.dynamic(1.0, 1.0);
      final shape = CircleShape(body, 10.0);
      space
        ..addBody(body)
        ..addShape(shape);
      final str = space.toString();
      expect(str, contains('Space'));
      // Let space dispose everything
      space.dispose();
    });
  });
}
