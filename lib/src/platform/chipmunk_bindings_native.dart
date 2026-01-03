/// Native (FFI) implementation of Chipmunk2D bindings.
///
/// Uses dart:ffi to call the native Chipmunk2D library.
library;

import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/bounding_box.dart';
import 'package:chipmunk2d_physics_ffi/src/shape.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';
import 'package:ffi/ffi.dart' as ffi;

// ============================================================================
// Initialization
// ============================================================================

bool _initialized = false;

/// Initialize the Chipmunk2D bindings.
///
/// On native platforms, this is a no-op since FFI resolves symbols automatically.
/// This function is provided for cross-platform compatibility.
///
/// **On web, you must call this before using any Chipmunk2D functions.**
Future<void> initializeChipmunk({String? wasmPath, String? jsPath}) async {
  _initialized = true;
}

/// Whether the bindings have been initialized.
bool get isChipmunkInitialized => _initialized;

// ============================================================================
// Space Functions
// ============================================================================

/// Allocate and initialize a cpSpace.
/// Returns a pointer to the new space.
int cpSpaceNew() => bindings.cp_space_new().address;

/// Free a space and all its bodies, shapes and constraints.
/// @param space The space to free.
void cpSpaceFree(int space) => bindings.cp_space_free(ffi.Pointer.fromAddress(space));

/// Step the space forward in time by dt.
/// @param space The space to step.
/// @param dt The time step.
void cpSpaceStep(int space, double dt) => bindings.cp_space_step(ffi.Pointer.fromAddress(space), dt);

/// Set the gravity vector for the space.
/// @param space The space.
/// @param x The x component of gravity.
/// @param y The y component of gravity.
void cpSpaceSetGravity(int space, double x, double y) {
  final g = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_space_set_gravity(ffi.Pointer.fromAddress(space), g);
}

/// Get the gravity vector for the space.
/// @param space The space.
/// @return A tuple of (x, y) gravity components.
Vector cpSpaceGetGravity(int space) {
  final g = bindings.cp_space_get_gravity(ffi.Pointer.fromAddress(space));
  return Vector(g.x, g.y);
}

/// Get the number of iterations to use when solving constraints and collisions.
/// @param space The space.
/// @return The number of iterations.
int cpSpaceGetIterations(int space) => bindings.cp_space_get_iterations(ffi.Pointer.fromAddress(space));

/// Set the number of iterations to use when solving constraints and collisions.
/// More iterations improves stability but is slower. Default is 10.
/// @param space The space.
/// @param iterations The number of iterations.
void cpSpaceSetIterations(int space, int iterations) =>
    bindings.cp_space_set_iterations(ffi.Pointer.fromAddress(space), iterations);

/// Get the damping rate for the space.
/// @param space The space.
/// @return The damping rate (fraction of velocity retained per second).
double cpSpaceGetDamping(int space) => bindings.cp_space_get_damping(ffi.Pointer.fromAddress(space));

/// Set the damping rate for the space.
/// @param space The space.
/// @param damping The damping rate (fraction of velocity retained per second).
void cpSpaceSetDamping(int space, double damping) =>
    bindings.cp_space_set_damping(ffi.Pointer.fromAddress(space), damping);

/// Get the speed threshold for a body to be considered idle.
/// @param space The space.
/// @return The idle speed threshold.
double cpSpaceGetIdleSpeedThreshold(int space) =>
    bindings.cp_space_get_idle_speed_threshold(ffi.Pointer.fromAddress(space));

/// Set the speed threshold for a body to be considered idle.
/// @param space The space.
/// @param threshold The idle speed threshold.
void cpSpaceSetIdleSpeedThreshold(int space, double threshold) =>
    bindings.cp_space_set_idle_speed_threshold(ffi.Pointer.fromAddress(space), threshold);

/// Get the time a group of bodies must remain idle to fall asleep.
/// @param space The space.
/// @return The sleep time threshold.
double cpSpaceGetSleepTimeThreshold(int space) =>
    bindings.cp_space_get_sleep_time_threshold(ffi.Pointer.fromAddress(space));

/// Set the time a group of bodies must remain idle to fall asleep.
/// @param space The space.
/// @param threshold The sleep time threshold.
void cpSpaceSetSleepTimeThreshold(int space, double threshold) =>
    bindings.cp_space_set_sleep_time_threshold(ffi.Pointer.fromAddress(space), threshold);

/// Get the amount of encouraged penetration between colliding shapes.
/// @param space The space.
/// @return The collision slop.
double cpSpaceGetCollisionSlop(int space) => bindings.cp_space_get_collision_slop(ffi.Pointer.fromAddress(space));

/// Set the amount of encouraged penetration between colliding shapes.
/// @param space The space.
/// @param slop The collision slop.
void cpSpaceSetCollisionSlop(int space, double slop) =>
    bindings.cp_space_set_collision_slop(ffi.Pointer.fromAddress(space), slop);

/// Get how fast overlapping shapes are pushed apart.
/// @param space The space.
/// @return The collision bias.
double cpSpaceGetCollisionBias(int space) => bindings.cp_space_get_collision_bias(ffi.Pointer.fromAddress(space));

/// Set how fast overlapping shapes are pushed apart.
/// @param space The space.
/// @param bias The collision bias.
void cpSpaceSetCollisionBias(int space, double bias) =>
    bindings.cp_space_set_collision_bias(ffi.Pointer.fromAddress(space), bias);

/// Get the number of frames that contact information should persist.
/// @param space The space.
/// @return The collision persistence.
int cpSpaceGetCollisionPersistence(int space) =>
    bindings.cp_space_get_collision_persistence(ffi.Pointer.fromAddress(space));

/// Set the number of frames that contact information should persist.
/// @param space The space.
/// @param persistence The collision persistence.
void cpSpaceSetCollisionPersistence(int space, int persistence) =>
    bindings.cp_space_set_collision_persistence(ffi.Pointer.fromAddress(space), persistence);

/// Get the current (or most recent) time step used with this space.
/// @param space The space.
/// @return The current time step.
double cpSpaceGetCurrentTimeStep(int space) => bindings.cp_space_get_current_time_step(ffi.Pointer.fromAddress(space));

/// Returns true from inside a callback when objects cannot be added/removed.
/// @param space The space.
/// @return Non-zero if the space is locked.
int cpSpaceIsLocked(int space) => bindings.cp_space_is_locked(ffi.Pointer.fromAddress(space));

/// Get the space's built-in static body.
/// @param space The space.
/// @return A pointer to the static body.
int cpSpaceGetStaticBody(int space) => bindings.cp_space_get_static_body(ffi.Pointer.fromAddress(space)).address;

/// Add a body to a space.
/// @param space The space.
/// @param body The body to add.
void cpSpaceAddBody(int space, int body) =>
    bindings.cp_space_add_body(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(body));

/// Remove a body from a space.
/// @param space The space.
/// @param body The body to remove.
void cpSpaceRemoveBody(int space, int body) =>
    bindings.cp_space_remove_body(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(body));

/// Add a shape to a space.
/// @param space The space.
/// @param shape The shape to add.
void cpSpaceAddShape(int space, int shape) =>
    bindings.cp_space_add_shape(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(shape));

/// Remove a shape from a space.
/// @param space The space.
/// @param shape The shape to remove.
void cpSpaceRemoveShape(int space, int shape) =>
    bindings.cp_space_remove_shape(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(shape));

/// Add a constraint to a space.
/// @param space The space.
/// @param constraint The constraint to add.
void cpSpaceAddConstraint(int space, int constraint) =>
    bindings.cp_space_add_constraint(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(constraint));

/// Remove a constraint from a space.
/// @param space The space.
/// @param constraint The constraint to remove.
void cpSpaceRemoveConstraint(int space, int constraint) =>
    bindings.cp_space_remove_constraint(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(constraint));

/// Test if a collision shape has been added to the space.
/// @param space The space.
/// @param shape The shape to test.
/// @return Non-zero if the shape is in the space.
int cpSpaceContainsShape(int space, int shape) =>
    bindings.cp_space_contains_shape(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(shape));

/// Test if a rigid body has been added to the space.
/// @param space The space.
/// @param body The body to test.
/// @return Non-zero if the body is in the space.
int cpSpaceContainsBody(int space, int body) =>
    bindings.cp_space_contains_body(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(body));

/// Test if a constraint has been added to the space.
/// @param space The space.
/// @param constraint The constraint to test.
/// @return Non-zero if the constraint is in the space.
int cpSpaceContainsConstraint(int space, int constraint) =>
    bindings.cp_space_contains_constraint(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(constraint));

/// Update the collision detection info for the static shapes in the space.
/// @param space The space.
void cpSpaceReindexStatic(int space) => bindings.cp_space_reindex_static(ffi.Pointer.fromAddress(space));

/// Update the collision detection data for a specific shape in the space.
/// @param space The space.
/// @param shape The shape to reindex.
void cpSpaceReindexShape(int space, int shape) =>
    bindings.cp_space_reindex_shape(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(shape));

/// Update the collision detection data for all shapes attached to a body.
/// @param space The space.
/// @param body The body whose shapes should be reindexed.
void cpSpaceReindexShapesForBody(int space, int body) =>
    bindings.cp_space_reindex_shapes_for_body(ffi.Pointer.fromAddress(space), ffi.Pointer.fromAddress(body));

// ============================================================================
// Body Functions
// ============================================================================

/// Allocate and initialize a cpBody with the given mass and moment.
/// @param mass The mass of the body.
/// @param moment The moment of inertia of the body.
/// @return A pointer to the new body.
int cpBodyNew(double mass, double moment) => bindings.cp_body_new(mass, moment).address;

/// Allocate and initialize a cpBody as a kinematic body.
/// Kinematic bodies have infinite mass and moment, and are not affected by forces.
/// @return A pointer to the new kinematic body.
int cpBodyNewKinematic() => bindings.cp_body_new_kinematic().address;

/// Allocate and initialize a cpBody as a static body.
/// Static bodies have infinite mass and moment, and never move.
/// @return A pointer to the new static body.
int cpBodyNewStatic() => bindings.cp_body_new_static().address;

/// Free a body.
/// @param body The body to free.
void cpBodyFree(int body) => bindings.cp_body_free(ffi.Pointer.fromAddress(body));

/// Get the position of a body.
/// @param body The body.
/// @return A tuple of (x, y) position components.
Vector cpBodyGetPosition(int body) {
  final v = bindings.cp_body_get_position(ffi.Pointer.fromAddress(body));
  return Vector(v.x, v.y);
}

/// Set the position of a body.
/// @param body The body.
/// @param x The x component of the position.
/// @param y The y component of the position.
void cpBodySetPosition(int body, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_body_set_position(ffi.Pointer.fromAddress(body), v);
}

/// Get the velocity of a body.
/// @param body The body.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocity(int body) {
  final v = bindings.cp_body_get_velocity(ffi.Pointer.fromAddress(body));
  return Vector(v.x, v.y);
}

/// Set the velocity of a body.
/// @param body The body.
/// @param x The x component of the velocity.
/// @param y The y component of the velocity.
void cpBodySetVelocity(int body, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_body_set_velocity(ffi.Pointer.fromAddress(body), v);
}

/// Get the angle of a body in radians.
/// @param body The body.
/// @return The angle in radians.
double cpBodyGetAngle(int body) => bindings.cp_body_get_angle(ffi.Pointer.fromAddress(body));

/// Set the angle of a body in radians.
/// @param body The body.
/// @param angle The angle in radians.
void cpBodySetAngle(int body, double angle) => bindings.cp_body_set_angle(ffi.Pointer.fromAddress(body), angle);

/// Get the mass of a body.
/// @param body The body.
/// @return The mass.
double cpBodyGetMass(int body) => bindings.cp_body_get_mass(ffi.Pointer.fromAddress(body));

/// Set the mass of a body.
/// @param body The body.
/// @param mass The mass.
void cpBodySetMass(int body, double mass) => bindings.cp_body_set_mass(ffi.Pointer.fromAddress(body), mass);

/// Get the moment of inertia of a body.
/// @param body The body.
/// @return The moment of inertia.
double cpBodyGetMoment(int body) => bindings.cp_body_get_moment(ffi.Pointer.fromAddress(body));

/// Set the moment of inertia of a body.
/// @param body The body.
/// @param moment The moment of inertia.
void cpBodySetMoment(int body, double moment) => bindings.cp_body_set_moment(ffi.Pointer.fromAddress(body), moment);

/// Get the angular velocity of a body in radians per second.
/// @param body The body.
/// @return The angular velocity in radians per second.
double cpBodyGetAngularVelocity(int body) => bindings.cp_body_get_angular_velocity(ffi.Pointer.fromAddress(body));

/// Set the angular velocity of a body in radians per second.
/// @param body The body.
/// @param angularVelocity The angular velocity in radians per second.
void cpBodySetAngularVelocity(int body, double angularVelocity) =>
    bindings.cp_body_set_angular_velocity(ffi.Pointer.fromAddress(body), angularVelocity);

/// Get the center of gravity offset in body local coordinates.
/// @param body The body.
/// @return A tuple of (x, y) center of gravity components.
Vector cpBodyGetCenterOfGravity(int body) {
  final v = bindings.cp_body_get_center_of_gravity(ffi.Pointer.fromAddress(body));
  return Vector(v.x, v.y);
}

/// Set the center of gravity offset in body local coordinates.
/// @param body The body.
/// @param x The x component of the center of gravity.
/// @param y The y component of the center of gravity.
void cpBodySetCenterOfGravity(int body, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_body_set_center_of_gravity(ffi.Pointer.fromAddress(body), v);
}

/// Get the force applied to a body for the next time step.
/// @param body The body.
/// @return A tuple of (x, y) force components.
Vector cpBodyGetForce(int body) {
  final v = bindings.cp_body_get_force(ffi.Pointer.fromAddress(body));
  return Vector(v.x, v.y);
}

/// Set the force applied to a body for the next time step.
/// @param body The body.
/// @param x The x component of the force.
/// @param y The y component of the force.
void cpBodySetForce(int body, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_body_set_force(ffi.Pointer.fromAddress(body), v);
}

/// Get the torque applied to a body for the next time step.
/// @param body The body.
/// @return The torque.
double cpBodyGetTorque(int body) => bindings.cp_body_get_torque(ffi.Pointer.fromAddress(body));

/// Set the torque applied to a body for the next time step.
/// @param body The body.
/// @param torque The torque.
void cpBodySetTorque(int body, double torque) => bindings.cp_body_set_torque(ffi.Pointer.fromAddress(body), torque);

/// Get the rotation vector of a body (the x basis vector of its transform).
/// @param body The body.
/// @return A tuple of (x, y) rotation components.
Vector cpBodyGetRotation(int body) {
  final v = bindings.cp_body_get_rotation(ffi.Pointer.fromAddress(body));
  return Vector(v.x, v.y);
}

/// Get the type of a body.
/// @param body The body.
/// @return The body type (0=dynamic, 1=kinematic, 2=static).
int cpBodyGetType(int body) => bindings.cp_body_get_type(ffi.Pointer.fromAddress(body));

/// Set the type of a body.
/// @param body The body.
/// @param type The body type (0=dynamic, 1=kinematic, 2=static).
void cpBodySetType(int body, int type) => bindings.cp_body_set_type(ffi.Pointer.fromAddress(body), type);

/// Returns true if the body is sleeping.
/// @param body The body.
/// @return Non-zero if the body is sleeping.
int cpBodyIsSleeping(int body) => bindings.cp_body_is_sleeping(ffi.Pointer.fromAddress(body));

/// Wake up a sleeping or idle body.
/// @param body The body.
void cpBodyActivate(int body) => bindings.cp_body_activate(ffi.Pointer.fromAddress(body));

/// Wake up any sleeping or idle bodies touching a static body.
/// @param body The static body.
/// @param filter Optional shape filter (0 for all shapes).
void cpBodyActivateStatic(int body, int filter) =>
    bindings.cp_body_activate_static(ffi.Pointer.fromAddress(body), ffi.Pointer.fromAddress(filter));

/// Force a body to fall asleep immediately.
/// @param body The body.
void cpBodySleep(int body) => bindings.cp_body_sleep(ffi.Pointer.fromAddress(body));

/// Force a body to fall asleep immediately along with other bodies in a group.
/// @param body The body.
/// @param group The group body.
void cpBodySleepWithGroup(int body, int group) =>
    bindings.cp_body_sleep_with_group(ffi.Pointer.fromAddress(body), ffi.Pointer.fromAddress(group));

/// Convert body relative/local coordinates to absolute/world coordinates.
/// @param body The body.
/// @param x The x coordinate in body local space.
/// @param y The y coordinate in body local space.
/// @return A tuple of (x, y) world coordinates.
Vector cpBodyLocalToWorld(int body, double x, double y) {
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  final result = bindings.cp_body_local_to_world(ffi.Pointer.fromAddress(body), point);
  return Vector(result.x, result.y);
}

/// Convert body absolute/world coordinates to relative/local coordinates.
/// @param body The body.
/// @param x The x coordinate in world space.
/// @param y The y coordinate in world space.
/// @return A tuple of (x, y) local coordinates.
Vector cpBodyWorldToLocal(int body, double x, double y) {
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  final result = bindings.cp_body_world_to_local(ffi.Pointer.fromAddress(body), point);
  return Vector(result.x, result.y);
}

/// Apply a force to a body. Both the force and point are expressed in world coordinates.
/// @param body The body.
/// @param fx The x component of the force.
/// @param fy The y component of the force.
/// @param px The x coordinate of the point in world space.
/// @param py The y coordinate of the point in world space.
void cpBodyApplyForceAtWorldPoint(int body, double fx, double fy, double px, double py) {
  final force = ffi.Struct.create<bindings.cpVect>()
    ..x = fx
    ..y = fy;
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = px
    ..y = py;
  bindings.cp_body_apply_force_at_world_point(ffi.Pointer.fromAddress(body), force, point);
}

/// Apply a force to a body. Both the force and point are expressed in body local coordinates.
/// @param body The body.
/// @param fx The x component of the force.
/// @param fy The y component of the force.
/// @param px The x coordinate of the point in body local space.
/// @param py The y coordinate of the point in body local space.
void cpBodyApplyForceAtLocalPoint(int body, double fx, double fy, double px, double py) {
  final force = ffi.Struct.create<bindings.cpVect>()
    ..x = fx
    ..y = fy;
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = px
    ..y = py;
  bindings.cp_body_apply_force_at_local_point(ffi.Pointer.fromAddress(body), force, point);
}

/// Apply an impulse to a body. Both the impulse and point are expressed in world coordinates.
/// @param body The body.
/// @param ix The x component of the impulse.
/// @param iy The y component of the impulse.
/// @param px The x coordinate of the point in world space.
/// @param py The y coordinate of the point in world space.
void cpBodyApplyImpulseAtWorldPoint(int body, double ix, double iy, double px, double py) {
  final impulse = ffi.Struct.create<bindings.cpVect>()
    ..x = ix
    ..y = iy;
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = px
    ..y = py;
  bindings.cp_body_apply_impulse_at_world_point(ffi.Pointer.fromAddress(body), impulse, point);
}

/// Apply an impulse to a body. Both the impulse and point are expressed in body local coordinates.
/// @param body The body.
/// @param ix The x component of the impulse.
/// @param iy The y component of the impulse.
/// @param px The x coordinate of the point in body local space.
/// @param py The y coordinate of the point in body local space.
void cpBodyApplyImpulseAtLocalPoint(int body, double ix, double iy, double px, double py) {
  final impulse = ffi.Struct.create<bindings.cpVect>()
    ..x = ix
    ..y = iy;
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = px
    ..y = py;
  bindings.cp_body_apply_impulse_at_local_point(ffi.Pointer.fromAddress(body), impulse, point);
}

/// Get the velocity on a body at a point in world coordinates.
/// @param body The body.
/// @param x The x coordinate of the point in world space.
/// @param y The y coordinate of the point in world space.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocityAtWorldPoint(int body, double x, double y) {
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  final result = bindings.cp_body_get_velocity_at_world_point(ffi.Pointer.fromAddress(body), point);
  return Vector(result.x, result.y);
}

/// Get the velocity on a body at a point in body local coordinates.
/// @param body The body.
/// @param x The x coordinate of the point in body local space.
/// @param y The y coordinate of the point in body local space.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocityAtLocalPoint(int body, double x, double y) {
  final point = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  final result = bindings.cp_body_get_velocity_at_local_point(ffi.Pointer.fromAddress(body), point);
  return Vector(result.x, result.y);
}

/// Get the amount of kinetic energy contained by the body.
/// @param body The body.
/// @return The kinetic energy.
double cpBodyKineticEnergy(int body) => bindings.cp_body_kinetic_energy(ffi.Pointer.fromAddress(body));

// ============================================================================
// Shape Functions
// ============================================================================

/// Allocate and initialize a circle shape.
/// @param body The body to attach the shape to.
/// @param radius The radius of the circle.
/// @param offsetX The x offset of the circle center from the body's center of gravity.
/// @param offsetY The y offset of the circle center from the body's center of gravity.
/// @return A pointer to the new circle shape.
int cpCircleShapeNew(int body, double radius, double offsetX, double offsetY) {
  final offset = ffi.Struct.create<bindings.cpVect>()
    ..x = offsetX
    ..y = offsetY;
  return bindings.cp_circle_shape_new(ffi.Pointer.fromAddress(body), radius, offset).address;
}

/// Allocate and initialize a segment shape.
/// @param body The body to attach the shape to.
/// @param ax The x coordinate of the first endpoint.
/// @param ay The y coordinate of the first endpoint.
/// @param bx The x coordinate of the second endpoint.
/// @param by The y coordinate of the second endpoint.
/// @param radius The radius of the segment (for fattened segments).
/// @return A pointer to the new segment shape.
int cpSegmentShapeNew(int body, double ax, double ay, double bx, double by, double radius) {
  final a = ffi.Struct.create<bindings.cpVect>()
    ..x = ax
    ..y = ay;
  final b = ffi.Struct.create<bindings.cpVect>()
    ..x = bx
    ..y = by;
  return bindings.cp_segment_shape_new(ffi.Pointer.fromAddress(body), a, b, radius).address;
}

/// Allocate and initialize a box shape.
/// @param body The body to attach the shape to.
/// @param width The width of the box.
/// @param height The height of the box.
/// @param radius The corner radius of the box.
/// @return A pointer to the new box shape.
int cpPolyShapeNewBox(int body, double width, double height, double radius) =>
    bindings.cp_box_shape_new(ffi.Pointer.fromAddress(body), width, height, radius).address;

/// Allocate and initialize a polygon shape.
/// @param body The body to attach the shape to.
/// @param verts A list of vertex coordinates as [x1, y1, x2, y2, ...].
/// @param radius The radius of the polygon (for rounded corners).
/// @return A pointer to the new polygon shape.
int cpPolyShapeNew(int body, List<double> verts, double radius) {
  final count = verts.length ~/ 2;
  // Use cp_poly_shape_new_raw which doesn't require transform
  final nativeVerts = ffi.Pointer<bindings.cpVect>.fromAddress(
    _allocateVerts(verts),
  );
  final result = bindings
      .cp_poly_shape_new_raw(
        ffi.Pointer.fromAddress(body),
        count,
        nativeVerts,
        radius,
      )
      .address;
  _freeVerts(nativeVerts.address);
  return result;
}

// Helper to allocate vertices - uses Arena allocator from ffi package
int _allocateVerts(List<double> verts) {
  final count = verts.length ~/ 2;
  // Each cpVect is 16 bytes (2 doubles)
  final sizeBytes = count * ffi.sizeOf<bindings.cpVect>();
  final ptr = ffi.malloc.allocate<bindings.cpVect>(sizeBytes);
  for (var i = 0; i < count; i++) {
    ptr[i].x = verts[i * 2];
    ptr[i].y = verts[i * 2 + 1];
  }
  return ptr.address;
}

void _freeVerts(int ptr) {
  ffi.malloc.free(ffi.Pointer.fromAddress(ptr));
}

/// Free a shape.
/// @param shape The shape to free.
void cpShapeFree(int shape) => bindings.cp_shape_free(ffi.Pointer.fromAddress(shape));

/// Get the elasticity (bounciness) of a shape.
/// @param shape The shape.
/// @return The elasticity (0.0 = no bounce, 1.0 = perfect bounce).
double cpShapeGetElasticity(int shape) => bindings.cp_shape_get_elasticity(ffi.Pointer.fromAddress(shape));

/// Set the elasticity (bounciness) of a shape.
/// @param shape The shape.
/// @param elasticity The elasticity (0.0 = no bounce, 1.0 = perfect bounce).
void cpShapeSetElasticity(int shape, double elasticity) =>
    bindings.cp_shape_set_elasticity(ffi.Pointer.fromAddress(shape), elasticity);

/// Get the friction coefficient of a shape.
/// @param shape The shape.
/// @return The friction coefficient.
double cpShapeGetFriction(int shape) => bindings.cp_shape_get_friction(ffi.Pointer.fromAddress(shape));

/// Set the friction coefficient of a shape.
/// @param shape The shape.
/// @param friction The friction coefficient.
void cpShapeSetFriction(int shape, double friction) =>
    bindings.cp_shape_set_friction(ffi.Pointer.fromAddress(shape), friction);

/// Get the surface velocity of a shape.
/// @param shape The shape.
/// @return A tuple of (x, y) surface velocity components.
Vector cpShapeGetSurfaceVelocity(int shape) {
  final v = bindings.cp_shape_get_surface_velocity(ffi.Pointer.fromAddress(shape));
  return Vector(v.x, v.y);
}

/// Set the surface velocity of a shape.
/// @param shape The shape.
/// @param x The x component of the surface velocity.
/// @param y The y component of the surface velocity.
void cpShapeSetSurfaceVelocity(int shape, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_shape_set_surface_velocity(ffi.Pointer.fromAddress(shape), v);
}

/// Get the collision type of a shape.
/// @param shape The shape.
/// @return The collision type.
int cpShapeGetCollisionType(int shape) => bindings.cp_shape_get_collision_type(ffi.Pointer.fromAddress(shape));

/// Set the collision type of a shape.
/// @param shape The shape.
/// @param collisionType The collision type.
void cpShapeSetCollisionType(int shape, int collisionType) =>
    bindings.cp_shape_set_collision_type(ffi.Pointer.fromAddress(shape), collisionType);

/// Get the collision filter of a shape.
/// @param shape The shape.
/// @return A tuple of (group, categories, mask) filter values.
ShapeFilter cpShapeGetFilter(int shape) {
  final filter = bindings.cp_shape_get_filter(ffi.Pointer.fromAddress(shape));
  return ShapeFilter(
    group: filter.group,
    categories: filter.categories,
    mask: filter.mask,
  );
}

/// Set the collision filter of a shape.
/// @param shape The shape.
/// @param group The collision group.
/// @param categories The collision categories.
/// @param mask The collision mask.
void cpShapeSetFilter(int shape, int group, int categories, int mask) {
  final filter = bindings.cp_shape_filter_new(group, categories, mask);
  bindings.cp_shape_set_filter(ffi.Pointer.fromAddress(shape), filter);
}

/// Get whether a shape is a sensor (non-colliding trigger).
/// @param shape The shape.
/// @return Non-zero if the shape is a sensor.
int cpShapeGetSensor(int shape) => bindings.cp_shape_get_sensor(ffi.Pointer.fromAddress(shape));

/// Set whether a shape is a sensor (non-colliding trigger).
/// @param shape The shape.
/// @param sensor Non-zero to make the shape a sensor.
void cpShapeSetSensor(int shape, int sensor) => bindings.cp_shape_set_sensor(ffi.Pointer.fromAddress(shape), sensor);

/// Get the body that a shape is attached to.
/// @param shape The shape.
/// @return A pointer to the body.
int cpShapeGetBody(int shape) => bindings.cp_shape_get_body(ffi.Pointer.fromAddress(shape)).address;

/// Set the body that a shape is attached to.
/// @param shape The shape.
/// @param body The body pointer (0 to detach).
void cpShapeSetBody(int shape, int body) =>
    bindings.cp_shape_set_body(ffi.Pointer.fromAddress(shape), ffi.Pointer.fromAddress(body));

/// Get the calculated moment of inertia for a shape.
/// @param shape The shape.
/// @return The moment of inertia.
double cpShapeGetMoment(int shape) => bindings.cp_shape_get_moment(ffi.Pointer.fromAddress(shape));

/// Get the calculated area of a shape.
/// @param shape The shape.
/// @return The area.
double cpShapeGetArea(int shape) => bindings.cp_shape_get_area(ffi.Pointer.fromAddress(shape));

/// Get the calculated center of gravity of a shape.
/// @param shape The shape.
/// @return A tuple of (x, y) center of gravity coordinates.
Vector cpShapeGetCenterOfGravity(int shape) {
  final v = bindings.cp_shape_get_center_of_gravity(ffi.Pointer.fromAddress(shape));
  return Vector(v.x, v.y);
}

/// Get the axis-aligned bounding box of a shape.
/// @param shape The shape.
/// @return A tuple of (left, bottom, right, top) bounding box coordinates.
BoundingBox cpShapeGetBB(int shape) {
  final bb = bindings.cp_shape_get_bb(ffi.Pointer.fromAddress(shape));
  return BoundingBox(
    left: bb.l,
    bottom: bb.b,
    right: bb.r,
    top: bb.t,
  );
}

/// Get the mass of a shape.
/// @param shape The shape.
/// @return The mass.
double cpShapeGetMass(int shape) => bindings.cp_shape_get_mass(ffi.Pointer.fromAddress(shape));

/// Set the mass of a shape.
/// @param shape The shape.
/// @param mass The mass.
void cpShapeSetMass(int shape, double mass) => bindings.cp_shape_set_mass(ffi.Pointer.fromAddress(shape), mass);

/// Get the density of a shape.
/// @param shape The shape.
/// @return The density.
double cpShapeGetDensity(int shape) => bindings.cp_shape_get_density(ffi.Pointer.fromAddress(shape));

/// Set the density of a shape.
/// @param shape The shape.
/// @param density The density.
void cpShapeSetDensity(int shape, double density) =>
    bindings.cp_shape_set_density(ffi.Pointer.fromAddress(shape), density);

/// Get the radius of a circle shape.
/// @param shape The circle shape.
/// @return The radius.
double cpCircleShapeGetRadius(int shape) => bindings.cp_circle_shape_get_radius(ffi.Pointer.fromAddress(shape));

/// Get the offset of a circle shape from the body's center of gravity.
/// @param shape The circle shape.
/// @return A tuple of (x, y) offset components.
Vector cpCircleShapeGetOffset(int shape) {
  final v = bindings.cp_circle_shape_get_offset(ffi.Pointer.fromAddress(shape));
  return Vector(v.x, v.y);
}

/// Get the first endpoint of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) coordinates of the first endpoint.
Vector cpSegmentShapeGetA(int shape) {
  final v = bindings.cp_segment_shape_get_a(ffi.Pointer.fromAddress(shape));
  return Vector(v.x, v.y);
}

/// Get the second endpoint of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) coordinates of the second endpoint.
Vector cpSegmentShapeGetB(int shape) {
  final v = bindings.cp_segment_shape_get_b(ffi.Pointer.fromAddress(shape));
  return Vector(v.x, v.y);
}

/// Get the radius of a segment shape.
/// @param shape The segment shape.
/// @return The radius.
double cpSegmentShapeGetRadius(int shape) => bindings.cp_segment_shape_get_radius(ffi.Pointer.fromAddress(shape));

/// Get the normal vector of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) normal components.
Vector cpSegmentShapeGetNormal(int shape) {
  final v = bindings.cp_segment_shape_get_normal(ffi.Pointer.fromAddress(shape));
  return Vector(v.x, v.y);
}

/// Set the neighbor segments for a segment shape.
/// @param shape The segment shape.
/// @param prevX The x coordinate of the previous segment endpoint.
/// @param prevY The y coordinate of the previous segment endpoint.
/// @param nextX The x coordinate of the next segment endpoint.
/// @param nextY The y coordinate of the next segment endpoint.
void cpSegmentShapeSetNeighbors(int shape, double prevX, double prevY, double nextX, double nextY) {
  final prev = ffi.Struct.create<bindings.cpVect>()
    ..x = prevX
    ..y = prevY;
  final next = ffi.Struct.create<bindings.cpVect>()
    ..x = nextX
    ..y = nextY;
  bindings.cp_segment_shape_set_neighbors(ffi.Pointer.fromAddress(shape), prev, next);
}

/// Get the number of vertices in a polygon shape.
/// @param shape The polygon shape.
/// @return The number of vertices.
int cpPolyShapeGetCount(int shape) => bindings.cp_poly_shape_get_count(ffi.Pointer.fromAddress(shape));

/// Get a vertex of a polygon shape.
/// @param shape The polygon shape.
/// @param index The vertex index.
/// @return A tuple of (x, y) vertex coordinates.
Vector cpPolyShapeGetVert(int shape, int index) {
  final v = bindings.cp_poly_shape_get_vert(ffi.Pointer.fromAddress(shape), index);
  return Vector(v.x, v.y);
}

/// Get the radius of a polygon shape.
/// @param shape The polygon shape.
/// @return The radius.
double cpPolyShapeGetRadius(int shape) => bindings.cp_poly_shape_get_radius(ffi.Pointer.fromAddress(shape));

// ============================================================================
// Constraint Functions
// ============================================================================

/// Free a constraint.
/// @param constraint The constraint to free.
void cpConstraintFree(int constraint) => bindings.cp_constraint_free(ffi.Pointer.fromAddress(constraint));

/// Get the maximum force that a constraint can apply.
/// @param constraint The constraint.
/// @return The maximum force.
double cpConstraintGetMaxForce(int constraint) =>
    bindings.cp_constraint_get_max_force(ffi.Pointer.fromAddress(constraint));

/// Set the maximum force that a constraint can apply.
/// @param constraint The constraint.
/// @param maxForce The maximum force.
void cpConstraintSetMaxForce(int constraint, double maxForce) =>
    bindings.cp_constraint_set_max_force(ffi.Pointer.fromAddress(constraint), maxForce);

/// Get the error bias of a constraint.
/// @param constraint The constraint.
/// @return The error bias.
double cpConstraintGetErrorBias(int constraint) =>
    bindings.cp_constraint_get_error_bias(ffi.Pointer.fromAddress(constraint));

/// Set the error bias of a constraint.
/// @param constraint The constraint.
/// @param errorBias The error bias.
void cpConstraintSetErrorBias(int constraint, double errorBias) =>
    bindings.cp_constraint_set_error_bias(ffi.Pointer.fromAddress(constraint), errorBias);

/// Get the maximum bias velocity of a constraint.
/// @param constraint The constraint.
/// @return The maximum bias.
double cpConstraintGetMaxBias(int constraint) =>
    bindings.cp_constraint_get_max_bias(ffi.Pointer.fromAddress(constraint));

/// Set the maximum bias velocity of a constraint.
/// @param constraint The constraint.
/// @param maxBias The maximum bias.
void cpConstraintSetMaxBias(int constraint, double maxBias) =>
    bindings.cp_constraint_set_max_bias(ffi.Pointer.fromAddress(constraint), maxBias);

/// Get whether the two bodies connected by a constraint can collide.
/// @param constraint The constraint.
/// @return Non-zero if the bodies can collide.
int cpConstraintGetCollideBodies(int constraint) =>
    bindings.cp_constraint_get_collide_bodies(ffi.Pointer.fromAddress(constraint));

/// Set whether the two bodies connected by a constraint can collide.
/// @param constraint The constraint.
/// @param collideBodies Non-zero to allow collisions between the bodies.
void cpConstraintSetCollideBodies(int constraint, int collideBodies) =>
    bindings.cp_constraint_set_collide_bodies(ffi.Pointer.fromAddress(constraint), collideBodies);

/// Get the impulse that the constraint applied this step.
/// @param constraint The constraint.
/// @return The impulse.
double cpConstraintGetImpulse(int constraint) =>
    bindings.cp_constraint_get_impulse(ffi.Pointer.fromAddress(constraint));

/// Get the first body connected by a constraint.
/// @param constraint The constraint.
/// @return A pointer to the first body.
int cpConstraintGetBodyA(int constraint) =>
    bindings.cp_constraint_get_body_a(ffi.Pointer.fromAddress(constraint)).address;

/// Get the second body connected by a constraint.
/// @param constraint The constraint.
/// @return A pointer to the second body.
int cpConstraintGetBodyB(int constraint) =>
    bindings.cp_constraint_get_body_b(ffi.Pointer.fromAddress(constraint)).address;

// Pin Joint
/// Allocate and initialize a pin joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param anchorAx The x coordinate of the anchor point on bodyA.
/// @param anchorAy The y coordinate of the anchor point on bodyA.
/// @param anchorBx The x coordinate of the anchor point on bodyB.
/// @param anchorBy The y coordinate of the anchor point on bodyB.
/// @return A pointer to the new pin joint.
int cpPinJointNew(int bodyA, int bodyB, double anchorAx, double anchorAy, double anchorBx, double anchorBy) {
  final a = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorAx
    ..y = anchorAy;
  final b = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorBx
    ..y = anchorBy;
  return bindings
      .cp_pin_joint_new(
        ffi.Pointer.fromAddress(bodyA),
        ffi.Pointer.fromAddress(bodyB),
        a,
        b,
      )
      .address;
}

/// Get the anchor point on bodyA for a pin joint.
/// @param constraint The pin joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPinJointGetAnchorA(int constraint) {
  final v = bindings.cp_pin_joint_get_anchor_a(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyA for a pin joint.
/// @param constraint The pin joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPinJointSetAnchorA(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_pin_joint_set_anchor_a(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the anchor point on bodyB for a pin joint.
/// @param constraint The pin joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPinJointGetAnchorB(int constraint) {
  final v = bindings.cp_pin_joint_get_anchor_b(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyB for a pin joint.
/// @param constraint The pin joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPinJointSetAnchorB(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_pin_joint_set_anchor_b(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the distance between the anchor points for a pin joint.
/// @param constraint The pin joint.
/// @return The distance.
double cpPinJointGetDist(int constraint) => bindings.cp_pin_joint_get_dist(ffi.Pointer.fromAddress(constraint));

/// Set the distance between the anchor points for a pin joint.
/// @param constraint The pin joint.
/// @param dist The distance.
void cpPinJointSetDist(int constraint, double dist) =>
    bindings.cp_pin_joint_set_dist(ffi.Pointer.fromAddress(constraint), dist);

// Slide Joint
/// Allocate and initialize a slide joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param anchorAx The x coordinate of the anchor point on bodyA.
/// @param anchorAy The y coordinate of the anchor point on bodyA.
/// @param anchorBx The x coordinate of the anchor point on bodyB.
/// @param anchorBy The y coordinate of the anchor point on bodyB.
/// @param min The minimum distance between the anchor points.
/// @param max The maximum distance between the anchor points.
/// @return A pointer to the new slide joint.
int cpSlideJointNew(
  int bodyA,
  int bodyB,
  double anchorAx,
  double anchorAy,
  double anchorBx,
  double anchorBy,
  double min,
  double max,
) {
  final a = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorAx
    ..y = anchorAy;
  final b = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorBx
    ..y = anchorBy;
  return bindings
      .cp_slide_joint_new(
        ffi.Pointer.fromAddress(bodyA),
        ffi.Pointer.fromAddress(bodyB),
        a,
        b,
        min,
        max,
      )
      .address;
}

/// Get the anchor point on bodyA for a slide joint.
/// @param constraint The slide joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpSlideJointGetAnchorA(int constraint) {
  final v = bindings.cp_slide_joint_get_anchor_a(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyA for a slide joint.
/// @param constraint The slide joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpSlideJointSetAnchorA(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_slide_joint_set_anchor_a(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the anchor point on bodyB for a slide joint.
/// @param constraint The slide joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpSlideJointGetAnchorB(int constraint) {
  final v = bindings.cp_slide_joint_get_anchor_b(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyB for a slide joint.
/// @param constraint The slide joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpSlideJointSetAnchorB(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_slide_joint_set_anchor_b(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the minimum distance for a slide joint.
/// @param constraint The slide joint.
/// @return The minimum distance.
double cpSlideJointGetMin(int constraint) => bindings.cp_slide_joint_get_min(ffi.Pointer.fromAddress(constraint));

/// Set the minimum distance for a slide joint.
/// @param constraint The slide joint.
/// @param min The minimum distance.
void cpSlideJointSetMin(int constraint, double min) =>
    bindings.cp_slide_joint_set_min(ffi.Pointer.fromAddress(constraint), min);

/// Get the maximum distance for a slide joint.
/// @param constraint The slide joint.
/// @return The maximum distance.
double cpSlideJointGetMax(int constraint) => bindings.cp_slide_joint_get_max(ffi.Pointer.fromAddress(constraint));

/// Set the maximum distance for a slide joint.
/// @param constraint The slide joint.
/// @param max The maximum distance.
void cpSlideJointSetMax(int constraint, double max) =>
    bindings.cp_slide_joint_set_max(ffi.Pointer.fromAddress(constraint), max);

// Pivot Joint
/// Allocate and initialize a pivot joint with a single pivot point.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param pivotX The x coordinate of the pivot point in world space.
/// @param pivotY The y coordinate of the pivot point in world space.
/// @return A pointer to the new pivot joint.
int cpPivotJointNew(int bodyA, int bodyB, double pivotX, double pivotY) {
  final pivot = ffi.Struct.create<bindings.cpVect>()
    ..x = pivotX
    ..y = pivotY;
  return bindings
      .cp_pivot_joint_new(
        ffi.Pointer.fromAddress(bodyA),
        ffi.Pointer.fromAddress(bodyB),
        pivot,
      )
      .address;
}

/// Allocate and initialize a pivot joint with separate anchor points.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param anchorAx The x coordinate of the anchor point on bodyA.
/// @param anchorAy The y coordinate of the anchor point on bodyA.
/// @param anchorBx The x coordinate of the anchor point on bodyB.
/// @param anchorBy The y coordinate of the anchor point on bodyB.
/// @return A pointer to the new pivot joint.
int cpPivotJointNew2(int bodyA, int bodyB, double anchorAx, double anchorAy, double anchorBx, double anchorBy) {
  final a = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorAx
    ..y = anchorAy;
  final b = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorBx
    ..y = anchorBy;
  return bindings
      .cp_pivot_joint_new2(
        ffi.Pointer.fromAddress(bodyA),
        ffi.Pointer.fromAddress(bodyB),
        a,
        b,
      )
      .address;
}

/// Get the anchor point on bodyA for a pivot joint.
/// @param constraint The pivot joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPivotJointGetAnchorA(int constraint) {
  final v = bindings.cp_pivot_joint_get_anchor_a(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyA for a pivot joint.
/// @param constraint The pivot joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPivotJointSetAnchorA(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_pivot_joint_set_anchor_a(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the anchor point on bodyB for a pivot joint.
/// @param constraint The pivot joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPivotJointGetAnchorB(int constraint) {
  final v = bindings.cp_pivot_joint_get_anchor_b(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyB for a pivot joint.
/// @param constraint The pivot joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPivotJointSetAnchorB(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_pivot_joint_set_anchor_b(ffi.Pointer.fromAddress(constraint), v);
}

// Groove Joint
/// Allocate and initialize a groove joint.
/// @param bodyA The first body to connect (the one with the groove).
/// @param bodyB The second body to connect.
/// @param grooveAx The x coordinate of the first groove endpoint on bodyA.
/// @param grooveAy The y coordinate of the first groove endpoint on bodyA.
/// @param grooveBx The x coordinate of the second groove endpoint on bodyA.
/// @param grooveBy The y coordinate of the second groove endpoint on bodyA.
/// @param anchorBx The x coordinate of the anchor point on bodyB.
/// @param anchorBy The y coordinate of the anchor point on bodyB.
/// @return A pointer to the new groove joint.
int cpGrooveJointNew(
  int bodyA,
  int bodyB,
  double grooveAx,
  double grooveAy,
  double grooveBx,
  double grooveBy,
  double anchorBx,
  double anchorBy,
) {
  final ga = ffi.Struct.create<bindings.cpVect>()
    ..x = grooveAx
    ..y = grooveAy;
  final gb = ffi.Struct.create<bindings.cpVect>()
    ..x = grooveBx
    ..y = grooveBy;
  final ab = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorBx
    ..y = anchorBy;
  return bindings
      .cp_groove_joint_new(
        ffi.Pointer.fromAddress(bodyA),
        ffi.Pointer.fromAddress(bodyB),
        ga,
        gb,
        ab,
      )
      .address;
}

/// Get the first groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) groove endpoint coordinates.
Vector cpGrooveJointGetGrooveA(int constraint) {
  final v = bindings.cp_groove_joint_get_groove_a(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the first groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the groove endpoint.
/// @param y The y coordinate of the groove endpoint.
void cpGrooveJointSetGrooveA(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_groove_joint_set_groove_a(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the second groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) groove endpoint coordinates.
Vector cpGrooveJointGetGrooveB(int constraint) {
  final v = bindings.cp_groove_joint_get_groove_b(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the second groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the groove endpoint.
/// @param y The y coordinate of the groove endpoint.
void cpGrooveJointSetGrooveB(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_groove_joint_set_groove_b(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the anchor point on bodyB for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpGrooveJointGetAnchorB(int constraint) {
  final v = bindings.cp_groove_joint_get_anchor_b(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyB for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpGrooveJointSetAnchorB(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_groove_joint_set_anchor_b(ffi.Pointer.fromAddress(constraint), v);
}

// Damped Spring
/// Allocate and initialize a damped spring constraint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param anchorAx The x coordinate of the anchor point on bodyA.
/// @param anchorAy The y coordinate of the anchor point on bodyA.
/// @param anchorBx The x coordinate of the anchor point on bodyB.
/// @param anchorBy The y coordinate of the anchor point on bodyB.
/// @param restLength The rest length of the spring.
/// @param stiffness The spring stiffness.
/// @param damping The spring damping.
/// @return A pointer to the new damped spring constraint.
int cpDampedSpringNew(
  int bodyA,
  int bodyB,
  double anchorAx,
  double anchorAy,
  double anchorBx,
  double anchorBy,
  double restLength,
  double stiffness,
  double damping,
) {
  final a = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorAx
    ..y = anchorAy;
  final b = ffi.Struct.create<bindings.cpVect>()
    ..x = anchorBx
    ..y = anchorBy;
  return bindings
      .cp_damped_spring_new(
        ffi.Pointer.fromAddress(bodyA),
        ffi.Pointer.fromAddress(bodyB),
        a,
        b,
        restLength,
        stiffness,
        damping,
      )
      .address;
}

/// Get the anchor point on bodyA for a damped spring.
/// @param constraint The damped spring.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpDampedSpringGetAnchorA(int constraint) {
  final v = bindings.cp_damped_spring_get_anchor_a(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyA for a damped spring.
/// @param constraint The damped spring.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpDampedSpringSetAnchorA(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_damped_spring_set_anchor_a(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the anchor point on bodyB for a damped spring.
/// @param constraint The damped spring.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpDampedSpringGetAnchorB(int constraint) {
  final v = bindings.cp_damped_spring_get_anchor_b(ffi.Pointer.fromAddress(constraint));
  return Vector(v.x, v.y);
}

/// Set the anchor point on bodyB for a damped spring.
/// @param constraint The damped spring.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpDampedSpringSetAnchorB(int constraint, double x, double y) {
  final v = ffi.Struct.create<bindings.cpVect>()
    ..x = x
    ..y = y;
  bindings.cp_damped_spring_set_anchor_b(ffi.Pointer.fromAddress(constraint), v);
}

/// Get the rest length of a damped spring.
/// @param constraint The damped spring.
/// @return The rest length.
double cpDampedSpringGetRestLength(int constraint) =>
    bindings.cp_damped_spring_get_rest_length(ffi.Pointer.fromAddress(constraint));

/// Set the rest length of a damped spring.
/// @param constraint The damped spring.
/// @param restLength The rest length.
void cpDampedSpringSetRestLength(int constraint, double restLength) =>
    bindings.cp_damped_spring_set_rest_length(ffi.Pointer.fromAddress(constraint), restLength);

/// Get the stiffness of a damped spring.
/// @param constraint The damped spring.
/// @return The stiffness.
double cpDampedSpringGetStiffness(int constraint) =>
    bindings.cp_damped_spring_get_stiffness(ffi.Pointer.fromAddress(constraint));

/// Set the stiffness of a damped spring.
/// @param constraint The damped spring.
/// @param stiffness The stiffness.
void cpDampedSpringSetStiffness(int constraint, double stiffness) =>
    bindings.cp_damped_spring_set_stiffness(ffi.Pointer.fromAddress(constraint), stiffness);

/// Get the damping of a damped spring.
/// @param constraint The damped spring.
/// @return The damping.
double cpDampedSpringGetDamping(int constraint) =>
    bindings.cp_damped_spring_get_damping(ffi.Pointer.fromAddress(constraint));

/// Set the damping of a damped spring.
/// @param constraint The damped spring.
/// @param damping The damping.
void cpDampedSpringSetDamping(int constraint, double damping) =>
    bindings.cp_damped_spring_set_damping(ffi.Pointer.fromAddress(constraint), damping);

// Damped Rotary Spring
/// Allocate and initialize a damped rotary spring constraint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param restAngle The rest angle of the spring in radians.
/// @param stiffness The spring stiffness.
/// @param damping The spring damping.
/// @return A pointer to the new damped rotary spring constraint.
int cpDampedRotarySpringNew(int bodyA, int bodyB, double restAngle, double stiffness, double damping) => bindings
    .cp_damped_rotary_spring_new(
      ffi.Pointer.fromAddress(bodyA),
      ffi.Pointer.fromAddress(bodyB),
      restAngle,
      stiffness,
      damping,
    )
    .address;

/// Get the rest angle of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The rest angle in radians.
double cpDampedRotarySpringGetRestAngle(int constraint) =>
    bindings.cp_damped_rotary_spring_get_rest_angle(ffi.Pointer.fromAddress(constraint));

/// Set the rest angle of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param restAngle The rest angle in radians.
void cpDampedRotarySpringSetRestAngle(int constraint, double restAngle) =>
    bindings.cp_damped_rotary_spring_set_rest_angle(ffi.Pointer.fromAddress(constraint), restAngle);

/// Get the stiffness of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The stiffness.
double cpDampedRotarySpringGetStiffness(int constraint) =>
    bindings.cp_damped_rotary_spring_get_stiffness(ffi.Pointer.fromAddress(constraint));

/// Set the stiffness of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param stiffness The stiffness.
void cpDampedRotarySpringSetStiffness(int constraint, double stiffness) =>
    bindings.cp_damped_rotary_spring_set_stiffness(ffi.Pointer.fromAddress(constraint), stiffness);

/// Get the damping of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The damping.
double cpDampedRotarySpringGetDamping(int constraint) =>
    bindings.cp_damped_rotary_spring_get_damping(ffi.Pointer.fromAddress(constraint));

/// Set the damping of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param damping The damping.
void cpDampedRotarySpringSetDamping(int constraint, double damping) =>
    bindings.cp_damped_rotary_spring_set_damping(ffi.Pointer.fromAddress(constraint), damping);

// Rotary Limit Joint
/// Allocate and initialize a rotary limit joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param min The minimum angle in radians.
/// @param max The maximum angle in radians.
/// @return A pointer to the new rotary limit joint.
int cpRotaryLimitJointNew(int bodyA, int bodyB, double min, double max) => bindings
    .cp_rotary_limit_joint_new(
      ffi.Pointer.fromAddress(bodyA),
      ffi.Pointer.fromAddress(bodyB),
      min,
      max,
    )
    .address;

/// Get the minimum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @return The minimum angle in radians.
double cpRotaryLimitJointGetMin(int constraint) =>
    bindings.cp_rotary_limit_joint_get_min(ffi.Pointer.fromAddress(constraint));

/// Set the minimum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @param min The minimum angle in radians.
void cpRotaryLimitJointSetMin(int constraint, double min) =>
    bindings.cp_rotary_limit_joint_set_min(ffi.Pointer.fromAddress(constraint), min);

/// Get the maximum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @return The maximum angle in radians.
double cpRotaryLimitJointGetMax(int constraint) =>
    bindings.cp_rotary_limit_joint_get_max(ffi.Pointer.fromAddress(constraint));

/// Set the maximum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @param max The maximum angle in radians.
void cpRotaryLimitJointSetMax(int constraint, double max) =>
    bindings.cp_rotary_limit_joint_set_max(ffi.Pointer.fromAddress(constraint), max);

// Ratchet Joint
/// Allocate and initialize a ratchet joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param phase The phase offset in radians.
/// @param ratchet The ratchet angle in radians.
/// @return A pointer to the new ratchet joint.
int cpRatchetJointNew(int bodyA, int bodyB, double phase, double ratchet) => bindings
    .cp_ratchet_joint_new(
      ffi.Pointer.fromAddress(bodyA),
      ffi.Pointer.fromAddress(bodyB),
      phase,
      ratchet,
    )
    .address;

/// Get the current angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The current angle in radians.
double cpRatchetJointGetAngle(int constraint) =>
    bindings.cp_ratchet_joint_get_angle(ffi.Pointer.fromAddress(constraint));

/// Set the current angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param angle The current angle in radians.
void cpRatchetJointSetAngle(int constraint, double angle) =>
    bindings.cp_ratchet_joint_set_angle(ffi.Pointer.fromAddress(constraint), angle);

/// Get the phase offset for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The phase offset in radians.
double cpRatchetJointGetPhase(int constraint) =>
    bindings.cp_ratchet_joint_get_phase(ffi.Pointer.fromAddress(constraint));

/// Set the phase offset for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param phase The phase offset in radians.
void cpRatchetJointSetPhase(int constraint, double phase) =>
    bindings.cp_ratchet_joint_set_phase(ffi.Pointer.fromAddress(constraint), phase);

/// Get the ratchet angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The ratchet angle in radians.
double cpRatchetJointGetRatchet(int constraint) =>
    bindings.cp_ratchet_joint_get_ratchet(ffi.Pointer.fromAddress(constraint));

/// Set the ratchet angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param ratchet The ratchet angle in radians.
void cpRatchetJointSetRatchet(int constraint, double ratchet) =>
    bindings.cp_ratchet_joint_set_ratchet(ffi.Pointer.fromAddress(constraint), ratchet);

// Gear Joint
/// Allocate and initialize a gear joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param phase The phase offset in radians.
/// @param ratio The gear ratio.
/// @return A pointer to the new gear joint.
int cpGearJointNew(int bodyA, int bodyB, double phase, double ratio) => bindings
    .cp_gear_joint_new(
      ffi.Pointer.fromAddress(bodyA),
      ffi.Pointer.fromAddress(bodyB),
      phase,
      ratio,
    )
    .address;

/// Get the phase offset for a gear joint.
/// @param constraint The gear joint.
/// @return The phase offset in radians.
double cpGearJointGetPhase(int constraint) => bindings.cp_gear_joint_get_phase(ffi.Pointer.fromAddress(constraint));

/// Set the phase offset for a gear joint.
/// @param constraint The gear joint.
/// @param phase The phase offset in radians.
void cpGearJointSetPhase(int constraint, double phase) =>
    bindings.cp_gear_joint_set_phase(ffi.Pointer.fromAddress(constraint), phase);

/// Get the gear ratio for a gear joint.
/// @param constraint The gear joint.
/// @return The gear ratio.
double cpGearJointGetRatio(int constraint) => bindings.cp_gear_joint_get_ratio(ffi.Pointer.fromAddress(constraint));

/// Set the gear ratio for a gear joint.
/// @param constraint The gear joint.
/// @param ratio The gear ratio.
void cpGearJointSetRatio(int constraint, double ratio) =>
    bindings.cp_gear_joint_set_ratio(ffi.Pointer.fromAddress(constraint), ratio);

// Simple Motor
/// Allocate and initialize a simple motor constraint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param rate The rate of rotation in radians per second.
/// @return A pointer to the new simple motor constraint.
int cpSimpleMotorNew(int bodyA, int bodyB, double rate) => bindings
    .cp_simple_motor_new(
      ffi.Pointer.fromAddress(bodyA),
      ffi.Pointer.fromAddress(bodyB),
      rate,
    )
    .address;

/// Get the rate of rotation for a simple motor.
/// @param constraint The simple motor.
/// @return The rate of rotation in radians per second.
double cpSimpleMotorGetRate(int constraint) => bindings.cp_simple_motor_get_rate(ffi.Pointer.fromAddress(constraint));

/// Set the rate of rotation for a simple motor.
/// @param constraint The simple motor.
/// @param rate The rate of rotation in radians per second.
void cpSimpleMotorSetRate(int constraint, double rate) =>
    bindings.cp_simple_motor_set_rate(ffi.Pointer.fromAddress(constraint), rate);

// ============================================================================
// Moment Functions
// ============================================================================

/// Calculate the moment of inertia for a circle.
/// @param mass The mass of the circle.
/// @param r1 The inner radius (0 for solid circles).
/// @param r2 The outer radius.
/// @param offsetX The x offset of the center of gravity.
/// @param offsetY The y offset of the center of gravity.
/// @return The moment of inertia.
double cpMomentForCircle(double mass, double r1, double r2, double offsetX, double offsetY) {
  final offset = ffi.Struct.create<bindings.cpVect>()
    ..x = offsetX
    ..y = offsetY;
  return bindings.cp_moment_for_circle(mass, r1, r2, offset);
}

/// Calculate the moment of inertia for a line segment.
/// @param mass The mass of the segment.
/// @param ax The x coordinate of the first endpoint.
/// @param ay The y coordinate of the first endpoint.
/// @param bx The x coordinate of the second endpoint.
/// @param by The y coordinate of the second endpoint.
/// @param radius The radius of the segment (for fattened segments).
/// @return The moment of inertia.
double cpMomentForSegment(double mass, double ax, double ay, double bx, double by, double radius) {
  final a = ffi.Struct.create<bindings.cpVect>()
    ..x = ax
    ..y = ay;
  final b = ffi.Struct.create<bindings.cpVect>()
    ..x = bx
    ..y = by;
  return bindings.cp_moment_for_segment(mass, a, b, radius);
}

/// Calculate the moment of inertia for a solid box.
/// @param mass The mass of the box.
/// @param width The width of the box.
/// @param height The height of the box.
/// @return The moment of inertia.
double cpMomentForBox(double mass, double width, double height) => bindings.cp_moment_for_box(mass, width, height);

/// Calculate the area of a hollow circle.
/// @param r1 The inner radius (0 for solid circles).
/// @param r2 The outer radius.
/// @return The area.
double cpAreaForCircle(double r1, double r2) => bindings.cp_area_for_circle(r1, r2);

/// Calculate the area of a fattened (capsule shaped) line segment.
/// @param ax The x coordinate of the first endpoint.
/// @param ay The y coordinate of the first endpoint.
/// @param bx The x coordinate of the second endpoint.
/// @param by The y coordinate of the second endpoint.
/// @param radius The radius of the segment.
/// @return The area.
double cpAreaForSegment(double ax, double ay, double bx, double by, double radius) {
  final a = ffi.Struct.create<bindings.cpVect>()
    ..x = ax
    ..y = ay;
  final b = ffi.Struct.create<bindings.cpVect>()
    ..x = bx
    ..y = by;
  return bindings.cp_area_for_segment(a, b, radius);
}

/// Calculate the moment of inertia for a solid polygon shape.
/// @param mass The mass of the polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @param offsetX The x offset of the center of gravity.
/// @param offsetY The y offset of the center of gravity.
/// @param radius The radius (for rounded corners).
/// @return The moment of inertia.
double cpMomentForPoly(double mass, List<double> verts, double offsetX, double offsetY, double radius) {
  if (verts.length % 2 != 0) {
    throw ArgumentError('Vertex list must have even number of elements (x, y pairs)');
  }
  final count = verts.length ~/ 2;
  final vertsPtr = ffi.malloc<bindings.cpVect>(count);
  for (var i = 0; i < count; i++) {
    vertsPtr[i] = ffi.Struct.create<bindings.cpVect>()
      ..x = verts[i * 2]
      ..y = verts[i * 2 + 1];
  }
  final offset = ffi.Struct.create<bindings.cpVect>()
    ..x = offsetX
    ..y = offsetY;
  final result = bindings.cp_moment_for_poly(mass, count, vertsPtr, offset, radius);
  ffi.malloc.free(vertsPtr);
  return result;
}

/// Calculate the signed area of a polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @param radius The radius (for rounded corners).
/// @return The signed area (clockwise winding gives positive area).
double cpAreaForPoly(List<double> verts, double radius) {
  if (verts.length % 2 != 0) {
    throw ArgumentError('Vertex list must have even number of elements (x, y pairs)');
  }
  final count = verts.length ~/ 2;
  final vertsPtr = ffi.malloc<bindings.cpVect>(count);
  for (var i = 0; i < count; i++) {
    vertsPtr[i] = ffi.Struct.create<bindings.cpVect>()
      ..x = verts[i * 2]
      ..y = verts[i * 2 + 1];
  }
  final result = bindings.cp_area_for_poly(count, vertsPtr, radius);
  ffi.malloc.free(vertsPtr);
  return result;
}

/// Calculate the centroid of a polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @return A tuple of (x, y) centroid coordinates.
Vector cpCentroidForPoly(List<double> verts) {
  if (verts.length % 2 != 0) {
    throw ArgumentError('Vertex list must have even number of elements (x, y pairs)');
  }
  final count = verts.length ~/ 2;
  final vertsPtr = ffi.malloc<bindings.cpVect>(count);
  for (var i = 0; i < count; i++) {
    vertsPtr[i] = ffi.Struct.create<bindings.cpVect>()
      ..x = verts[i * 2]
      ..y = verts[i * 2 + 1];
  }
  final centroid = bindings.cp_centroid_for_poly(count, vertsPtr);
  ffi.malloc.free(vertsPtr);
  return Vector(centroid.x, centroid.y);
}

/// Calculate the moment of inertia for a box defined by a bounding box.
/// @param mass The mass of the box.
/// @param left The left edge of the bounding box.
/// @param bottom The bottom edge of the bounding box.
/// @param right The right edge of the bounding box.
/// @param top The top edge of the bounding box.
/// @return The moment of inertia.
double cpMomentForBox2(double mass, double left, double bottom, double right, double top) {
  final bb = ffi.Struct.create<bindings.cpBB>()
    ..l = left
    ..b = bottom
    ..r = right
    ..t = top;
  return bindings.cp_moment_for_box2(mass, bb);
}

/// Calculate the convex hull of a set of points.
/// @param points The flattened list of points [x1, y1, x2, y2, ...].
/// @param tolerance The tolerance for the convex hull calculation.
/// @return A flattened list of hull vertices [x1, y1, x2, y2, ...].
List<double> cpConvexHull(List<double> points, {double tolerance = 0.0}) {
  if (points.length % 2 != 0) {
    throw ArgumentError('Point list must have even number of elements (x, y pairs)');
  }
  final count = points.length ~/ 2;
  final pointsPtr = ffi.malloc<bindings.cpVect>(count);
  for (var i = 0; i < count; i++) {
    pointsPtr[i] = ffi.Struct.create<bindings.cpVect>()
      ..x = points[i * 2]
      ..y = points[i * 2 + 1];
  }
  final resultPtr = ffi.malloc<bindings.cpVect>(count);
  final firstPtr = ffi.malloc<ffi.Int>();
  final hullCount = bindings.cp_convex_hull(count, pointsPtr, resultPtr, firstPtr, tolerance);
  final result = <double>[];
  for (var i = 0; i < hullCount; i++) {
    result
      ..add(resultPtr[i].x)
      ..add(resultPtr[i].y);
  }
  ffi.malloc
    ..free(pointsPtr)
    ..free(resultPtr)
    ..free(firstPtr);
  return result;
}
