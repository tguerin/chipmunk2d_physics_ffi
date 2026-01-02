import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Body', () {
    test('creates dynamic body', () {
      final body = Body.dynamic(1.0, 1.0);
      expect(body, isNotNull);
      expect(body.type, BodyType.dynamic);
      body.dispose();
    });

    test('creates kinematic body', () {
      final body = Body.kinematic();
      expect(body, isNotNull);
      expect(body.type, BodyType.kinematic);
      body.dispose();
    });

    test('creates static body', () {
      final body = Body.static();
      expect(body, isNotNull);
      expect(body.type, BodyType.static);
      body.dispose();
    });

    test('sets and gets position', () {
      final body = Body.dynamic(1.0, 1.0);
      const position = Vector(10.0, 20.0);
      body.position = position;
      expect(body.position.x, closeTo(10.0, 0.001));
      expect(body.position.y, closeTo(20.0, 0.001));
      body.dispose();
    });

    test('fast position getters', () {
      final body = Body.dynamic(1.0, 1.0)..position = const Vector(10.0, 20.0);
      expect(body.positionX, closeTo(10.0, 0.001));
      expect(body.positionY, closeTo(20.0, 0.001));
      body.dispose();
    });

    test('sets and gets velocity', () {
      final body = Body.dynamic(1.0, 1.0);
      const velocity = Vector(5.0, -5.0);
      body.velocity = velocity;
      expect(body.velocity.x, closeTo(5.0, 0.001));
      expect(body.velocity.y, closeTo(-5.0, 0.001));
      body.dispose();
    });

    test('fast velocity getters', () {
      final body = Body.dynamic(1.0, 1.0)..velocity = const Vector(5.0, -5.0);
      expect(body.velocityX, closeTo(5.0, 0.001));
      expect(body.velocityY, closeTo(-5.0, 0.001));
      body.dispose();
    });

    test('sets and gets angle', () {
      final body = Body.dynamic(1.0, 1.0)..angle = 1.57; // ~90 degrees
      expect(body.angle, closeTo(1.57, 0.001));
      body.dispose();
    });

    test('sets and gets mass', () {
      final body = Body.dynamic(2.0, 1.0);
      expect(body.mass, closeTo(2.0, 0.001));
      body.mass = 3.0;
      expect(body.mass, closeTo(3.0, 0.001));
      body.dispose();
    });

    test('sets and gets moment', () {
      final body = Body.dynamic(1.0, 2.0);
      expect(body.moment, closeTo(2.0, 0.001));
      body.moment = 3.0;
      expect(body.moment, closeTo(3.0, 0.001));
      body.dispose();
    });

    test('sets and gets angular velocity', () {
      final body = Body.dynamic(1.0, 1.0)..angularVelocity = 1.5;
      expect(body.angularVelocity, closeTo(1.5, 0.001));
      body.dispose();
    });

    test('sets and gets center of gravity', () {
      const cog = Vector(0.5, 0.5);
      final body = Body.dynamic(1.0, 1.0)..centerOfGravity = cog;
      final retrieved = body.centerOfGravity;
      expect(retrieved.x, closeTo(0.5, 0.001));
      expect(retrieved.y, closeTo(0.5, 0.001));
      body.dispose();
    });

    test('sets and gets force', () {
      const force = Vector(10.0, 20.0);
      final body = Body.dynamic(1.0, 1.0)..force = force;
      final retrieved = body.force;
      expect(retrieved.x, closeTo(10.0, 0.001));
      expect(retrieved.y, closeTo(20.0, 0.001));
      body.dispose();
    });

    test('sets and gets torque', () {
      final body = Body.dynamic(1.0, 1.0)..torque = 5.0;
      expect(body.torque, closeTo(5.0, 0.001));
      body.dispose();
    });

    test('gets rotation vector', () {
      final body = Body.dynamic(1.0, 1.0)..angle = 0.0;
      final rotation = body.rotation;
      expect(rotation.x, closeTo(1.0, 0.001));
      expect(rotation.y, closeTo(0.0, 0.001));
      body.dispose();
    });

    test('sets body type', () {
      final body = Body.dynamic(1.0, 1.0)..type = BodyType.kinematic;
      expect(body.type, BodyType.kinematic);
      body.dispose();
    });

    test('isSleeping returns false for active body', () {
      final body = Body.dynamic(1.0, 1.0);
      expect(body.isSleeping, false);
      body.dispose();
    });

    test('activate wakes up body', () {
      final space = Space()..setSleepTimeThreshold(0.5); // Enable sleeping
      final body = Body.dynamic(1.0, 1.0);
      space.addBody(body);
      body.sleep();
      expect(body.isSleeping, true);
      body.activate();
      expect(body.isSleeping, false);
      space.dispose();
    });

    test('sleep puts body to sleep', () {
      final space = Space()..setSleepTimeThreshold(0.5); // Enable sleeping
      final body = Body.dynamic(1.0, 1.0);
      space.addBody(body);
      body.sleep();
      expect(body.isSleeping, true);
      space.dispose();
    });

    test('localToWorld conversion', () {
      const localPoint = Vector(1.0, 0.0);
      final body = Body.dynamic(1.0, 1.0)
        ..position = const Vector(10.0, 20.0)
        ..angle = 0.0;
      final worldPoint = body.localToWorld(localPoint);
      expect(worldPoint.x, closeTo(11.0, 0.001));
      expect(worldPoint.y, closeTo(20.0, 0.001));
      body.dispose();
    });

    test('worldToLocal conversion', () {
      const worldPoint = Vector(11.0, 20.0);
      final body = Body.dynamic(1.0, 1.0)
        ..position = const Vector(10.0, 20.0)
        ..angle = 0.0;
      final localPoint = body.worldToLocal(worldPoint);
      expect(localPoint.x, closeTo(1.0, 0.001));
      expect(localPoint.y, closeTo(0.0, 0.001));
      body.dispose();
    });

    test('applyForceAtWorldPoint', () {
      const force = Vector(10.0, 0.0);
      const point = Vector.zero;
      final body = Body.dynamic(1.0, 1.0);
      expect(() => body.applyForceAtWorldPoint(force, point), returnsNormally);
      body.dispose();
    });

    test('applyForceAtLocalPoint', () {
      const force = Vector(10.0, 0.0);
      const point = Vector.zero;
      final body = Body.dynamic(1.0, 1.0);
      expect(() => body.applyForceAtLocalPoint(force, point), returnsNormally);
      body.dispose();
    });

    test('applyImpulseAtWorldPoint', () {
      const impulse = Vector(10.0, 0.0);
      const point = Vector.zero;
      final body = Body.dynamic(1.0, 1.0);
      expect(() => body.applyImpulseAtWorldPoint(impulse, point), returnsNormally);
      body.dispose();
    });

    test('applyImpulseAtLocalPoint', () {
      const impulse = Vector(10.0, 0.0);
      const point = Vector.zero;
      final body = Body.dynamic(1.0, 1.0);
      expect(() => body.applyImpulseAtLocalPoint(impulse, point), returnsNormally);
      body.dispose();
    });

    test('getVelocityAtWorldPoint', () {
      const point = Vector.zero;
      final body = Body.dynamic(1.0, 1.0)..velocity = const Vector(5.0, 0.0);
      final velocity = body.getVelocityAtWorldPoint(point);
      expect(velocity.x, closeTo(5.0, 0.001));
      body.dispose();
    });

    test('getVelocityAtLocalPoint', () {
      const point = Vector.zero;
      final body = Body.dynamic(1.0, 1.0)..velocity = const Vector(5.0, 0.0);
      final velocity = body.getVelocityAtLocalPoint(point);
      expect(velocity.x, closeTo(5.0, 0.001));
      body.dispose();
    });

    test('kineticEnergy calculation', () {
      final body = Body.dynamic(1.0, 1.0)
        ..velocity = const Vector(10.0, 0.0)
        ..angularVelocity = 1.0;
      final ke = body.kineticEnergy;
      expect(ke, greaterThan(0.0));
      body.dispose();
    });

    test('throws error after disposal', () {
      final body = Body.dynamic(1.0, 1.0)..dispose();
      expect(() => body.position, throwsStateError);
      expect(() => body.velocity, throwsStateError);
      expect(() => body.angle, throwsStateError);
      expect(() => body.mass, throwsStateError);
    });

    test('fromNative creates body from pointer', () {
      final original = Body.dynamic(1.0, 1.0);
      final native = original.native;
      final restored = Body.fromNative(native);
      expect(restored.position.x, closeTo(original.position.x, 0.001));
      original.dispose();
    });

    test('toString', () {
      final body = Body.dynamic(1.0, 1.0)
        ..position = const Vector(10.0, 20.0)
        ..velocity = const Vector(5.0, 0.0)
        ..angle = 0.5;
      final str = body.toString();
      expect(str, contains('Body'));
      expect(str, contains('position'));
      body.dispose();
    });
  });
}
