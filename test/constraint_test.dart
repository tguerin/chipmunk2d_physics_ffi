import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Constraint', () {
    late Body bodyA;
    late Body bodyB;

    setUp(() {
      bodyA = Body.dynamic(1, 1);
      bodyB = Body.dynamic(1, 1);
    });

    tearDown(() {
      bodyA.dispose();
      bodyB.dispose();
    });

    group('PinJoint', () {
      test('creates pin joint', () {
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        );
        expect(joint, isNotNull);
        // Compare native pointers (now ints) since Body.fromNative creates new instances
        expect(joint.bodyA.native, bodyA.native);
        expect(joint.bodyB.native, bodyB.native);
        joint.dispose();
      });

      test('sets and gets anchors', () {
        final joint =
            PinJoint(
                bodyA,
                bodyB,
                Vector.zero,
                Vector.zero,
              )
              ..anchorA = const Vector(1, 0)
              ..anchorB = const Vector(0, 1);
        expect(joint.anchorA.x, closeTo(1, 0.001));
        expect(joint.anchorB.y, closeTo(1, 0.001));
        joint.dispose();
      });

      test('sets and gets distance', () {
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        )..distance = 10;
        expect(joint.distance, closeTo(10, 0.001));
        joint.dispose();
      });
    });

    group('SlideJoint', () {
      test('creates slide joint', () {
        final joint = SlideJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
          0,
          10,
        );
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets anchors', () {
        final joint =
            SlideJoint(
                bodyA,
                bodyB,
                Vector.zero,
                Vector.zero,
                0,
                10,
              )
              ..anchorA = const Vector(1, 0)
              ..anchorB = const Vector(0, 1);
        expect(joint.anchorA.x, closeTo(1, 0.001));
        expect(joint.anchorB.y, closeTo(1, 0.001));
        joint.dispose();
      });

      test('sets and gets min/max', () {
        final joint = SlideJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
          5,
          10,
        );
        expect(joint.min, closeTo(5, 0.001));
        expect(joint.max, closeTo(10, 0.001));
        joint
          ..min = 3.0
          ..max = 15.0;
        expect(joint.min, closeTo(3, 0.001));
        expect(joint.max, closeTo(15.0, 0.001));
        joint.dispose();
      });
    });

    group('PivotJoint', () {
      test('creates pivot joint at world point', () {
        final joint = PivotJoint.atWorldPoint(
          bodyA,
          bodyB,
          Vector.zero,
        );
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('creates pivot joint at local points', () {
        final joint = PivotJoint.atLocalPoints(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        );
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets anchors', () {
        final joint =
            PivotJoint.atWorldPoint(
                bodyA,
                bodyB,
                Vector.zero,
              )
              ..anchorA = const Vector(1, 0)
              ..anchorB = const Vector(0, 1);
        expect(joint.anchorA.x, closeTo(1, 0.001));
        expect(joint.anchorB.y, closeTo(1, 0.001));
        joint.dispose();
      });
    });

    group('GrooveJoint', () {
      test('creates groove joint', () {
        final joint = GrooveJoint(
          bodyA,
          bodyB,
          Vector.zero,
          const Vector(10, 0),
          const Vector(5, 0),
        );
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets groove endpoints', () {
        final joint =
            GrooveJoint(
                bodyA,
                bodyB,
                Vector.zero,
                const Vector(10, 0),
                const Vector(5, 0),
              )
              ..grooveA = const Vector(1, 0)
              ..grooveB = const Vector(9, 0);
        expect(joint.grooveA.x, closeTo(1, 0.001));
        expect(joint.grooveB.x, closeTo(9.0, 0.001));
        joint.dispose();
      });

      test('sets and gets anchor', () {
        final joint = GrooveJoint(
          bodyA,
          bodyB,
          Vector.zero,
          const Vector(10, 0),
          const Vector(5, 0),
        )..anchorB = const Vector(6, 0);
        expect(joint.anchorB.x, closeTo(6.0, 0.001));
        joint.dispose();
      });
    });

    group('DampedSpring', () {
      test('creates damped spring', () {
        final joint = DampedSpring(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
          10,
          1,
          0.5,
        );
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets anchors', () {
        final joint =
            DampedSpring(
                bodyA,
                bodyB,
                Vector.zero,
                Vector.zero,
                10,
                1,
                0.5,
              )
              ..anchorA = const Vector(1, 0)
              ..anchorB = const Vector(0, 1);
        expect(joint.anchorA.x, closeTo(1, 0.001));
        expect(joint.anchorB.y, closeTo(1, 0.001));
        joint.dispose();
      });

      test('sets and gets rest length', () {
        final joint = DampedSpring(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
          10,
          1,
          0.5,
        )..restLength = 15.0;
        expect(joint.restLength, closeTo(15.0, 0.001));
        joint.dispose();
      });

      test('sets and gets stiffness', () {
        final joint = DampedSpring(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
          10,
          1,
          0.5,
        )..stiffness = 2;
        expect(joint.stiffness, closeTo(2, 0.001));
        joint.dispose();
      });

      test('sets and gets damping', () {
        final joint = DampedSpring(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
          10,
          1,
          0.5,
        )..damping = 0.7;
        expect(joint.damping, closeTo(0.7, 0.001));
        joint.dispose();
      });
    });

    group('DampedRotarySpring', () {
      test('creates damped rotary spring', () {
        final joint = DampedRotarySpring(
          bodyA,
          bodyB,
          0,
          1,
          0.5,
        );
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets rest angle', () {
        final joint = DampedRotarySpring(
          bodyA,
          bodyB,
          0,
          1,
          0.5,
        )..restAngle = 1;
        expect(joint.restAngle, closeTo(1, 0.001));
        joint.dispose();
      });

      test('sets and gets stiffness', () {
        final joint = DampedRotarySpring(
          bodyA,
          bodyB,
          0,
          1,
          0.5,
        )..stiffness = 2;
        expect(joint.stiffness, closeTo(2, 0.001));
        joint.dispose();
      });

      test('sets and gets damping', () {
        final joint = DampedRotarySpring(
          bodyA,
          bodyB,
          0,
          1,
          0.5,
        )..damping = 0.7;
        expect(joint.damping, closeTo(0.7, 0.001));
        joint.dispose();
      });
    });

    group('RotaryLimitJoint', () {
      test('creates rotary limit joint', () {
        final joint = RotaryLimitJoint(bodyA, bodyB, -1, 1);
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets min/max', () {
        final joint = RotaryLimitJoint(bodyA, bodyB, -1, 1);
        expect(joint.min, closeTo(-1, 0.001));
        expect(joint.max, closeTo(1, 0.001));
        joint
          ..min = -2.0
          ..max = 2;
        expect(joint.min, closeTo(-2, 0.001));
        expect(joint.max, closeTo(2, 0.001));
        joint.dispose();
      });
    });

    group('RatchetJoint', () {
      test('creates ratchet joint', () {
        final joint = RatchetJoint(bodyA, bodyB, 0, 1);
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets phase', () {
        final joint = RatchetJoint(bodyA, bodyB, 0, 1)..phase = 0.5;
        expect(joint.phase, closeTo(0.5, 0.001));
        joint.dispose();
      });

      test('sets and gets ratchet', () {
        final joint = RatchetJoint(bodyA, bodyB, 0, 1)..ratchet = 2;
        expect(joint.ratchet, closeTo(2, 0.001));
        joint.dispose();
      });
    });

    group('GearJoint', () {
      test('creates gear joint', () {
        final joint = GearJoint(bodyA, bodyB, 0, 1);
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets phase', () {
        final joint = GearJoint(bodyA, bodyB, 0, 1)..phase = 0.5;
        expect(joint.phase, closeTo(0.5, 0.001));
        joint.dispose();
      });

      test('sets and gets ratio', () {
        final joint = GearJoint(bodyA, bodyB, 0, 1)..ratio = 2;
        expect(joint.ratio, closeTo(2, 0.001));
        joint.dispose();
      });
    });

    group('SimpleMotor', () {
      test('creates simple motor', () {
        final joint = SimpleMotor(bodyA, bodyB, 1);
        expect(joint, isNotNull);
        joint.dispose();
      });

      test('sets and gets rate', () {
        final joint = SimpleMotor(bodyA, bodyB, 1)..rate = 2;
        expect(joint.rate, closeTo(2, 0.001));
        joint.dispose();
      });
    });

    group('Constraint properties', () {
      test('sets and gets maxForce', () {
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        )..maxForce = 100.0;
        expect(joint.maxForce, closeTo(100.0, 0.001));
        joint.dispose();
      });

      test('sets and gets errorBias', () {
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        )..errorBias = 0.2;
        expect(joint.errorBias, closeTo(0.2, 0.001));
        joint.dispose();
      });

      test('sets and gets maxBias', () {
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        )..maxBias = 50.0;
        expect(joint.maxBias, closeTo(50.0, 0.001));
        joint.dispose();
      });

      test('sets and gets collideBodies', () {
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        )..collideBodies = true;
        expect(joint.collideBodies, true);
        joint.collideBodies = false;
        expect(joint.collideBodies, false);
        joint.dispose();
      });

      test('gets impulse', () {
        final space = Space();
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        );
        space
          ..addBody(bodyA)
          ..addBody(bodyB)
          ..addConstraint(joint)
          ..step(0.016);
        final impulse = joint.impulse;
        expect(impulse, isA<double>());
        space.dispose();
        joint.dispose();
      });

      test('disposed flag is set after disposal', () {
        final joint = PinJoint(
          bodyA,
          bodyB,
          Vector.zero,
          Vector.zero,
        );
        expect(joint.disposed, false);
        joint.dispose();
        expect(joint.disposed, true);
      });
    });
  });
}
