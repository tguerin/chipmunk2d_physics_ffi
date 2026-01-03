import 'package:chipmunk2d_physics_ffi/src/body_type.dart';
import 'package:chipmunk2d_physics_ffi/src/platform/chipmunk_bindings.dart';
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
  final int _native;
  bool _disposed = false;

  /// Creates a new dynamic body with the given mass and moment of inertia.
  factory Body.dynamic(double mass, double moment) {
    final native = cpBodyNew(mass, moment);
    if (native == 0) {
      throw Exception('Failed to create dynamic body');
    }
    return Body._(native);
  }

  /// Creates a new kinematic body (not affected by forces, but can be moved).
  factory Body.kinematic() {
    final native = cpBodyNewKinematic();
    if (native == 0) {
      throw Exception('Failed to create kinematic body');
    }
    return Body._(native);
  }

  /// Creates a new static body (immovable, used for ground/walls).
  factory Body.static() {
    final native = cpBodyNewStatic();
    if (native == 0) {
      throw Exception('Failed to create static body');
    }
    return Body._(native);
  }

  /// Creates a Body from a native pointer (for internal use).
  /// Use this to wrap the space's static body - do NOT dispose it!
  factory Body.fromNative(int native) {
    return Body._(native);
  }

  Body._(this._native);

  /// Gets the native pointer (for internal use).
  int get native {
    if (_disposed) throw StateError('Body has been disposed');
    return _native;
  }

  /// Position of the body.
  Vector get position {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetPosition(_native);
  }

  set position(Vector pos) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetPosition(_native, pos.x, pos.y);
  }

  /// Fast position X getter - avoids Vector allocation.
  /// Use this in hot loops for better performance.
  @pragma('vm:prefer-inline')
  double get positionX => cpBodyGetPosition(_native).x;

  /// Fast position Y getter - avoids Vector allocation.
  /// Use this in hot loops for better performance.
  @pragma('vm:prefer-inline')
  double get positionY => cpBodyGetPosition(_native).y;

  /// Velocity of the body.
  Vector get velocity {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetVelocity(_native);
  }

  set velocity(Vector vel) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetVelocity(_native, vel.x, vel.y);
  }

  /// Fast velocity X getter - avoids Vector allocation.
  @pragma('vm:prefer-inline')
  double get velocityX {
    return cpBodyGetVelocity(_native).x;
  }

  /// Fast velocity Y getter - avoids Vector allocation.
  @pragma('vm:prefer-inline')
  double get velocityY {
    return cpBodyGetVelocity(_native).y;
  }

  /// Angle of rotation in radians.
  double get angle {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetAngle(_native);
  }

  set angle(double angle) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetAngle(_native, angle);
  }

  /// Mass of the body.
  double get mass {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetMass(_native);
  }

  set mass(double mass) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetMass(_native, mass);
  }

  /// Moment of inertia of the body.
  double get moment {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetMoment(_native);
  }

  set moment(double moment) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetMoment(_native, moment);
  }

  /// Angular velocity of the body in radians per second.
  double get angularVelocity {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetAngularVelocity(_native);
  }

  set angularVelocity(double angularVelocity) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetAngularVelocity(_native, angularVelocity);
  }

  /// Center of gravity offset in body local coordinates.
  /// The center of gravity is the point that the body rotates around.
  Vector get centerOfGravity {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetCenterOfGravity(_native);
  }

  set centerOfGravity(Vector cog) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetCenterOfGravity(_native, cog.x, cog.y);
  }

  /// Force applied to the body for the next time step.
  Vector get force {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetForce(_native);
  }

  set force(Vector force) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetForce(_native, force.x, force.y);
  }

  /// Torque applied to the body for the next time step.
  double get torque {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetTorque(_native);
  }

  set torque(double torque) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetTorque(_native, torque);
  }

  /// Rotation vector of the body (the x basis vector of its transform).
  Vector get rotation {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetRotation(_native);
  }

  /// Type of the body (dynamic, kinematic, or static).
  BodyType get type {
    if (_disposed) throw StateError('Body has been disposed');
    return BodyType.fromValue(cpBodyGetType(_native));
  }

  set type(BodyType type) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySetType(_native, type.value);
  }

  /// Returns true if the body is sleeping.
  bool get isSleeping {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyIsSleeping(_native) != 0;
  }

  /// Wake up a sleeping or idle body.
  void activate() {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodyActivate(_native);
  }

  /// Wake up any sleeping or idle bodies touching a static body.
  /// Optionally filter by shape.
  /// Activate a static body if it's overlapping a shape.
  /// @param filter Optional shape filter. If null, activates all overlapping static bodies.
  void activateStatic([Shape? filter]) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodyActivateStatic(_native, filter?.native ?? 0);
  }

  /// Force a body to fall asleep immediately.
  void sleep() {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySleep(_native);
  }

  /// Force a body to fall asleep immediately along with other bodies in a group.
  void sleepWithGroup(Body group) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodySleepWithGroup(_native, group.native);
  }

  /// Convert body relative/local coordinates to absolute/world coordinates.
  ///
  /// [point] is the point in body local coordinates.
  Vector localToWorld(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyLocalToWorld(_native, point.x, point.y);
  }

  /// Convert body absolute/world coordinates to relative/local coordinates.
  ///
  /// [point] is the point in world coordinates.
  Vector worldToLocal(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyWorldToLocal(_native, point.x, point.y);
  }

  /// Apply a force to a body. Both the force and point are expressed in world coordinates.
  void applyForceAtWorldPoint(Vector force, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodyApplyForceAtWorldPoint(_native, force.x, force.y, point.x, point.y);
  }

  /// Apply a force to a body. Both the force and point are expressed in body local coordinates.
  void applyForceAtLocalPoint(Vector force, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodyApplyForceAtLocalPoint(_native, force.x, force.y, point.x, point.y);
  }

  /// Apply an impulse to a body. Both the impulse and point are expressed in world coordinates.
  void applyImpulseAtWorldPoint(Vector impulse, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodyApplyImpulseAtWorldPoint(_native, impulse.x, impulse.y, point.x, point.y);
  }

  /// Apply an impulse to a body. Both the impulse and point are expressed in body local coordinates.
  void applyImpulseAtLocalPoint(Vector impulse, Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    cpBodyApplyImpulseAtLocalPoint(_native, impulse.x, impulse.y, point.x, point.y);
  }

  /// Get the velocity on a body (in world units) at a point on the body in world coordinates.
  ///
  /// [point] is the point in world coordinates.
  Vector getVelocityAtWorldPoint(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetVelocityAtWorldPoint(_native, point.x, point.y);
  }

  /// Get the velocity on a body (in world units) at a point on the body in local coordinates.
  ///
  /// [point] is the point in body local coordinates.
  Vector getVelocityAtLocalPoint(Vector point) {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyGetVelocityAtLocalPoint(_native, point.x, point.y);
  }

  /// Get the amount of kinetic energy contained by the body.
  double get kineticEnergy {
    if (_disposed) throw StateError('Body has been disposed');
    return cpBodyKineticEnergy(_native);
  }

  /// Disposes of this body and frees its resources.
  void dispose() {
    if (!_disposed) {
      cpBodyFree(_native);
      _disposed = true;
    }
  }

  @override
  String toString() => 'Body(position: $position, velocity: $velocity, angle: $angle)';
}
