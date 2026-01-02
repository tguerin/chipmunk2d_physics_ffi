import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Moment', () {
    test('momentForCircle', () {
      const mass = 1.0;
      const r1 = 0.0; // inner radius
      const r2 = 10.0; // outer radius
      const offset = Vector.zero;
      final moment = momentForCircle(mass, r1, r2, offset);
      expect(moment, greaterThan(0.0));
    });

    test('areaForCircle', () {
      const r1 = 0.0;
      const r2 = 10.0;
      final area = areaForCircle(r1, r2);
      expect(area, closeTo(314.159, 1.0)); // π * r^2
    });

    test('momentForSegment', () {
      const mass = 1.0;
      const a = Vector.zero;
      const b = Vector(10, 0);
      const radius = 1.0;
      final moment = momentForSegment(mass, a, b, radius);
      expect(moment, greaterThan(0.0));
    });

    test('areaForSegment', () {
      const a = Vector.zero;
      const b = Vector(10, 0);
      const radius = 1.0;
      final area = areaForSegment(a, b, radius);
      expect(area, greaterThan(0.0));
    });

    test('momentForPoly', () {
      const mass = 1.0;
      final vertices = [
        Vector.zero,
        const Vector(10, 0),
        const Vector(10, 10),
        const Vector(0, 10),
      ];
      const offset = Vector.zero;
      const radius = 0.0;
      final moment = momentForPoly(mass, vertices, offset, radius);
      expect(moment, greaterThan(0.0));
    });

    test('areaForPoly', () {
      final vertices = [
        Vector.zero,
        const Vector(10, 0),
        const Vector(10, 10),
        const Vector(0, 10),
      ];
      const radius = 0.0;
      final area = areaForPoly(vertices, radius);
      expect(area, closeTo(100.0, 1.0)); // 10 * 10 square
    });

    test('centroidForPoly', () {
      final vertices = [
        Vector.zero,
        const Vector(10, 0),
        const Vector(10, 10),
        const Vector(0, 10),
      ];
      final centroid = centroidForPoly(vertices);
      expect(centroid.x, closeTo(5.0, 1.0));
      expect(centroid.y, closeTo(5.0, 1.0));
    });

    test('momentForBox', () {
      const mass = 1.0;
      const width = 10.0;
      const height = 20.0;
      final moment = momentForBox(mass, width, height);
      expect(moment, greaterThan(0.0));
    });

    test('momentForBox2', () {
      const mass = 1.0;
      final box = BoundingBox(left: -5, bottom: -10, right: 5, top: 10);
      final moment = momentForBox2(mass, box);
      expect(moment, greaterThan(0.0));
    });

    test('convexHull', () {
      final points = [
        Vector.zero,
        const Vector(10, 0),
        const Vector(10, 10),
        const Vector(0, 10),
        const Vector(5, 5), // interior point
      ];
      final hull = convexHull(points);
      expect(hull.length, lessThanOrEqualTo(points.length));
      expect(hull.length, greaterThanOrEqualTo(3));
    });

    test('convexHull with empty list', () {
      final hull = convexHull([]);
      expect(hull, isEmpty);
    });

    test('convexHull with single point', () {
      final points = [Vector.zero];
      final hull = convexHull(points);
      expect(hull.length, 1);
    });

    test('convexHull with tolerance', () {
      final points = [
        Vector.zero,
        const Vector(10, 0),
        const Vector(10, 10),
        const Vector(0, 10),
      ];
      final hull = convexHull(points, tolerance: 0.1);
      expect(hull.length, greaterThanOrEqualTo(3));
    });
  });
}
