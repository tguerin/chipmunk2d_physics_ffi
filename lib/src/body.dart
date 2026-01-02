import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/body_type.dart';
import 'package:chipmunk2d_physics_ffi/src/shape.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// A physics body that can have forces applied to it and can collide.
///
/// Rigid bodies hold the physical properties of an object like its mass,
/// and position and velocity of its center of gravity. They don't have a shape
/// on their own. They are given a shape by creating collision shapes (Shape)
/// that point to the body.
///
/// Bodies can be one of three types:
/// - Dynamic: Affected by gravity, forces, and collisions (default)
/// - Kinematic: Infinite mass, user controlled, not affected by forces
/// - Static: Never moves, used for ground/walls
///
/// See: [Chipmunk2D Body Documentation](https://chipmunk-physics.net/release/ Chipmunk2D-Docs/#cpBody)
class Body {
  final ffi.Pointer<bindings.cpBody> _native;
  bool _disposed = false;

  /// Creates a new dynamic body with the given mass and moment of inertia.
  factory Body.dynamic(double mass, double moment) {
    final native = bindings.cp_body_new(mass, moment);
    if (native.address == 0) {
      throw Exception('Failed to create dynamic body');
    }
    return Body._(native);
  }

  /// Creates a new kinematic body (not affected by forces, but can be moved).
  factory Body.kinematic() {
    final native = bindings.cp_body_new_kinematic();
    if (native.address == 0) {
      throw Exception('Failed to create kinematic body');
    }
    return Body._(native);
  }

  /// Creates a new static body (immovable, used for ground/walls).
  factory Body.static() {
    final native = bindings.cp_body_new_static();
    if (native.address == 0) {
      throw Exception('Failed to create static body');
    }
    return Body._(native);
  }

  /// Creates a Body from a native pointer (for internal use).
  /// Use this to wrap the space's static body - do NOT dispose it!
  factory Body.fromNative(ffi.Pointer<bindings.cpBody> native) {
    return Body._(native);
  }

  Body._(this._native);

  /// Gets the native pointer (for internal use).
  ffi.Pointer<bindings.cpBody> get native {
    if (_disposed) throw StateError('Body has been disposed');
    return _native;
  }

  /// Position of the body.
  Vector get position {
    if (_disposed) throw StateError('Body has been disposed');
    final nativeVect = bindings.cp_body_get_position(_native);
    return Vector.fromNative(nativeVect);
  }

  set position(Vector pos) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_position(_native, pos.toNative());
  }

  /// Fast position X getter - avoids Vector allocation.
  /// Use this in hot loops for better performance.
  @pragma('vm:prefer-inline')
  double get positionX {
    return bindings.cp_body_get_position(_native).x;
  }

  /// Fast position Y getter - avoids Vector allocation.
  /// Use this in hot loops for better performance.
  @pragma('vm:prefer-inline')
  double get positionY {
    return bindings.cp_body_get_position(_native).y;
  }

  /// Velocity of the body.
  Vector get velocity {
    if (_disposed) throw StateError('Body has been disposed');
    final nativeVect = bindings.cp_body_get_velocity(_native);
    return Vector.fromNative(nativeVect);
  }

  set velocity(Vector vel) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_velocity(_native, vel.toNative());
  }

  /// Fast velocity X getter - avoids Vector allocation.
  @pragma('vm:prefer-inline')
  double get velocityX {
    return bindings.cp_body_get_velocity(_native).x;
  }

  /// Fast velocity Y getter - avoids Vector allocation.
  @pragma('vm:prefer-inline')
  double get velocityY {
    return bindings.cp_body_get_velocity(_native).y;
  }

  /// Angle of rotation in radians.
  double get angle {
    if (_disposed) throw StateError('Body has been disposed');
    return bindings.cp_body_get_angle(_native);
  }

  set angle(double angle) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_angle(_native, angle);
  }

  /// Mass of the body.
  double get mass {
    if (_disposed) throw StateError('Body has been disposed');
    return bindings.cp_body_get_mass(_native);
  }

  set mass(double mass) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_mass(_native, mass);
  }

  /// Moment of inertia of the body.
  double get moment {
    if (_disposed) throw StateError('Body has been disposed');
    return bindings.cp_body_get_moment(_native);
  }

  set moment(double moment) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_moment(_native, moment);
  }

  /// Angular velocity of the body in radians per second.
  double get angularVelocity {
    if (_disposed) throw StateError('Body has been disposed');
    return bindings.cp_body_get_angular_velocity(_native);
  }

  set angularVelocity(double angularVelocity) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_angular_velocity(_native, angularVelocity);
  }

  /// Center of gravity offset in body local coordinates.
  /// The center of gravity is the point that the body rotates around.
  Vector get centerOfGravity {
    if (_disposed) throw StateError('Body has been disposed');
    return Vector.fromNative(bindings.cp_body_get_center_of_gravity(_native));
  }

  set centerOfGravity(Vector cog) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_center_of_gravity(_native, cog.toNative());
  }

  /// Force applied to the body for the next time step.
  Vector get force {
    if (_disposed) throw StateError('Body has been disposed');
    return Vector.fromNative(bindings.cp_body_get_force(_native));
  }

  set force(Vector force) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_force(_native, force.toNative());
  }

  /// Torque applied to the body for the next time step.
  double get torque {
    if (_disposed) throw StateError('Body has been disposed');
    return bindings.cp_body_get_torque(_native);
  }

  set torque(double torque) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_torque(_native, torque);
  }

  /// Rotation vector of the body (the x basis vector of its transform).
  Vector get rotation {
    if (_disposed) throw StateError('Body has been disposed');
    return Vector.fromNative(bindings.cp_body_get_rotation(_native));
  }

  /// Type of the body (dynamic, kinematic, or static).
  BodyType get type {
    if (_disposed) throw StateError('Body has been disposed');
    return BodyType.fromValue(bindings.cp_body_get_type(_native));
  }

  set type(BodyType type) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_set_type(_native, type.value);
  }

  /// Returns true if the body is sleeping.
  bool get isSleeping {
    if (_disposed) throw StateError('Body has been disposed');
    return bindings.cp_body_is_sleeping(_native) != 0;
  }

  /// Wake up a sleeping or idle body.
  void activate() {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_activate(_native);
  }

  /// Wake up any sleeping or idle bodies touching a static body.
  /// Optionally filter by shape.
  void activateStatic([Shape? filter]) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_activate_static(_native, filter?.native ?? ffi.Pointer.fromAddress(0));
  }

  /// Force a body to fall asleep immediately.
  void sleep() {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_sleep(_native);
  }

  /// Force a body to fall asleep immediately along with other bodies in a group.
  void sleepWithGroup(Body group) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_sleep_with_group(_native, group.native);
  }

  /// Convert body relative/local coordinates to absolute/world coordinates.
  ///
  /// [point] is the point in body local coordinates.
  Vector localToWorld(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return Vector.fromNative(bindings.cp_body_local_to_world(_native, point.toNative()));
  }

  /// Convert body absolute/world coordinates to relative/local coordinates.
  ///
  /// [point] is the point in world coordinates.
  Vector worldToLocal(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return Vector.fromNative(bindings.cp_body_world_to_local(_native, point.toNative()));
  }

  /// Apply a force to a body. Both the force and point are expressed in world coordinates.
  void applyForceAtWorldPoint(Vector force, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_apply_force_at_world_point(_native, force.toNative(), point.toNative());
  }

  /// Apply a force to a body. Both the force and point are expressed in body local coordinates.
  void applyForceAtLocalPoint(Vector force, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_apply_force_at_local_point(_native, force.toNative(), point.toNative());
  }

  /// Apply an impulse to a body. Both the impulse and point are expressed in world coordinates.
  void applyImpulseAtWorldPoint(Vector impulse, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_apply_impulse_at_world_point(_native, impulse.toNative(), point.toNative());
  }

  /// Apply an impulse to a body. Both the impulse and point are expressed in body local coordinates.
  void applyImpulseAtLocalPoint(Vector impulse, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    bindings.cp_body_apply_impulse_at_local_point(_native, impulse.toNative(), point.toNative());
  }

  /// Get the velocity on a body (in world units) at a point on the body in world coordinates.
  ///
  /// [point] is the point in world coordinates.
  Vector getVelocityAtWorldPoint(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return Vector.fromNative(bindings.cp_body_get_velocity_at_world_point(_native, point.toNative()));
  }

  /// Get the velocity on a body (in world units) at a point on the body in local coordinates.
  ///
  /// [point] is the point in body local coordinates.
  Vector getVelocityAtLocalPoint(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return Vector.fromNative(bindings.cp_body_get_velocity_at_local_point(_native, point.toNative()));
  }

  /// Get the amount of kinetic energy contained by the body.
  double get kineticEnergy {
    if (_disposed) throw StateError('Body has been disposed');
    return bindings.cp_body_kinetic_energy(_native);
  }

  /// Disposes of this body and frees its resources.
  void dispose() {
    if (!_disposed) {
      bindings.cp_body_free(_native);
      _disposed = true;
    }
  }

  @override
  String toString() => 'Body(position: $position, velocity: $velocity, angle: $angle)';
}
