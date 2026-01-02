import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Information about a point query result.
///
/// Point queries test if a point is within a shape or find the nearest point on a shape.
class PointQueryInfo {
  /// Creates a new PointQueryInfo.
  const PointQueryInfo({
    required this.shapePtr,
    required this.point,
    required this.distance,
    required this.gradient,
  });

  /// The shape pointer (as int), or 0 if no shape was within range.
  final int shapePtr;

  /// The closest point on the shape's surface (in world space coordinates).
  final Vector point;

  /// The distance to the point. The distance is negative if the point is inside the shape.
  final double distance;

  /// The gradient of the signed distance function.
  final Vector gradient;
}

/// Information about a segment query result.
///
/// Segment queries test if a line segment intersects a shape.
class SegmentQueryInfo {
  /// Creates a new SegmentQueryInfo.
  const SegmentQueryInfo({
    required this.shapePtr,
    required this.point,
    required this.normal,
    required this.alpha,
  });

  /// The shape pointer (as int), or 0 if no collision occurred.
  final int shapePtr;

  /// The point of first intersection.
  final Vector point;

  /// The outward facing normal of the shape at the point of impact.
  final Vector normal;

  /// The normalized distance along the query segment in the range [0, 1].
  final double alpha;
}
