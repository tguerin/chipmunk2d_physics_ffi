import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('BoundingBox', () {
    test('creates bounding box', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      expect(bb.left, -10.0);
      expect(bb.bottom, -10.0);
      expect(bb.right, 10.0);
      expect(bb.top, 10.0);
    });

    test('creates from extents', () {
      const center = Vector.zero;
      final bb = BoundingBox.forExtents(center, 10.0, 20.0);
      expect(bb.left, -10.0);
      expect(bb.bottom, -20.0);
      expect(bb.right, 10.0);
      expect(bb.top, 20.0);
    });

    test('creates for circle', () {
      const position = Vector.zero;
      final bb = BoundingBox.forCircle(position, 10.0);
      expect(bb.left, closeTo(-10.0, 0.001));
      expect(bb.bottom, closeTo(-10.0, 0.001));
      expect(bb.right, closeTo(10.0, 0.001));
      expect(bb.top, closeTo(10.0, 0.001));
    });

    test('fromNative and toNative roundtrip', () {
      const original = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      final native = original.toNative();
      final restored = BoundingBox.fromNative(native);
      expect(restored.left, closeTo(-10.0, 0.001));
      expect(restored.bottom, closeTo(-10.0, 0.001));
      expect(restored.right, closeTo(10.0, 0.001));
      expect(restored.top, closeTo(10.0, 0.001));
    });

    test('intersects', () {
      const bb1 = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      const bb2 = BoundingBox(left: -5, bottom: -5, right: 5, top: 5);
      const bb3 = BoundingBox(left: 20, bottom: 20, right: 30, top: 30);
      expect(bb1.intersects(bb2), true);
      expect(bb1.intersects(bb3), false);
    });

    test('containsBox', () {
      const bb1 = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      const bb2 = BoundingBox(left: -5, bottom: -5, right: 5, top: 5);
      const bb3 = BoundingBox(left: -15, bottom: -15, right: 15, top: 15);
      expect(bb1.containsBox(bb2), true);
      expect(bb1.containsBox(bb3), false);
    });

    test('containsPoint', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      expect(bb.containsPoint(Vector.zero), true);
      expect(bb.containsPoint(const Vector(5, 5)), true);
      expect(bb.containsPoint(const Vector(15, 15)), false);
    });

    test('merge', () {
      const bb1 = BoundingBox(left: -10, bottom: -10, right: 0, top: 0);
      const bb2 = BoundingBox(left: 0, bottom: 0, right: 10, top: 10);
      final merged = bb1.merge(bb2);
      expect(merged.left, -10.0);
      expect(merged.bottom, -10.0);
      expect(merged.right, 10.0);
      expect(merged.top, 10.0);
    });

    test('expand', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      final expanded = bb.expand(const Vector(20, 20));
      expect(expanded.right, 20.0);
      expect(expanded.top, 20.0);
    });

    test('center', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      final center = bb.center;
      expect(center.x, 0.0);
      expect(center.y, 0.0);
    });

    test('width', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      expect(bb.width, 20.0);
    });

    test('height', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      expect(bb.height, 20.0);
    });

    test('area', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      expect(bb.area, 400.0);
    });

    test('toString', () {
      const bb = BoundingBox(left: -10, bottom: -10, right: 10, top: 10);
      final str = bb.toString();
      expect(str, contains('BoundingBox'));
      expect(str, contains('left'));
    });
  });
}
