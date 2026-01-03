import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Information about a contact point in a collision.
class ContactPoint {
  /// Position of the contact on the surface of the first shape.
  final Vector pointA;

  /// Position of the contact on the surface of the second shape.
  final Vector pointB;

  /// Penetration distance of the two shapes. Overlapping means it will be negative.
  final double distance;

  /// Creates a contact point with the given properties.
  const ContactPoint({
    required this.pointA,
    required this.pointB,
    required this.distance,
  });
}

/// A set of contact points from a collision.
class ContactPointSet {
  /// The number of contact points in the set.
  final int count;

  /// The normal of the collision.
  final Vector normal;

  /// The array of contact points.
  final List<ContactPoint> points;

  /// Creates a contact point set with the given properties.
  const ContactPointSet({
    required this.count,
    required this.normal,
    required this.points,
  });
}

/// An arbiter tracks pairs of colliding shapes.
///
/// Arbiters are passed to collision callbacks and contain information about the collision.
/// They should not be stored or referenced outside of callbacks.
///
/// Note: Arbiter methods are available in the generated bindings but are not yet
/// exposed in the platform bindings layer. They will be added when collision callbacks
/// are fully implemented.
class Arbiter {
  final int _native;

  /// Creates an Arbiter from a native pointer (for internal use).
  Arbiter.fromNative(this._native);

  /// Gets the native pointer (for internal use).
  int get native => _native;
}
