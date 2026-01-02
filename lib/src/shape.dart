import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/body.dart';
import 'package:chipmunk2d_physics_ffi/src/bounding_box.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';
import 'package:ffi/ffi.dart';

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

  /// Converts to native cpShapeFilter struct.
  bindings.cpShapeFilter toNative() {
    return bindings.cp_shape_filter_new(group, categories, mask);
  }

  /// Creates a ShapeFilter from a native cpShapeFilter struct.
  factory ShapeFilter.fromNative(bindings.cpShapeFilter native) {
    return ShapeFilter(
      group: native.group,
      categories: native.categories,
      mask: native.mask,
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
  final ffi.Pointer<bindings.cpShape> _native;
  bool _disposed = false;

  /// Gets the native pointer (for internal use).
  ffi.Pointer<bindings.cpShape> get native {
    if (_disposed) throw StateError('Shape has been disposed');
    return _native;
  }

  /// Friction coefficient (0.0 = no friction, 1.0 = full friction).
  double get friction {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_friction(_native);
  }

  set friction(double friction) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_friction(_native, friction);
  }

  /// Elasticity (restitution) coefficient (0.0 = no bounce, 1.0 = full bounce).
  double get elasticity {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_elasticity(_native);
  }

  set elasticity(double elasticity) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_elasticity(_native, elasticity);
  }

  /// Collision filter that controls which objects this shape can collide with.
  ShapeFilter get filter {
    if (_disposed) throw StateError('Shape has been disposed');
    final nativeFilter = bindings.cp_shape_get_filter(_native);
    return ShapeFilter.fromNative(nativeFilter);
  }

  set filter(ShapeFilter filter) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_filter(_native, filter.toNative());
  }

  /// Mass of the shape if you are having Chipmunk calculate mass properties for you.
  double get mass {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_mass(_native);
  }

  set mass(double mass) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_mass(_native, mass);
  }

  /// Density of the shape if you are having Chipmunk calculate mass properties for you.
  double get density {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_density(_native);
  }

  set density(double density) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_density(_native, density);
  }

  /// Calculated moment of inertia for this shape.
  double get moment {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_moment(_native);
  }

  /// Calculated area of this shape.
  double get area {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_area(_native);
  }

  /// Calculated centroid of this shape.
  Vector get centerOfGravity {
    if (_disposed) throw StateError('Shape has been disposed');
    return Vector.fromNative(bindings.cp_shape_get_center_of_gravity(_native));
  }

  /// Bounding box that contains the shape given its current position and angle.
  BoundingBox get boundingBox {
    if (_disposed) throw StateError('Shape has been disposed');
    return BoundingBox.fromNative(bindings.cp_shape_get_bb(_native));
  }

  /// Whether the shape is set to be a sensor or not.
  /// Sensors trigger collision callbacks but don't produce collision responses.
  bool get sensor {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_sensor(_native) != 0;
  }

  set sensor(bool sensor) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_sensor(_native, sensor ? 1 : 0);
  }

  /// Surface velocity of this shape.
  /// Used for moving platforms or conveyor belts.
  Vector get surfaceVelocity {
    if (_disposed) throw StateError('Shape has been disposed');
    return Vector.fromNative(bindings.cp_shape_get_surface_velocity(_native));
  }

  set surfaceVelocity(Vector surfaceVelocity) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_surface_velocity(_native, surfaceVelocity.toNative());
  }

  /// Collision type of this shape.
  /// Used to identify different types of objects for collision callbacks.
  int get collisionType {
    if (_disposed) throw StateError('Shape has been disposed');
    return bindings.cp_shape_get_collision_type(_native);
  }

  set collisionType(int collisionType) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_collision_type(_native, collisionType);
  }

  /// The body this shape is connected to.
  Body? get body {
    if (_disposed) throw StateError('Shape has been disposed');
    final nativeBody = bindings.cp_shape_get_body(_native);
    if (nativeBody.address == 0) return null;
    return Body.fromNative(nativeBody);
  }

  set body(Body? body) {
    if (_disposed) throw StateError('Shape has been disposed');
    bindings.cp_shape_set_body(_native, body?.native ?? ffi.Pointer.fromAddress(0));
  }

  /// Disposes of this shape and frees its resources.
  void dispose() {
    if (!_disposed) {
      bindings.cp_shape_free(_native);
      _disposed = true;
    }
  }

  Shape._(this._native);
}

/// A circle shape.
class CircleShape extends Shape {
  /// Creates a circle shape attached to a body.
  factory CircleShape(Body body, double radius, {Vector offset = Vector.zero}) {
    final native = bindings.cp_circle_shape_new(
      body.native,
      radius,
      offset.toNative(),
    );
    if (native.address == 0) {
      throw Exception('Failed to create circle shape');
    }
    return CircleShape._(native);
  }

  CircleShape._(ffi.Pointer<bindings.cpShape> native) : super._(native);

  /// Get the offset of the circle shape from the body's center of gravity.
  Vector get offset {
    if (_disposed) throw StateError('CircleShape has been disposed');
    return Vector.fromNative(bindings.cp_circle_shape_get_offset(_native));
  }

  /// Get the radius of the circle shape.
  double get radius {
    if (_disposed) throw StateError('CircleShape has been disposed');
    return bindings.cp_circle_shape_get_radius(_native);
  }
}

/// A box (rectangle) shape.
class BoxShape extends Shape {
  /// Creates a box shape attached to a body.
  /// [radius] is the corner radius for rounded corners (0.0 for sharp corners).
  factory BoxShape(Body body, double width, double height, {double radius = 0.0}) {
    final native = bindings.cp_box_shape_new(body.native, width, height, radius);
    if (native.address == 0) {
      throw Exception('Failed to create box shape');
    }
    return BoxShape._(native);
  }

  BoxShape._(ffi.Pointer<bindings.cpShape> native) : super._(native);
}

/// A line segment shape.
class SegmentShape extends Shape {
  /// Creates a segment shape attached to a body.
  factory SegmentShape(Body body, Vector a, Vector b, double radius) {
    final native = bindings.cp_segment_shape_new(
      body.native,
      a.toNative(),
      b.toNative(),
      radius,
    );
    if (native.address == 0) {
      throw Exception('Failed to create segment shape');
    }
    return SegmentShape._(native);
  }

  SegmentShape._(ffi.Pointer<bindings.cpShape> native) : super._(native);

  /// Get the first endpoint of the segment shape.
  Vector get endpointA {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return Vector.fromNative(bindings.cp_segment_shape_get_a(_native));
  }

  /// Get the second endpoint of the segment shape.
  Vector get endpointB {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return Vector.fromNative(bindings.cp_segment_shape_get_b(_native));
  }

  /// Get the normal of the segment shape.
  Vector get normal {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return Vector.fromNative(bindings.cp_segment_shape_get_normal(_native));
  }

  /// Get the radius of the segment shape.
  double get radius {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    return bindings.cp_segment_shape_get_radius(_native);
  }

  /// Let Chipmunk know about the geometry of adjacent segments to avoid colliding with endcaps.
  /// This enables smoothed line collisions.
  void setNeighbors(Vector prev, Vector next) {
    if (_disposed) throw StateError('SegmentShape has been disposed');
    bindings.cp_segment_shape_set_neighbors(_native, prev.toNative(), next.toNative());
  }
}

/// A convex polygon shape.
class PolyShape extends Shape {
  /// Creates a polygon shape attached to a body.
  /// A convex hull will be created from the vertices.
  /// [transform] is an optional transform to apply to the vertices.
  /// If null, vertices are used as-is in body local coordinates.
  factory PolyShape(
    Body body,
    List<Vector> vertices, {
    double radius = 0.0,
    bindings.cpTransform? transform,
  }) {
    if (vertices.isEmpty) {
      throw ArgumentError('Vertices list cannot be empty');
    }
    final verts = malloc<bindings.cpVect>(vertices.length);
    for (var i = 0; i < vertices.length; i++) {
      verts[i] = vertices[i].toNative();
    }
    ffi.Pointer<bindings.cpShape> native;
    if (transform != null) {
      native = bindings.cp_poly_shape_new(
        body.native,
        vertices.length,
        verts,
        transform,
        radius,
      );
    } else {
      native = bindings.cp_poly_shape_new_raw(
        body.native,
        vertices.length,
        verts,
        radius,
      );
    }
    malloc.free(verts);
    if (native.address == 0) {
      throw Exception('Failed to create poly shape');
    }
    return PolyShape._(native);
  }

  PolyShape._(ffi.Pointer<bindings.cpShape> native) : super._(native);

  /// Get the number of vertices in the polygon shape.
  int get vertexCount {
    if (_disposed) throw StateError('PolyShape has been disposed');
    return bindings.cp_poly_shape_get_count(_native);
  }

  /// Get the vertex at the given index.
  ///
  /// [index] is the vertex index (0 to vertexCount - 1).
  Vector getVertex(int index) {
    if (_disposed) throw StateError('PolyShape has been disposed');
    if (index < 0 || index >= vertexCount) {
      throw RangeError('Index $index out of range [0, ${vertexCount - 1}]');
    }
    return Vector.fromNative(bindings.cp_poly_shape_get_vert(_native, index));
  }

  /// Get the radius of the polygon shape (for rounded corners).
  double get radius {
    if (_disposed) throw StateError('PolyShape has been disposed');
    return bindings.cp_poly_shape_get_radius(_native);
  }
}
