import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/shape.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Information about a point query result.
///
/// Point queries test if a point is within a shape or find the nearest point on a shape.
class PointQueryInfo {
  /// The nearest shape, or null if no shape was within range.
  final Shape? shape;

  /// The closest point on the shape's surface (in world space coordinates).
  final Vector point;

  /// The distance to the point. The distance is negative if the point is inside the shape.
  final double distance;

  /// The gradient of the signed distance function.
  /// The value should be similar to point/distance, but accurate even for very small values of distance.
  final Vector gradient;

  /// Creates a new PointQueryInfo.
  const PointQueryInfo({
    required this.point,
    required this.distance,
    required this.gradient,
    this.shape,
  });

  /// Creates a PointQueryInfo from a native cpPointQueryInfo struct.
  factory PointQueryInfo.fromNative(bindings.cpPointQueryInfo native) {
    // Note: We can't create a Shape from a pointer without knowing its type,
    // so we'll leave shape as null for now. Users can query the shape separately if needed.
    return PointQueryInfo(
      point: Vector.fromNative(native.point),
      distance: native.distance,
      gradient: Vector.fromNative(native.gradient),
    );
  }

  /// Converts this PointQueryInfo to a native cpPointQueryInfo struct.
  bindings.cpPointQueryInfo toNative() {
    final info = ffi.Struct.create<bindings.cpPointQueryInfo>()
      ..shape = shape?.native ?? ffi.Pointer.fromAddress(0)
      ..point = point.toNative()
      ..distance = distance
      ..gradient = gradient.toNative();
    return info;
  }
}

/// Information about a segment query result.
///
/// Segment queries test if a line segment intersects a shape.
class SegmentQueryInfo {
  /// The shape that was hit, or null if no collision occurred.
  final Shape? shape;

  /// The point of impact.
  final Vector point;

  /// The normal of the surface hit.
  final Vector normal;

  /// The normalized distance along the query segment in the range [0, 1].
  final double alpha;

  /// Creates a new SegmentQueryInfo.
  const SegmentQueryInfo({
    required this.point,
    required this.normal,
    required this.alpha,
    this.shape,
  });

  /// Creates a SegmentQueryInfo from a native cpSegmentQueryInfo struct.
  factory SegmentQueryInfo.fromNative(bindings.cpSegmentQueryInfo native) {
    // Note: We can't create a Shape from a pointer without knowing its type,
    // so we'll leave shape as null for now. Users can query the shape separately if needed.
    return SegmentQueryInfo(
      point: Vector.fromNative(native.point),
      normal: Vector.fromNative(native.normal),
      alpha: native.alpha,
    );
  }

  /// Converts this SegmentQueryInfo to a native cpSegmentQueryInfo struct.
  bindings.cpSegmentQueryInfo toNative() {
    final info = ffi.Struct.create<bindings.cpSegmentQueryInfo>()
      ..shape = shape?.native ?? ffi.Pointer.fromAddress(0)
      ..point = point.toNative()
      ..normal = normal.toNative()
      ..alpha = alpha;
    return info;
  }
}
