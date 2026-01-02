import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/body.dart';
import 'package:chipmunk2d_physics_ffi/src/constraint.dart';
import 'package:chipmunk2d_physics_ffi/src/shape.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// A physics space containing bodies and shapes that can interact.
///
/// The Space is the simulation container. It manages all bodies, shapes,
/// and constraints, and steps the simulation forward in time.
///
/// Key features:
/// - Gravity and damping settings
/// - Collision detection and resolution
/// - Sleeping system for inactive bodies
/// - Spatial queries (point, segment, bounding box)
/// - Collision callbacks (via collision handlers)
///
/// See: [Chipmunk2D Space Documentation](https://chipmunk-physics.net/release/ Chipmunk2D-Docs/#cpSpace)
class Space {
  final ffi.Pointer<bindings.cpSpace> _native;
  final Set<Body> _bodies = {}; // Set for O(1) removal
  final Set<Shape> _shapes = {}; // Set for O(1) removal
  final Set<Constraint> _constraints = {}; // Set for O(1) removal
  bool _disposed = false;

  /// Creates a new physics space.
  factory Space() {
    final native = bindings.cp_space_new();
    if (native.address == 0) {
      throw Exception('Failed to create space');
    }
    return Space._(native);
  }

  Space._(this._native);

  /// Gets the native pointer (for internal use).
  ffi.Pointer<bindings.cpSpace> get native {
    if (_disposed) throw StateError('Space has been disposed');
    return _native;
  }

  /// Gets the gravity vector for the space.
  Vector get gravity {
    if (_disposed) throw StateError('Space has been disposed');
    return Vector.fromNative(bindings.cp_space_get_gravity(_native));
  }

  /// Sets the gravity vector for the space.
  set gravity(Vector value) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_gravity(_native, value.toNative());
  }

  /// Gets the number of iterations to use when solving constraints and collisions.
  /// More iterations improves stability but is slower. Default is 10.
  int get iterations {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_iterations(_native);
  }

  /// Sets the number of iterations to use when solving constraints and collisions.
  /// More iterations improves stability but is slower. Default is 10.
  void setIterations(int iterations) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_iterations(_native, iterations);
  }

  /// Gets the amount of encouraged penetration between colliding shapes.
  /// Used to reduce oscillating contacts and keep the collision cache warm.
  /// Default is 0.1. Increase if you have poor simulation quality.
  double get collisionSlop {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_collision_slop(_native);
  }

  /// Sets the amount of encouraged penetration between colliding shapes.
  /// Used to reduce oscillating contacts and keep the collision cache warm.
  /// Default is 0.1. Increase if you have poor simulation quality.
  void setCollisionSlop(double collisionSlop) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_collision_slop(_native, collisionSlop);
  }

  /// Gets how fast overlapping shapes are pushed apart.
  /// Expressed as a fraction of the error remaining after each second.
  /// Default is pow(1.0 - 0.1, 60.0) meaning 10% of overlap is fixed each frame at 60Hz.
  double get collisionBias {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_collision_bias(_native);
  }

  /// Sets how fast overlapping shapes are pushed apart.
  /// Expressed as a fraction of the error remaining after each second.
  /// Default is pow(1.0 - 0.1, 60.0) meaning 10% of overlap is fixed each frame at 60Hz.
  void setCollisionBias(double collisionBias) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_collision_bias(_native, collisionBias);
  }

  /// Gets the damping rate expressed as the fraction of velocity bodies retain each second.
  /// A value of 0.9 would mean that each body's velocity will drop 10% per second.
  /// The default value is 1.0, meaning no damping is applied.
  double get damping {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_damping(_native);
  }

  /// Sets the damping rate expressed as the fraction of velocity bodies retain each second.
  /// A value of 0.9 would mean that each body's velocity will drop 10% per second.
  /// The default value is 1.0, meaning no damping is applied.
  void setDamping(double damping) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_damping(_native, damping);
  }

  /// Gets the speed threshold for a body to be considered idle.
  /// The default value of 0 means to let the space guess a good threshold based on gravity.
  double get idleSpeedThreshold {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_idle_speed_threshold(_native);
  }

  /// Sets the speed threshold for a body to be considered idle.
  /// The default value of 0 means to let the space guess a good threshold based on gravity.
  void setIdleSpeedThreshold(double idleSpeedThreshold) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_idle_speed_threshold(_native, idleSpeedThreshold);
  }

  /// Gets the time a group of bodies must remain idle in order to fall asleep.
  /// Enabling sleeping also implicitly enables the contact graph.
  /// The default value of INFINITY disables the sleeping algorithm.
  double get sleepTimeThreshold {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_sleep_time_threshold(_native);
  }

  /// Sets the time a group of bodies must remain idle in order to fall asleep.
  /// Enabling sleeping also implicitly enables the contact graph.
  /// The default value of INFINITY disables the sleeping algorithm.
  void setSleepTimeThreshold(double sleepTimeThreshold) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_sleep_time_threshold(_native, sleepTimeThreshold);
  }

  /// Gets the number of frames that contact information should persist.
  /// Defaults to 3. There is probably never a reason to change this value.
  int get collisionPersistence {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_collision_persistence(_native);
  }

  /// Sets the number of frames that contact information should persist.
  /// Defaults to 3. There is probably never a reason to change this value.
  void setCollisionPersistence(int collisionPersistence) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_set_collision_persistence(_native, collisionPersistence);
  }

  /// Update the collision detection info for the static shapes in the space.
  /// Call this after moving static shapes or static bodies.
  void reindexStatic() {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_reindex_static(_native);
  }

  /// Update the collision detection data for a specific shape in the space.
  void reindexShape(Shape shape) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_reindex_shape(_native, shape.native);
  }

  /// Update the collision detection data for all shapes attached to a body.
  void reindexShapesForBody(Body body) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_reindex_shapes_for_body(_native, body.native);
  }

  /// Gets the space's built-in static body.
  /// This is provided for convenience - use this instead of creating your own static bodies.
  /// IMPORTANT: Do NOT dispose this body - it's managed by the space!
  Body get staticBody {
    if (_disposed) throw StateError('Space has been disposed');
    final nativeBody = bindings.cp_space_get_static_body(_native);
    return Body.fromNative(nativeBody);
  }

  /// Adds a body to this space.
  void addBody(Body body) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_add_body(_native, body.native);
    _bodies.add(body);
  }

  /// Removes a body from this space.
  void removeBody(Body body) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_remove_body(_native, body.native);
    _bodies.remove(body);
  }

  /// Adds a shape to this space.
  void addShape(Shape shape) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_add_shape(_native, shape.native);
    _shapes.add(shape);
  }

  /// Removes a shape from this space.
  void removeShape(Shape shape) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_remove_shape(_native, shape.native);
    _shapes.remove(shape);
  }

  /// Returns the current (or most recent) time step used with this space.
  /// Useful from callbacks if your time step is not a compile-time global.
  double get currentTimeStep {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_get_current_time_step(_native);
  }

  /// Returns true from inside a callback when objects cannot be added/removed.
  bool get isLocked {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_is_locked(_native) != 0;
  }

  /// Test if a collision shape has been added to the space.
  bool containsShape(Shape shape) {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_contains_shape(_native, shape.native) != 0;
  }

  /// Test if a rigid body has been added to the space.
  bool containsBody(Body body) {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_contains_body(_native, body.native) != 0;
  }

  /// Test if a constraint has been added to the space.
  bool containsConstraint(Constraint constraint) {
    if (_disposed) throw StateError('Space has been disposed');
    return bindings.cp_space_contains_constraint(_native, constraint.native) != 0;
  }

  /// Adds a constraint to this space.
  void addConstraint(Constraint constraint) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_add_constraint(_native, constraint.native);
    _constraints.add(constraint);
  }

  /// Removes a constraint from this space.
  void removeConstraint(Constraint constraint) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_remove_constraint(_native, constraint.native);
    _constraints.remove(constraint);
  }

  /// Steps the physics simulation forward by the given time delta.
  void step(double dt) {
    if (_disposed) throw StateError('Space has been disposed');
    bindings.cp_space_step(_native, dt);
  }

  /// Fast step - skips disposed check for hot loops.
  /// Only use this when you're certain the space is valid.
  @pragma('vm:prefer-inline')
  void stepUnsafe(double dt) {
    bindings.cp_space_step(_native, dt);
  }

  /// Disposes of this space and all its resources.
  void dispose() {
    if (!_disposed) {
      // Dispose constraints first
      for (final constraint in _constraints.toList()) {
        try {
          removeConstraint(constraint);
          constraint.dispose();
        } on Exception {
          // Constraint may have already been disposed
          _constraints.remove(constraint);
        }
      }

      // Dispose shapes
      for (final shape in _shapes.toList()) {
        try {
          removeShape(shape);
          shape.dispose();
        } on Exception {
          // Shape may have already been disposed
          _shapes.remove(shape);
        }
      }

      // Then dispose bodies
      for (final body in _bodies.toList()) {
        try {
          removeBody(body);
          body.dispose();
        } on Exception {
          // Body may have already been disposed
          _bodies.remove(body);
        }
      }

      bindings.cp_space_free(_native);
      _disposed = true;
    }
  }

  @override
  String toString() =>
      'Space(bodies: ${_bodies.length}, shapes: ${_shapes.length}, constraints: ${_constraints.length})';
}
