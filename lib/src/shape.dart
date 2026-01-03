import 'package:chipmunk2d_physics_ffi/src/body.dart';
import 'package:chipmunk2d_physics_ffi/src/bounding_box.dart';
import 'package:chipmunk2d_physics_ffi/src/platform/chipmunk_bindings.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Collision filter for shapes that controls which objects can collide.
///
/// Two objects with the same non-zero group value do not collide.
/// This is generally used to group objects in a composite object together to disable self collisions.
///
/// The category/mask combinations of both objects in a collision must agree for a collision to occur.
class ShapeFilter {
  /// Two objects with the same non-zero group value do not collide.
  final int group;

  /// A bitmask of user definable categories that this object belongs to.
  final int categories;

  /// A bitmask of user definable category types that this object collides with.
  final int mask;

  /// Creates a new collision filter.
  const ShapeFilter({
    this.group = 0,
    this.categories = 0xFFFFFFFF,
    this.mask = 0xFFFFFFFF,
  });

  /// Creates a filter that collides with everything (default).
  const ShapeFilter.all() : group = 0, categories = 0xFFFFFFFF, mask = 0xFFFFFFFF;

  /// Creates a filter that collides with nothing.
  const ShapeFilter.none() : group = 0, categories = 0, mask = 0;

  /// Creates a filter that only collides with objects in the specified category.
  ///
  /// [category] is the category bit to match.
  factory ShapeFilter.category(int category) {
    return ShapeFilter(
      categories: category,
      mask: category,
    );
  }

  /// Creates a filter that collides with all categories except the specified one.
  ///
  /// [excludedCategory] is the category bit to exclude.
  factory ShapeFilter.excludeCategory(int excludedCategory) {
    return ShapeFilter(
      mask: 0xFFFFFFFF & ~excludedCategory,
    );
  }

  /// Creates a filter for a group that doesn't collide with itself.
  ///
  /// [groupValue] is the group identifier. Objects with the same non-zero group value do not collide.
  factory ShapeFilter.group(int groupValue) {
    return ShapeFilter(
      group: groupValue,
    );
  }

  /// Creates a ShapeFilter from native filter values.
  /// @param group The collision group.
  /// @param categories The collision categories.
  /// @param mask The collision mask.
  factory ShapeFilter.fromNative(int group, int categories, int mask) {
    return ShapeFilter(
      group: group,
      categories: categories,
      mask: mask,
    );
  }

  @override
  String toString() =>
      'ShapeFilter(group: $group, categories: 0x${categories.toRadixString(16)}, mask: 0x${mask.toRadixString(16)})';
}

/// Base class for collision shapes.
///
/// The Shape struct defines the shape of a rigid body. Shapes define the
/// collision geometry of bodies and can be attached to bodies to enable
/// collision detection.
///
/// All shapes have properties for:
/// - Friction: How much friction the shape has (0.0 = no friction, 1.0 = full friction)
/// - Elasticity: How bouncy the shape is (0.0 = no bounce, 1.0 = full bounce)
/// - Filter: Collision filtering to control which objects can collide
/// - Sensor: Whether the shape is a sensor (triggers callbacks but no collision response)
///
/// See: [Chipmunk2D Shape Documentation](https://chipmunk-physics.net/release/ Chipmunk2D-Docs/#cpShape)
abstract class Shape {
  final int _native;
  bool _disposed = false;

  /// Gets the native pointer (for internal use).
  int get native {
    if (_disposed) throw StateError('Shape has been disposed');
    return _native;
  }

  /// Creates a Shape from a native pointer (for internal use).
  Shape.fromNative(this._native);

  /// Friction coefficient (0.0 = no friction, 1.0 = full friction).
  double get friction {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetFriction(_native);
  }

  set friction(double friction) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetFriction(_native, friction);
  }

  /// Elasticity (restitution) coefficient (0.0 = no bounce, 1.0 = full bounce).
  double get elasticity {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetElasticity(_native);
  }

  set elasticity(double elasticity) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetElasticity(_native, elasticity);
  }

  /// Collision filter that controls which objects this shape can collide with.
  ShapeFilter get filter {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetFilter(_native);
  }

  set filter(ShapeFilter filter) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetFilter(_native, filter.group, filter.categories, filter.mask);
  }

  /// Mass of the shape if you are having Chipmunk calculate mass properties for you.
  double get mass {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetMass(_native);
  }

  set mass(double mass) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetMass(_native, mass);
  }

  /// Density of the shape if you are having Chipmunk calculate mass properties for you.
  double get density {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetDensity(_native);
  }

  set density(double density) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetDensity(_native, density);
  }

  /// Calculated moment of inertia for this shape.
  double get moment {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetMoment(_native);
  }

  /// Calculated area of this shape.
  double get area {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetArea(_native);
  }

  /// Calculated centroid of this shape.
  Vector get centerOfGravity {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetCenterOfGravity(_native);
  }

  /// Bounding box that contains the shape given its current position and angle.
  BoundingBox get boundingBox {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetBB(_native);
  }

  /// Whether the shape is set to be a sensor or not.
  /// Sensors trigger collision callbacks but don't produce collision responses.
  bool get sensor {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetSensor(_native) != 0;
  }

  set sensor(bool sensor) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetSensor(_native, sensor ? 1 : 0);
  }

  /// Surface velocity of this shape.
  /// Used for moving platforms or conveyor belts.
  Vector get surfaceVelocity {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetSurfaceVelocity(_native);
  }

  set surfaceVelocity(Vector surfaceVelocity) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetSurfaceVelocity(_native, surfaceVelocity.x, surfaceVelocity.y);
  }

  /// Collision type of this shape.
  /// Used to identify different types of objects for collision callbacks.
  int get collisionType {
    if (_disposed) throw StateError('Shape has been disposed');
    return cpShapeGetCollisionType(_native);
  }

  set collisionType(int collisionType) {
    if (_disposed) throw StateError('Shape has been disposed');
    cpShapeSetCollisionType(_native, collisionType);
  }

  /// The body this shape is connected to.
  Body? get body {
    if (_disposed) throw StateError('Shape has been disposed');
    final nativeBody = cpShapeGetBody(_native);
    if (nativeBody == 0) return null;
    return Body.fromNative(nativeBody);
  }

  // Note: cpShapeSetBody is not commonly used - shapes are typically
  // created with a body and not changed. Add if needed.

  /// Disposes of this shape and frees its resources.
  void dispose() {
    if (!_disposed) {
      cpShapeFree(_native);
      _disposed = true;
    }
  }

  Shape._(this._native);
}

/// A circle shape.
class CircleShape extends Shape {
  /// Creates a circle shape attached to a body.
  factory CircleShape(Body body, double radius, {Vector offset = Vector.zero}) {
    final native = cpCircleShapeNew(body.native, radius, offset.x, offset.y);
    if (native == 0) {
      throw Exception('Failed to create circle shape');
    }
    return CircleShape._(native);
  }

  CircleShape._(super._native) : super._();

  /// Get the offset of the circle shape from the body's center of gravity.
  Vector get offset {
    if (_disposed) throw StateError('CircleShape has been disposed');
    return cpCircleShapeGetOffset(_native);
  }

  /// Get the radius of the circle shape.
  double get radius {
    if (_disposed) throw StateError('CircleShape has been disposed');
    return cpCircleShapeGetRadius(_native);
  }
}

/// A box (rectangle) shape.
class BoxShape extends Shape {
  /// Creates a box shape attached to a body.
  /// [radius] is the corner radius for rounded corners (0.0 for sharp corners).
  factory BoxShape(Body body, double width, double height, {double radius = 0.0}) {
    final native = cpPolyShapeNewBox(body.native, width, height, radius);
    if (native == 0) {
      throw Exception('Failed to create box shape');
    }
    return BoxShape._(native);
  }

  BoxShape._(super._native) : super._();
}

/// A line segment shape.
class SegmentShape extends Shape {
  /// Creates a segment shape attached to a body.
  factory SegmentShape(Body body, Vector a, Vector b, double radius) {
    final native = cpSegmentShapeNew(body.native, a.x, a.y, b.x, b.y, radius);
    if (native == 0) {
      throw Exception('Failed to create segment shape');
    }
    return SegmentShape._(native);
  }

  SegmentShape._(super._native) : super._();

  /// Get the first endpoint of the segment shape.
  Vector get endpointA {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return cpSegmentShapeGetA(_native);
  }

  /// Get the second endpoint of the segment shape.
  Vector get endpointB {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return cpSegmentShapeGetB(_native);
  }

  /// Get the normal of the segment shape.
  Vector get normal {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return cpSegmentShapeGetNormal(_native);
  }

  /// Get the radius of the segment shape.
  double get radius {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return cpSegmentShapeGetRadius(_native);
  }

  /// Let Chipmunk know about the geometry of adjacent segments to avoid colliding with endcaps.
  /// This enables smoothed line collisions.
  void setNeighbors(Vector prev, Vector next) {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    cpSegmentShapeSetNeighbors(_native, prev.x, prev.y, next.x, next.y);
  }
}

/// A convex polygon shape.
class PolyShape extends Shape {
  /// Creates a polygon shape attached to a body.
  /// A convex hull will be created from the vertices.
  factory PolyShape(
    Body body,
    List<Vector> vertices, {
    double radius = 0.0,
  }) {
    if (vertices.isEmpty) {
      throw ArgumentError('Vertices list cannot be empty');
    }
    // Flatten vertices to a list of doubles [x1, y1, x2, y2, ...]
    final flatVerts = <double>[];
    for (final v in vertices) {
      flatVerts
        ..add(v.x)
        ..add(v.y);
    }
    final native = cpPolyShapeNew(body.native, flatVerts, radius);
    if (native == 0) {
      throw Exception('Failed to create poly shape');
    }
    return PolyShape._(native);
  }

  PolyShape._(super._native) : super._();

  /// Get the number of vertices in the polygon shape.
  int get vertexCount {
    if (_disposed) throw StateError('PolyShape has been disposed');
    return cpPolyShapeGetCount(_native);
  }

  /// Get the vertex at the given index.
  ///
  /// [index] is the vertex index (0 to vertexCount - 1).
  Vector getVertex(int index) {
    if (_disposed) throw StateError('PolyShape has been disposed');
    if (index < 0 || index >= vertexCount) {
      throw RangeError('Index $index out of range [0, ${vertexCount - 1}]');
    }
    return cpPolyShapeGetVert(_native, index);
  }

  /// Get the radius of the polygon shape (for rounded corners).
  double get radius {
    if (_disposed) throw StateError('PolyShape has been disposed');
    return cpPolyShapeGetRadius(_native);
  }
}
