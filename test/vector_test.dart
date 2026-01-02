import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Vector', () {
    test('creates vector with x and y components', () {
      const vector = Vector(10, 20);
      expect(vector.x, 10);
      expect(vector.y, 20);
    });

    test('zero vector is (0, 0)', () {
      expect(Vector.zero.x, 0);
      expect(Vector.zero.y, 0);
    });

    test('vector addition', () {
      const v1 = Vector(1, 2);
      const v2 = Vector(3, 4);
      final result = v1 + v2;
      expect(result.x, 4.0);
      expect(result.y, 6.0);
    });

    test('vector subtraction', () {
      const v1 = Vector(5, 7);
      const v2 = Vector(2, 3);
      final result = v1 - v2;
      expect(result.x, 3);
      expect(result.y, 4);
    });

    test('scalar multiplication', () {
      const v = Vector(2, 3);
      final result = v * 2;
      expect(result.x, 4);
      expect(result.y, 6);
    });

    test('scalar division', () {
      const v = Vector(6, 8);
      final result = v / 2;
      expect(result.x, 3);
      expect(result.y, 4);
    });

    test('vector negation', () {
      const v = Vector(1, -2);
      final result = -v;
      expect(result.x, -1);
      expect(result.y, 2);
    });

    test('dot product', () {
      const v1 = Vector(1, 2);
      const v2 = Vector(3, 4);
      expect(v1.dot(v2), 11); // 1*3 + 2*4 = 11
    });

    test('dot product with zero vector', () {
      const v1 = Vector(1, 2);
      expect(v1.dot(Vector.zero), 0);
    });

    test('cross product', () {
      const v1 = Vector(1, 0);
      const v2 = Vector(0, 1);
      expect(v1.cross(v2), 1); // Right-hand rule
    });

    test('cross product is anti-commutative', () {
      const v1 = Vector(1, 2);
      const v2 = Vector(3, 4);
      expect(v1.cross(v2), -v2.cross(v1));
    });

    test('length calculation', () {
      const v = Vector(3, 4);
      expect(v.length, closeTo(5, 0.001)); // 3-4-5 triangle
    });

    test('length of zero vector', () {
      expect(Vector.zero.length, 0);
    });

    test('length squared', () {
      const v = Vector(3, 4);
      expect(v.lengthSquared, 25);
    });

    test('normalized vector', () {
      const v = Vector(3, 4);
      final normalized = v.normalized;
      expect(normalized.length, closeTo(1, 0.001));
      expect(normalized.x, closeTo(0.6, 0.001));
      expect(normalized.y, closeTo(0.8, 0.001));
    });

    test('normalized zero vector returns zero', () {
      final normalized = Vector.zero.normalized;
      expect(normalized.x, 0);
      expect(normalized.y, 0);
    });

    test('equality', () {
      const v1 = Vector(1, 2);
      const v2 = Vector(1, 2);
      const v3 = Vector(2, 3);
      expect(v1 == v2, true);
      expect(v1 == v3, false);
      expect(v1.hashCode == v2.hashCode, true);
    });

    test('toString', () {
      const v = Vector(1.5, 2.5);
      expect(v.toString(), 'Vector(1.5, 2.5)');
    });

    test('fromVect2 creates vector', () {
      const vect = (x: 10.0, y: 20.0);
      final vector = Vector.fromVect2(vect);
      expect(vector.x, closeTo(10, 0.001));
      expect(vector.y, closeTo(20, 0.001));
    });
  });
}
