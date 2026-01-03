import 'package:chipmunk2d_physics_ffi/src/bounding_box.dart';
import 'package:chipmunk2d_physics_ffi/src/platform/chipmunk_bindings.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Utility functions for calculating moments of inertia and areas for shapes.

/// Calculate the moment of inertia for a circle.
/// [r1] and [r2] are the inner and outer diameters. A solid circle has an inner diameter of 0.
double momentForCircle(double mass, double r1, double r2, Vector offset) {
  return cpMomentForCircle(mass, r1, r2, offset.x, offset.y);
}

/// Calculate area of a hollow circle.
/// [r1] and [r2] are the inner and outer diameters. A solid circle has an inner diameter of 0.
double areaForCircle(double r1, double r2) {
  return cpAreaForCircle(r1, r2);
}

/// Calculate the moment of inertia for a line segment.
double momentForSegment(double mass, Vector a, Vector b, double radius) {
  return cpMomentForSegment(mass, a.x, a.y, b.x, b.y, radius);
}

/// Calculate the area of a fattened (capsule shaped) line segment.
double areaForSegment(Vector a, Vector b, double radius) {
  return cpAreaForSegment(a.x, a.y, b.x, b.y, radius);
}

/// Calculate the moment of inertia for a solid polygon shape.
double momentForPoly(double mass, List<Vector> vertices, Vector offset, double radius) {
  if (vertices.isEmpty) {
    throw ArgumentError('Vertices list cannot be empty');
  }
  final flatVerts = <double>[];
  for (final v in vertices) {
    flatVerts
      ..add(v.x)
      ..add(v.y);
  }
  return cpMomentForPoly(mass, flatVerts, offset.x, offset.y, radius);
}

/// Calculate the signed area of a polygon.
double areaForPoly(List<Vector> vertices, double radius) {
  if (vertices.isEmpty) {
    throw ArgumentError('Vertices list cannot be empty');
  }
  final flatVerts = <double>[];
  for (final v in vertices) {
    flatVerts
      ..add(v.x)
      ..add(v.y);
  }
  return cpAreaForPoly(flatVerts, radius);
}

/// Calculate the centroid of a polygon.
Vector centroidForPoly(List<Vector> vertices) {
  if (vertices.isEmpty) {
    throw ArgumentError('Vertices list cannot be empty');
  }
  final flatVerts = <double>[];
  for (final v in vertices) {
    flatVerts
      ..add(v.x)
      ..add(v.y);
  }
  return cpCentroidForPoly(flatVerts);
}

/// Calculate the moment of inertia for a solid box.
double momentForBox(double mass, double width, double height) {
  return cpMomentForBox(mass, width, height);
}

/// Calculate the moment of inertia for a box defined by a bounding box.
double momentForBox2(double mass, BoundingBox box) {
  return cpMomentForBox2(mass, box.left, box.bottom, box.right, box.top);
}

/// Calculate the convex hull of a set of points.
List<Vector> convexHull(List<Vector> points, {double tolerance = 0.0}) {
  final flatPoints = <double>[];
  for (final p in points) {
    flatPoints
      ..add(p.x)
      ..add(p.y);
  }
  final flatHull = cpConvexHull(flatPoints, tolerance: tolerance);
  final hull = <Vector>[];
  for (var i = 0; i < flatHull.length; i += 2) {
    hull.add(Vector(flatHull[i], flatHull[i + 1]));
  }
  return hull;
}
