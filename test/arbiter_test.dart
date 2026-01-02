import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Arbiter', () {
    test('ContactPoint creation', () {
      const point = ContactPoint(
        pointA: Vector(1, 2),
        pointB: Vector(3, 4),
        distance: -0.5,
      );
      expect(point.pointA.x, 1.0);
      expect(point.pointA.y, 2.0);
      expect(point.pointB.x, 3.0);
      expect(point.pointB.y, 4.0);
      expect(point.distance, -0.5);
    });

    test('ContactPointSet creation', () {
      const set = ContactPointSet(
        count: 2,
        normal: Vector(0, 1),
        points: [
          ContactPoint(
            pointA: Vector.zero,
            pointB: Vector.zero,
            distance: -0.1,
          ),
          ContactPoint(
            pointA: Vector(1, 0),
            pointB: Vector(1, 0),
            distance: -0.1,
          ),
        ],
      );
      expect(set.count, 2);
      expect(set.normal.y, 1.0);
      expect(set.points.length, 2);
    });

    // Note: Arbiter objects are typically created by Chipmunk during collisions
    // We can't directly create them, but we can test the properties if we
    // set up a collision scenario. For now, we'll test the data structures.
  });
}
