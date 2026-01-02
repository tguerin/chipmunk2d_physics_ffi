import 'package:chipmunk2d_physics_ffi/src/body.dart';
import 'package:chipmunk2d_physics_ffi/src/constraint.dart';
import 'package:chipmunk2d_physics_ffi/src/platform/chipmunk_bindings.dart';
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
/// **Memory Management:**
/// - Call [dispose] when done to free native resources
/// - Check [disposed] to see if the space has been disposed
/// - Using a disposed space will result in undefined behavior (native crash)
///
/// See: [Chipmunk2D Space Documentation](https://chipmunk-physics.net/release/Chipmunk2D-Docs/#cpSpace)
class Space {
  /// Creates a new physics space.
  factory Space() {
    final native = cpSpaceNew();
    if (native == 0) {
      throw Exception('Failed to create space');
    }
    return Space._(native);
  }

  Space._(this._native);

  final int _native;
  final Set<Body> _bodies = {};
  final Set<Shape> _shapes = {};
  final Set<Constraint> _constraints = {};
  bool _disposed = false;

  /// Whether this space has been disposed.
  bool get disposed => _disposed;

  /// Gets the native pointer (for internal use).
  int get native => _native;

  /// Gets the gravity vector for the space.
  Vector get gravity {
    return cpSpaceGetGravity(_native);
  }

  /// Sets the gravity vector for the space.
  set gravity(Vector value) {
    cpSpaceSetGravity(_native, value.x, value.y);
  }

  /// Gets the number of iterations to use when solving constraints and collisions.
  /// More iterations improves stability but is slower. Default is 10.
  int get iterations {
    return cpSpaceGetIterations(_native);
  }

  /// Sets the number of iterations to use when solving constraints and collisions.
  /// More iterations improves stability but is slower. Default is 10.
  set iterations(int iterations) {
    cpSpaceSetIterations(_native, iterations);
  }

  /// Gets the amount of encouraged penetration between colliding shapes.
  /// Used to reduce oscillating contacts and keep the collision cache warm.
  /// Default is 0.1. Increase if you have poor simulation quality.
  double get collisionSlop {
    return cpSpaceGetCollisionSlop(_native);
  }

  /// Sets the amount of encouraged penetration between colliding shapes.
  /// Used to reduce oscillating contacts and keep the collision cache warm.
  /// Default is 0.1. Increase if you have poor simulation quality.
  set collisionSlop(double collisionSlop) {
    cpSpaceSetCollisionSlop(_native, collisionSlop);
  }

  /// Gets how fast overlapping shapes are pushed apart.
  /// Expressed as a fraction of the error remaining after each second.
  /// Default is pow(1.0 - 0.1, 60.0) meaning 10% of overlap is fixed each frame at 60Hz.
  double get collisionBias {
    return cpSpaceGetCollisionBias(_native);
  }

  /// Sets how fast overlapping shapes are pushed apart.
  /// Expressed as a fraction of the error remaining after each second.
  /// Default is pow(1.0 - 0.1, 60.0) meaning 10% of overlap is fixed each frame at 60Hz.
  set collisionBias(double collisionBias) {
    cpSpaceSetCollisionBias(_native, collisionBias);
  }

  /// Gets the damping rate expressed as the fraction of velocity bodies retain each second.
  /// A value of 0.9 would mean that each body's velocity will drop 10% per second.
  /// The default value is 1.0, meaning no damping is applied.
  double get damping {
    return cpSpaceGetDamping(_native);
  }

  /// Sets the damping rate expressed as the fraction of velocity bodies retain each second.
  /// A value of 0.9 would mean that each body's velocity will drop 10% per second.
  /// The default value is 1.0, meaning no damping is applied.
  set damping(double damping) {
    cpSpaceSetDamping(_native, damping);
  }

  /// Gets the speed threshold for a body to be considered idle.
  /// The default value of 0 means to let the space guess a good threshold based on gravity.
  double get idleSpeedThreshold {
    return cpSpaceGetIdleSpeedThreshold(_native);
  }

  /// Sets the speed threshold for a body to be considered idle.
  /// The default value of 0 means to let the space guess a good threshold based on gravity.
  set idleSpeedThreshold(double idleSpeedThreshold) {
    cpSpaceSetIdleSpeedThreshold(_native, idleSpeedThreshold);
  }

  /// Gets the time a group of bodies must remain idle in order to fall asleep.
  /// Enabling sleeping also implicitly enables the contact graph.
  /// The default value of INFINITY disables the sleeping algorithm.
  double get sleepTimeThreshold {
    return cpSpaceGetSleepTimeThreshold(_native);
  }

  /// Sets the time a group of bodies must remain idle in order to fall asleep.
  /// Enabling sleeping also implicitly enables the contact graph.
  /// The default value of INFINITY disables the sleeping algorithm.
  set sleepTimeThreshold(double sleepTimeThreshold) {
    cpSpaceSetSleepTimeThreshold(_native, sleepTimeThreshold);
  }

  /// Gets the number of frames that contact information should persist.
  /// Defaults to 3. There is probably never a reason to change this value.
  int get collisionPersistence {
    return cpSpaceGetCollisionPersistence(_native);
  }

  /// Sets the number of frames that contact information should persist.
  /// Defaults to 3. There is probably never a reason to change this value.
  set collisionPersistence(int collisionPersistence) {
    cpSpaceSetCollisionPersistence(_native, collisionPersistence);
  }

  /// Update the collision detection info for the static shapes in the space.
  /// Call this after moving static shapes or static bodies.
  void reindexStatic() {
    cpSpaceReindexStatic(_native);
  }

  /// Update the collision detection data for a specific shape in the space.
  void reindexShape(Shape shape) {
    cpSpaceReindexShape(_native, shape.native);
  }

  /// Update the collision detection data for all shapes attached to a body.
  void reindexShapesForBody(Body body) {
    cpSpaceReindexShapesForBody(_native, body.native);
  }

  /// Gets the space's built-in static body.
  /// This is provided for convenience - use this instead of creating your own static bodies.
  /// IMPORTANT: Do NOT dispose this body - it's managed by the space!
  Body get staticBody {
    final nativeBody = cpSpaceGetStaticBody(_native);
    return Body.fromNative(nativeBody);
  }

  /// Adds a body to this space.
  void addBody(Body body) {
    cpSpaceAddBody(_native, body.native);
    _bodies.add(body);
  }

  /// Removes a body from this space.
  void removeBody(Body body) {
    cpSpaceRemoveBody(_native, body.native);
    _bodies.remove(body);
  }

  /// Adds a shape to this space.
  void addShape(Shape shape) {
    cpSpaceAddShape(_native, shape.native);
    _shapes.add(shape);
  }

  /// Removes a shape from this space.
  void removeShape(Shape shape) {
    cpSpaceRemoveShape(_native, shape.native);
    _shapes.remove(shape);
  }

  /// Returns the current (or most recent) time step used with this space.
  /// Useful from callbacks if your time step is not a compile-time global.
  double get currentTimeStep {
    return cpSpaceGetCurrentTimeStep(_native);
  }

  /// Returns true from inside a callback when objects cannot be added/removed.
  bool get isLocked {
    return cpSpaceIsLocked(_native) != 0;
  }

  /// Test if a collision shape has been added to the space.
  bool containsShape(Shape shape) {
    return cpSpaceContainsShape(_native, shape.native) != 0;
  }

  /// Test if a rigid body has been added to the space.
  bool containsBody(Body body) {
    return cpSpaceContainsBody(_native, body.native) != 0;
  }

  /// Test if a constraint has been added to the space.
  bool containsConstraint(Constraint constraint) {
    return cpSpaceContainsConstraint(_native, constraint.native) != 0;
  }

  /// Adds a constraint to this space.
  void addConstraint(Constraint constraint) {
    cpSpaceAddConstraint(_native, constraint.native);
    _constraints.add(constraint);
  }

  /// Removes a constraint from this space.
  void removeConstraint(Constraint constraint) {
    cpSpaceRemoveConstraint(_native, constraint.native);
    _constraints.remove(constraint);
  }

  /// Steps the physics simulation forward by the given time delta.
  void step(double dt) {
    cpSpaceStep(_native, dt);
  }

  /// Disposes of this space and all its resources.
  ///
  /// This will also dispose all bodies, shapes, and constraints that were added to this space.
  /// Safe to call multiple times (idempotent).
  void dispose() {
    if (!_disposed) {
      for (final constraint in _constraints.toList()) {
        try {
          removeConstraint(constraint);
          constraint.dispose();
        } on Object {
          _constraints.remove(constraint);
        }
      }

      for (final shape in _shapes.toList()) {
        try {
          removeShape(shape);
          shape.dispose();
        } on Object {
          _shapes.remove(shape);
        }
      }

      for (final body in _bodies.toList()) {
        try {
          removeBody(body);
          body.dispose();
        } on Object {
          _bodies.remove(body);
        }
      }

      cpSpaceFree(_native);
      _disposed = true;
    }
  }

  @override
  String toString() =>
      'Space(bodies: ${_bodies.length}, shapes: ${_shapes.length}, constraints: ${_constraints.length})';
}
