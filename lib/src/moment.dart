import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/bounding_box.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';
import 'package:ffi/ffi.dart';

/// Utility functions for calculating moments of inertia and areas for shapes.

/// Calculate the moment of inertia for a circle.
/// [r1] and [r2] are the inner and outer diameters. A solid circle has an inner diameter of 0.
double momentForCircle(double mass, double r1, double r2, Vector offset) {
  return bindings.cp_moment_for_circle(mass, r1, r2, offset.toNative());
}

/// Calculate area of a hollow circle.
/// [r1] and [r2] are the inner and outer diameters. A solid circle has an inner diameter of 0.
double areaForCircle(double r1, double r2) {
  return bindings.cp_area_for_circle(r1, r2);
}

/// Calculate the moment of inertia for a line segment.
/// Beveling radius is not supported.
double momentForSegment(double mass, Vector a, Vector b, double radius) {
  return bindings.cp_moment_for_segment(mass, a.toNative(), b.toNative(), radius);
}

/// Calculate the area of a fattened (capsule shaped) line segment.
double areaForSegment(Vector a, Vector b, double radius) {
  return bindings.cp_area_for_segment(a.toNative(), b.toNative(), radius);
}

/// Calculate the moment of inertia for a solid polygon shape assuming its center of gravity is at its centroid.
/// The [offset] is added to each vertex.
double momentForPoly(double mass, List<Vector> vertices, Vector offset, double radius) {
  if (vertices.isEmpty) {
    throw ArgumentError('Vertices list cannot be empty');
  }
  final verts = malloc<bindings.cpVect>(vertices.length);
  for (var i = 0; i < vertices.length; i++) {
    verts[i] = vertices[i].toNative();
  }
  final result = bindings.cp_moment_for_poly(mass, vertices.length, verts, offset.toNative(), radius);
  malloc.free(verts);
  return result;
}

/// Calculate the signed area of a polygon. A clockwise winding gives positive area.
/// This is probably backwards from what you expect, but matches Chipmunk's winding for poly shapes.
double areaForPoly(List<Vector> vertices, double radius) {
  if (vertices.isEmpty) {
    throw ArgumentError('Vertices list cannot be empty');
  }
  final verts = malloc<bindings.cpVect>(vertices.length);
  for (var i = 0; i < vertices.length; i++) {
    verts[i] = vertices[i].toNative();
  }
  final result = bindings.cp_area_for_poly(vertices.length, verts, radius);
  malloc.free(verts);
  return result;
}

/// Calculate the natural centroid of a polygon.
Vector centroidForPoly(List<Vector> vertices) {
  if (vertices.isEmpty) {
    throw ArgumentError('Vertices list cannot be empty');
  }
  final verts = malloc<bindings.cpVect>(vertices.length);
  for (var i = 0; i < vertices.length; i++) {
    verts[i] = vertices[i].toNative();
  }
  final result = Vector.fromNative(bindings.cp_centroid_for_poly(vertices.length, verts));
  malloc.free(verts);
  return result;
}

/// Calculate the moment of inertia for a solid box.
double momentForBox(double mass, double width, double height) {
  return bindings.cp_moment_for_box(mass, width, height);
}

/// Calculate the moment of inertia for a solid box.
double momentForBox2(double mass, BoundingBox box) {
  return bindings.cp_moment_for_box2(mass, box.toNative());
}

/// Calculate the convex hull of a given set of points.
/// Returns the vertices of the convex hull.
/// [tolerance] is the allowed amount to shrink the hull when simplifying it. A tolerance of 0.0 creates an exact hull.
List<Vector> convexHull(List<Vector> points, {double tolerance = 0.0}) {
  if (points.isEmpty) {
    return [];
  }
  final inputVerts = malloc<bindings.cpVect>(points.length);
  final outputVerts = malloc<bindings.cpVect>(points.length);
  final firstPtr = malloc<ffi.Int>();
  for (var i = 0; i < points.length; i++) {
    inputVerts[i] = points[i].toNative();
  }
  final count = bindings.cp_convex_hull(points.length, inputVerts, outputVerts, firstPtr, tolerance);
  final result = <Vector>[];
  for (var i = 0; i < count; i++) {
    result.add(Vector.fromNative(outputVerts[i]));
  }
  malloc
    ..free(inputVerts)
    ..free(outputVerts)
    ..free(firstPtr);
  return result;
}
