import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';
import 'package:test/test.dart';

void main() {
  group('Shape', () {
    late Body body;

    setUp(() {
      body = Body.dynamic(1.0, 1.0);
    });

    tearDown(() {
      body.dispose();
    });

    group('CircleShape', () {
      test('creates circle shape', () {
        final shape = CircleShape(body, 10.0);
        expect(shape, isNotNull);
        expect(shape.radius, closeTo(10.0, 0.001));
        shape.dispose();
      });

      test('creates circle shape with offset', () {
        const offset = Vector(5.0, 5.0);
        final shape = CircleShape(body, 10.0, offset: offset);
        expect(shape.offset.x, closeTo(5.0, 0.001));
        expect(shape.offset.y, closeTo(5.0, 0.001));
        shape.dispose();
      });

      test('gets radius', () {
        final shape = CircleShape(body, 15.0);
        expect(shape.radius, closeTo(15.0, 0.001));
        shape.dispose();
      });

      test('gets offset', () {
        const offset = Vector(2.0, 3.0);
        final shape = CircleShape(body, 10.0, offset: offset);
        final retrieved = shape.offset;
        expect(retrieved.x, closeTo(2.0, 0.001));
        expect(retrieved.y, closeTo(3.0, 0.001));
        shape.dispose();
      });
    });

    group('BoxShape', () {
      test('creates box shape', () {
        final shape = BoxShape(body, 20.0, 30.0);
        expect(shape, isNotNull);
        shape.dispose();
      });

      test('creates box shape with radius', () {
        final shape = BoxShape(body, 20.0, 30.0, radius: 2.0);
        expect(shape, isNotNull);
        shape.dispose();
      });
    });

    group('SegmentShape', () {
      test('creates segment shape', () {
        final shape = SegmentShape(
          body,
          Vector.zero,
          const Vector(100, 0),
          2.0,
        );
        expect(shape, isNotNull);
        expect(shape.radius, closeTo(2.0, 0.001));
        shape.dispose();
      });

      test('gets endpoints', () {
        const a = Vector.zero;
        const b = Vector(100, 0);
        final shape = SegmentShape(body, a, b, 2.0);
        expect(shape.endpointA.x, closeTo(0.0, 0.001));
        expect(shape.endpointB.x, closeTo(100.0, 0.001));
        shape.dispose();
      });

      test('gets normal', () {
        final shape = SegmentShape(
          body,
          Vector.zero,
          const Vector(100, 0),
          2.0,
        );
        final normal = shape.normal;
        expect(normal.length, closeTo(1.0, 0.001));
        shape.dispose();
      });

      test('setNeighbors', () {
        final shape = SegmentShape(
          body,
          Vector.zero,
          const Vector(100, 0),
          2.0,
        );
        expect(
          () => shape.setNeighbors(const Vector(-10, 0), const Vector(110, 0)),
          returnsNormally,
        );
        shape.dispose();
      });
    });

    group('PolyShape', () {
      test('creates poly shape', () {
        final vertices = [
          Vector.zero,
          const Vector(10, 0),
          const Vector(10, 10),
          const Vector(0, 10),
        ];
        final shape = PolyShape(body, vertices);
        expect(shape, isNotNull);
        expect(shape.vertexCount, greaterThanOrEqualTo(4));
        shape.dispose();
      });

      test('creates poly shape with radius', () {
        final vertices = [
          Vector.zero,
          const Vector(10, 0),
          const Vector(10, 10),
          const Vector(0, 10),
        ];
        final shape = PolyShape(body, vertices, radius: 1.0);
        expect(shape.radius, closeTo(1.0, 0.001));
        shape.dispose();
      });

      test('throws error for empty vertices', () {
        expect(
          () => PolyShape(body, []),
          throwsArgumentError,
        );
      });

      test('gets vertex count', () {
        final vertices = [
          Vector.zero,
          const Vector(10, 0),
          const Vector(10, 10),
          const Vector(0, 10),
        ];
        final shape = PolyShape(body, vertices);
        expect(shape.vertexCount, greaterThanOrEqualTo(4));
        shape.dispose();
      });

      test('gets vertex at index', () {
        final vertices = [
          Vector.zero,
          const Vector(10, 0),
          const Vector(10, 10),
          const Vector(0, 10),
        ];
        final shape = PolyShape(body, vertices);
        final vertex = shape.getVertex(0);
        expect(vertex, isNotNull);
        shape.dispose();
      });

      test('throws RangeError for invalid vertex index', () {
        final vertices = [
          Vector.zero,
          const Vector(10, 0),
        ];
        final shape = PolyShape(body, vertices);
        expect(() => shape.getVertex(-1), throwsRangeError);
        expect(() => shape.getVertex(100), throwsRangeError);
        shape.dispose();
      });
    });

    group('Shape properties', () {
      test('sets and gets friction', () {
        final shape = CircleShape(body, 10.0)..friction = 0.7;
        expect(shape.friction, closeTo(0.7, 0.001));
        shape.dispose();
      });

      test('sets and gets elasticity', () {
        final shape = CircleShape(body, 10.0)..elasticity = 0.5;
        expect(shape.elasticity, closeTo(0.5, 0.001));
        shape.dispose();
      });

      test('sets and gets mass', () {
        final shape = CircleShape(body, 10.0)..mass = 2.0;
        expect(shape.mass, closeTo(2.0, 0.001));
        shape.dispose();
      });

      test('sets and gets density', () {
        final shape = CircleShape(body, 10.0)..density = 1.5;
        expect(shape.density, closeTo(1.5, 0.001));
        shape.dispose();
      });

      test('gets moment', () {
        final shape = CircleShape(body, 10.0);
        final moment = shape.moment;
        // Moment can be 0.0 if shape isn't in a space or mass properties aren't set
        expect(moment, greaterThanOrEqualTo(0.0));
        shape.dispose();
      });

      test('gets area', () {
        final shape = CircleShape(body, 10.0);
        final area = shape.area;
        expect(area, greaterThan(0.0));
        shape.dispose();
      });

      test('gets center of gravity', () {
        final shape = CircleShape(body, 10.0);
        final cog = shape.centerOfGravity;
        expect(cog, isNotNull);
        shape.dispose();
      });

      test('gets bounding box', () {
        final shape = CircleShape(body, 10.0);
        body.position = Vector.zero;
        final bb = shape.boundingBox;
        expect(bb, isNotNull);
        shape.dispose();
      });

      test('sets and gets sensor flag', () {
        final shape = CircleShape(body, 10.0)..sensor = true;
        expect(shape.sensor, true);
        shape.sensor = false;
        expect(shape.sensor, false);
        shape.dispose();
      });

      test('sets and gets surface velocity', () {
        final shape = CircleShape(body, 10.0);
        const surfaceVel = Vector(5.0, 0.0);
        shape.surfaceVelocity = surfaceVel;
        final retrieved = shape.surfaceVelocity;
        expect(retrieved.x, closeTo(5.0, 0.001));
        shape.dispose();
      });

      test('sets and gets collision type', () {
        final shape = CircleShape(body, 10.0)..collisionType = 1;
        expect(shape.collisionType, 1);
        shape.dispose();
      });

      test('sets and gets filter', () {
        final shape = CircleShape(body, 10.0);
        final filter = ShapeFilter(group: 1, categories: 2, mask: 3);
        shape.filter = filter;
        final retrieved = shape.filter;
        expect(retrieved.group, 1);
        expect(retrieved.categories, 2);
        expect(retrieved.mask, 3);
        shape.dispose();
      });

      test('gets body', () {
        final shape = CircleShape(body, 10.0);
        final retrievedBody = shape.body;
        expect(retrievedBody, isNotNull);
        shape.dispose();
      });
    });

    // Note: pointQuery and segmentQuery methods are not yet implemented
    // on Shape. These tests are commented out until those features are added.

    test('throws error after disposal', () {
      final shape = CircleShape(body, 10.0)..dispose();
      expect(() => shape.friction, throwsStateError);
      expect(() => shape.elasticity, throwsStateError);
      expect(() => shape.radius, throwsStateError);
    });
  });

  group('ShapeFilter', () {
    test('creates filter with default values', () {
      const filter = ShapeFilter();
      expect(filter.group, 0);
      expect(filter.categories, 0xFFFFFFFF);
      expect(filter.mask, 0xFFFFFFFF);
    });

    test('creates filter with custom values', () {
      const filter = ShapeFilter(group: 1, categories: 2, mask: 3);
      expect(filter.group, 1);
      expect(filter.categories, 2);
      expect(filter.mask, 3);
    });

    test('creates all filter', () {
      const filter = ShapeFilter.all();
      expect(filter.group, 0);
      expect(filter.categories, 0xFFFFFFFF);
      expect(filter.mask, 0xFFFFFFFF);
    });

    test('creates none filter', () {
      const filter = ShapeFilter.none();
      expect(filter.group, 0);
      expect(filter.categories, 0);
      expect(filter.mask, 0);
    });

    test('fromNative creates filter with all values', () {
      const original = ShapeFilter(group: 1, categories: 2, mask: 3);
      final restored = ShapeFilter.fromNative(original.group, original.categories, original.mask);
      expect(restored.group, 1);
      expect(restored.categories, 2);
      expect(restored.mask, 3);
    });

    test('toString', () {
      const filter = ShapeFilter(group: 1, categories: 2, mask: 3);
      final str = filter.toString();
      expect(str, contains('ShapeFilter'));
      expect(str, contains('group'));
    });
  });
}
