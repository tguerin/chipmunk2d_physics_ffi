import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/body.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';
import 'package:ffi/ffi.dart';

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
/// Arbiters are used in conjunction with collision handler callbacks
/// allowing you to retrieve information on the collision or change it.
/// A unique arbiter value is used for each pair of colliding objects. It persists until the shapes separate.
class Arbiter {
  final ffi.Pointer<bindings.cpArbiter> _native;

  /// Creates an Arbiter from a native pointer (for internal use).
  Arbiter._(this._native);

  /// Gets the native pointer (for internal use).
  ffi.Pointer<bindings.cpArbiter> get native => _native;

  /// Get the restitution (elasticity) that will be applied to the pair of colliding objects.
  double get restitution {
    return bindings.cp_arbiter_get_restitution(_native);
  }

  /// Override the restitution (elasticity) that will be applied to the pair of colliding objects.
  set restitution(double restitution) {
    bindings.cp_arbiter_set_restitution(_native, restitution);
  }

  /// Get the friction coefficient that will be applied to the pair of colliding objects.
  double get friction {
    return bindings.cp_arbiter_get_friction(_native);
  }

  /// Override the friction coefficient that will be applied to the pair of colliding objects.
  set friction(double friction) {
    bindings.cp_arbiter_set_friction(_native, friction);
  }

  /// Get the relative surface velocity of the two shapes in contact.
  Vector get surfaceVelocity {
    return Vector.fromNative(bindings.cp_arbiter_get_surface_velocity(_native));
  }

  /// Override the relative surface velocity of the two shapes in contact.
  set surfaceVelocity(Vector vr) {
    bindings.cp_arbiter_set_surface_velocity(_native, vr.toNative());
  }

  /// Calculate the total impulse including the friction that was applied by this arbiter.
  /// This function should only be called from a post-solve, post-step or cpBodyEachArbiter callback.
  Vector get totalImpulse {
    return Vector.fromNative(bindings.cp_arbiter_total_impulse(_native));
  }

  /// Calculate the amount of energy lost in a collision including static, but not dynamic friction.
  /// This function should only be called from a post-solve, post-step or cpBodyEachArbiter callback.
  double get totalKineticEnergy {
    return bindings.cp_arbiter_total_ke(_native);
  }

  /// Mark a collision pair to be ignored until the two objects separate.
  /// Pre-solve and post-solve callbacks will not be called, but the separate callback will be called.
  bool ignore() {
    return bindings.cp_arbiter_ignore(_native) != 0;
  }

  /// Return the colliding shapes involved for this arbiter.
  /// The order of their collision_type values will match
  /// the order set when the collision handler was registered.
  /// Returns the native pointers - you'll need to match these to your Shape objects.
  (ffi.Pointer<bindings.cpShape>, ffi.Pointer<bindings.cpShape>) getShapes() {
    final aPtr = malloc<ffi.Pointer<bindings.cpShape>>();
    final bPtr = malloc<ffi.Pointer<bindings.cpShape>>();
    bindings.cp_arbiter_get_shapes(_native, aPtr, bPtr);
    final shapeA = aPtr.value;
    final shapeB = bPtr.value;
    malloc
      ..free(aPtr)
      ..free(bPtr);
    return (shapeA, shapeB);
  }

  /// Return the colliding bodies involved for this arbiter.
  /// The order of the collision_type the bodies are associated with values will match
  /// the order set when the collision handler was registered.
  (Body, Body) getBodies() {
    final aPtr = malloc<ffi.Pointer<bindings.cpBody>>();
    final bPtr = malloc<ffi.Pointer<bindings.cpBody>>();
    bindings.cp_arbiter_get_bodies(_native, aPtr, bPtr);
    final bodyA = Body.fromNative(aPtr.value);
    final bodyB = Body.fromNative(bPtr.value);
    malloc
      ..free(aPtr)
      ..free(bPtr);
    return (bodyA, bodyB);
  }

  /// Return a contact set from an arbiter.
  ContactPointSet getContactPointSet() {
    final nativeSet = bindings.cp_arbiter_get_contact_point_set(_native);
    final points = <ContactPoint>[];
    for (var i = 0; i < nativeSet.count; i++) {
      final point = nativeSet.points[i];
      points.add(
        ContactPoint(
          pointA: Vector.fromNative(point.pointA),
          pointB: Vector.fromNative(point.pointB),
          distance: point.distance,
        ),
      );
    }
    return ContactPointSet(
      count: nativeSet.count,
      normal: Vector.fromNative(nativeSet.normal),
      points: points,
    );
  }

  /// Replace the contact point set for an arbiter.
  /// This can be a very powerful feature, but use it with caution!
  void setContactPointSet(ContactPointSet set) {
    final nativeSet = malloc<bindings.cpContactPointSet>();
    nativeSet.ref.count = set.count;
    nativeSet.ref.normal = set.normal.toNative();
    for (var i = 0; i < set.count && i < 2; i++) {
      final point = set.points[i];
      nativeSet.ref.points[i].pointA = point.pointA.toNative();
      nativeSet.ref.points[i].pointB = point.pointB.toNative();
      nativeSet.ref.points[i].distance = point.distance;
    }
    bindings.cp_arbiter_set_contact_point_set(_native, nativeSet);
    malloc.free(nativeSet);
  }

  /// Returns true if this is the first step a pair of objects started colliding.
  bool get isFirstContact {
    return bindings.cp_arbiter_is_first_contact(_native) != 0;
  }

  /// Returns true if the separate callback is due to a shape being removed from the space.
  bool get isRemoval {
    return bindings.cp_arbiter_is_removal(_native) != 0;
  }

  /// Get the number of contact points for this arbiter.
  int get count {
    return bindings.cp_arbiter_get_count(_native);
  }

  /// Get the normal of the collision.
  Vector get normal {
    return Vector.fromNative(bindings.cp_arbiter_get_normal(_native));
  }

  /// Get the position of the ith contact point on the surface of the first shape.
  ///
  /// [i] is the index of the contact point (0 or 1).
  Vector getPointA(int i) {
    return Vector.fromNative(bindings.cp_arbiter_get_point_a(_native, i));
  }

  /// Get the position of the ith contact point on the surface of the second shape.
  ///
  /// [i] is the index of the contact point (0 or 1).
  Vector getPointB(int i) {
    return Vector.fromNative(bindings.cp_arbiter_get_point_b(_native, i));
  }

  /// Get the depth of the ith contact point.
  ///
  /// [i] is the index of the contact point (0 or 1).
  double getDepth(int i) {
    return bindings.cp_arbiter_get_depth(_native, i);
  }
}
