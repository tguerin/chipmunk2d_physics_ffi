/// Stub implementation - throws if neither FFI nor JS interop is available.
library;

import 'package:chipmunk2d_physics_ffi/src/bounding_box.dart';
import 'package:chipmunk2d_physics_ffi/src/shape.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

// ============================================================================
// Helper Functions
// ============================================================================

/// Stub that throws when platform is not supported.
Never _unsupported() {
  throw UnsupportedError(
    'Chipmunk2D: Cannot determine platform. '
    'Neither dart:ffi nor dart:js_interop is available.',
  );
}

// ============================================================================
// Initialization
// ============================================================================

/// Initialize the Chipmunk2D bindings.
/// Must be called before using any Chipmunk2D functions.
/// On web, this loads the WASM module.
Future<void> initializeChipmunk({String? wasmPath, String? jsPath}) async {
  _unsupported();
}

/// Whether the bindings have been initialized.
bool get isChipmunkInitialized => _unsupported();

// ============================================================================
// Space Functions
// ============================================================================

/// Creates a new physics space.
/// @return A pointer to the newly created cpSpace.
int cpSpaceNew() => _unsupported();

/// Frees a cpSpace.
/// @param space The cpSpace to free.
void cpSpaceFree(int space) => _unsupported();

/// Update the physics space by stepping forward by dt seconds.
/// @param space The space to step.
/// @param dt The time step in seconds.
void cpSpaceStep(int space, double dt) => _unsupported();

/// Set the gravity vector for the space.
/// @param space The space.
/// @param x The x component of the gravity vector.
/// @param y The y component of the gravity vector.
void cpSpaceSetGravity(int space, double x, double y) => _unsupported();

/// Get the gravity vector for the space.
/// @param space The space.
/// @return A tuple of (x, y) gravity components.
Vector cpSpaceGetGravity(int space) => _unsupported();

/// Get the number of iterations to use when solving constraints.
/// @param space The space.
/// @return The number of iterations.
int cpSpaceGetIterations(int space) => _unsupported();

/// Set the number of iterations to use when solving constraints.
/// @param space The space.
/// @param iterations The number of iterations.
void cpSpaceSetIterations(int space, int iterations) => _unsupported();

/// Get the damping rate for the space.
/// @param space The space.
/// @return The damping rate (fraction of velocity retained per second).
double cpSpaceGetDamping(int space) => _unsupported();

/// Set the damping rate for the space.
/// @param space The space.
/// @param damping The damping rate (fraction of velocity retained per second).
void cpSpaceSetDamping(int space, double damping) => _unsupported();

/// Get the speed threshold for a body to be considered idle.
/// @param space The space.
/// @return The idle speed threshold.
double cpSpaceGetIdleSpeedThreshold(int space) => _unsupported();

/// Set the speed threshold for a body to be considered idle.
/// @param space The space.
/// @param threshold The idle speed threshold.
void cpSpaceSetIdleSpeedThreshold(int space, double threshold) => _unsupported();

/// Get the time a group of bodies must remain idle to fall asleep.
/// @param space The space.
/// @return The sleep time threshold.
double cpSpaceGetSleepTimeThreshold(int space) => _unsupported();

/// Set the time a group of bodies must remain idle to fall asleep.
/// @param space The space.
/// @param threshold The sleep time threshold.
void cpSpaceSetSleepTimeThreshold(int space, double threshold) => _unsupported();

/// Get the amount of encouraged penetration between colliding shapes.
/// @param space The space.
/// @return The collision slop.
double cpSpaceGetCollisionSlop(int space) => _unsupported();

/// Set the amount of encouraged penetration between colliding shapes.
/// @param space The space.
/// @param slop The collision slop.
void cpSpaceSetCollisionSlop(int space, double slop) => _unsupported();

/// Get how fast overlapping shapes are pushed apart.
/// @param space The space.
/// @return The collision bias.
double cpSpaceGetCollisionBias(int space) => _unsupported();

/// Set how fast overlapping shapes are pushed apart.
/// @param space The space.
/// @param bias The collision bias.
void cpSpaceSetCollisionBias(int space, double bias) => _unsupported();

/// Get the number of frames that contact information should persist.
/// @param space The space.
/// @return The collision persistence.
int cpSpaceGetCollisionPersistence(int space) => _unsupported();

/// Set the number of frames that contact information should persist.
/// @param space The space.
/// @param persistence The collision persistence.
void cpSpaceSetCollisionPersistence(int space, int persistence) => _unsupported();

/// Get the current (or most recent) time step used with this space.
/// @param space The space.
/// @return The current time step.
double cpSpaceGetCurrentTimeStep(int space) => _unsupported();

/// Returns true from inside a callback when objects cannot be added/removed.
/// @param space The space.
/// @return Non-zero if the space is locked.
int cpSpaceIsLocked(int space) => _unsupported();

/// Get the space's built-in static body.
/// @param space The space.
/// @return A pointer to the static body.
int cpSpaceGetStaticBody(int space) => _unsupported();

/// Add a body to a space.
/// @param space The space.
/// @param body The body to add.
void cpSpaceAddBody(int space, int body) => _unsupported();

/// Remove a body from a space.
/// @param space The space.
/// @param body The body to remove.
void cpSpaceRemoveBody(int space, int body) => _unsupported();

/// Add a shape to a space.
/// @param space The space.
/// @param shape The shape to add.
void cpSpaceAddShape(int space, int shape) => _unsupported();

/// Remove a shape from a space.
/// @param space The space.
/// @param shape The shape to remove.
void cpSpaceRemoveShape(int space, int shape) => _unsupported();

/// Add a constraint to a space.
/// @param space The space.
/// @param constraint The constraint to add.
void cpSpaceAddConstraint(int space, int constraint) => _unsupported();

/// Remove a constraint from a space.
/// @param space The space.
/// @param constraint The constraint to remove.
void cpSpaceRemoveConstraint(int space, int constraint) => _unsupported();

/// Test if a collision shape has been added to the space.
/// @param space The space.
/// @param shape The shape to test.
/// @return Non-zero if the shape is in the space.
int cpSpaceContainsShape(int space, int shape) => _unsupported();

/// Test if a rigid body has been added to the space.
/// @param space The space.
/// @param body The body to test.
/// @return Non-zero if the body is in the space.
int cpSpaceContainsBody(int space, int body) => _unsupported();

/// Test if a constraint has been added to the space.
/// @param space The space.
/// @param constraint The constraint to test.
/// @return Non-zero if the constraint is in the space.
int cpSpaceContainsConstraint(int space, int constraint) => _unsupported();

/// Update the collision detection info for the static shapes in the space.
/// @param space The space.
void cpSpaceReindexStatic(int space) => _unsupported();

/// Update the collision detection data for a specific shape in the space.
/// @param space The space.
/// @param shape The shape to reindex.
void cpSpaceReindexShape(int space, int shape) => _unsupported();

/// Update the collision detection data for all shapes attached to a body.
/// @param space The space.
/// @param body The body whose shapes should be reindexed.
void cpSpaceReindexShapesForBody(int space, int body) => _unsupported();

// ============================================================================
// Body Functions
// ============================================================================

/// Allocate and initialize a cpBody with the given mass and moment.
/// @param mass The mass of the body.
/// @param moment The moment of inertia of the body.
/// @return A pointer to the new body.
int cpBodyNew(double mass, double moment) => _unsupported();

/// Allocate and initialize a cpBody as a kinematic body.
/// Kinematic bodies have infinite mass and moment, and are not affected by forces.
/// @return A pointer to the new kinematic body.
int cpBodyNewKinematic() => _unsupported();

/// Allocate and initialize a cpBody as a static body.
/// Static bodies have infinite mass and moment, and never move.
/// @return A pointer to the new static body.
int cpBodyNewStatic() => _unsupported();

/// Free a body.
/// @param body The body to free.
void cpBodyFree(int body) => _unsupported();

/// Get the position of a body.
/// @param body The body.
/// @return A tuple of (x, y) position components.
Vector cpBodyGetPosition(int body) => _unsupported();

/// Set the position of a body.
/// @param body The body.
/// @param x The x component of the position.
/// @param y The y component of the position.
void cpBodySetPosition(int body, double x, double y) => _unsupported();

/// Get the velocity of a body.
/// @param body The body.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocity(int body) => _unsupported();

/// Set the velocity of a body.
/// @param body The body.
/// @param x The x component of the velocity.
/// @param y The y component of the velocity.
void cpBodySetVelocity(int body, double x, double y) => _unsupported();

/// Get the angle of a body in radians.
/// @param body The body.
/// @return The angle in radians.
double cpBodyGetAngle(int body) => _unsupported();

/// Set the angle of a body in radians.
/// @param body The body.
/// @param angle The angle in radians.
void cpBodySetAngle(int body, double angle) => _unsupported();

/// Get the mass of a body.
/// @param body The body.
/// @return The mass.
double cpBodyGetMass(int body) => _unsupported();

/// Set the mass of a body.
/// @param body The body.
/// @param mass The mass.
void cpBodySetMass(int body, double mass) => _unsupported();

/// Get the moment of inertia of a body.
/// @param body The body.
/// @return The moment of inertia.
double cpBodyGetMoment(int body) => _unsupported();

/// Set the moment of inertia of a body.
/// @param body The body.
/// @param moment The moment of inertia.
void cpBodySetMoment(int body, double moment) => _unsupported();

/// Get the angular velocity of a body in radians per second.
/// @param body The body.
/// @return The angular velocity in radians per second.
double cpBodyGetAngularVelocity(int body) => _unsupported();

/// Set the angular velocity of a body in radians per second.
/// @param body The body.
/// @param angularVelocity The angular velocity in radians per second.
void cpBodySetAngularVelocity(int body, double angularVelocity) => _unsupported();

/// Get the center of gravity offset in body local coordinates.
/// @param body The body.
/// @return A tuple of (x, y) center of gravity components.
Vector cpBodyGetCenterOfGravity(int body) => _unsupported();

/// Set the center of gravity offset in body local coordinates.
/// @param body The body.
/// @param x The x component of the center of gravity.
/// @param y The y component of the center of gravity.
void cpBodySetCenterOfGravity(int body, double x, double y) => _unsupported();

/// Get the force applied to a body for the next time step.
/// @param body The body.
/// @return A tuple of (x, y) force components.
Vector cpBodyGetForce(int body) => _unsupported();

/// Set the force applied to a body for the next time step.
/// @param body The body.
/// @param x The x component of the force.
/// @param y The y component of the force.
void cpBodySetForce(int body, double x, double y) => _unsupported();

/// Get the torque applied to a body for the next time step.
/// @param body The body.
/// @return The torque.
double cpBodyGetTorque(int body) => _unsupported();

/// Set the torque applied to a body for the next time step.
/// @param body The body.
/// @param torque The torque.
void cpBodySetTorque(int body, double torque) => _unsupported();

/// Get the rotation vector of a body (the x basis vector of its transform).
/// @param body The body.
/// @return A tuple of (x, y) rotation components.
Vector cpBodyGetRotation(int body) => _unsupported();

/// Get the type of a body.
/// @param body The body.
/// @return The body type (0=dynamic, 1=kinematic, 2=static).
int cpBodyGetType(int body) => _unsupported();

/// Set the type of a body.
/// @param body The body.
/// @param type The body type (0=dynamic, 1=kinematic, 2=static).
void cpBodySetType(int body, int type) => _unsupported();

/// Returns true if the body is sleeping.
/// @param body The body.
/// @return Non-zero if the body is sleeping.
int cpBodyIsSleeping(int body) => _unsupported();

/// Wake up a sleeping or idle body.
/// @param body The body.
void cpBodyActivate(int body) => _unsupported();

/// Wake up any sleeping or idle bodies touching a static body.
/// @param body The static body.
/// @param filter Optional shape filter (0 for all shapes).
void cpBodyActivateStatic(int body, int filter) => _unsupported();

/// Force a body to fall asleep immediately.
/// @param body The body.
void cpBodySleep(int body) => _unsupported();

/// Force a body to fall asleep immediately along with other bodies in a group.
/// @param body The body.
/// @param group The group body.
void cpBodySleepWithGroup(int body, int group) => _unsupported();

/// Convert body relative/local coordinates to absolute/world coordinates.
/// @param body The body.
/// @param x The x coordinate in body local space.
/// @param y The y coordinate in body local space.
/// @return A tuple of (x, y) world coordinates.
Vector cpBodyLocalToWorld(int body, double x, double y) => _unsupported();

/// Convert body absolute/world coordinates to relative/local coordinates.
/// @param body The body.
/// @param x The x coordinate in world space.
/// @param y The y coordinate in world space.
/// @return A tuple of (x, y) local coordinates.
Vector cpBodyWorldToLocal(int body, double x, double y) => _unsupported();

/// Apply a force to a body. Both the force and point are expressed in world coordinates.
/// @param body The body.
/// @param fx The x component of the force.
/// @param fy The y component of the force.
/// @param px The x coordinate of the point in world space.
/// @param py The y coordinate of the point in world space.
void cpBodyApplyForceAtWorldPoint(int body, double fx, double fy, double px, double py) => _unsupported();

/// Apply a force to a body. Both the force and point are expressed in body local coordinates.
/// @param body The body.
/// @param fx The x component of the force.
/// @param fy The y component of the force.
/// @param px The x coordinate of the point in body local space.
/// @param py The y coordinate of the point in body local space.
void cpBodyApplyForceAtLocalPoint(int body, double fx, double fy, double px, double py) => _unsupported();

/// Apply an impulse to a body. Both the impulse and point are expressed in world coordinates.
/// @param body The body.
/// @param ix The x component of the impulse.
/// @param iy The y component of the impulse.
/// @param px The x coordinate of the point in world space.
/// @param py The y coordinate of the point in world space.
void cpBodyApplyImpulseAtWorldPoint(int body, double ix, double iy, double px, double py) => _unsupported();

/// Apply an impulse to a body. Both the impulse and point are expressed in body local coordinates.
/// @param body The body.
/// @param ix The x component of the impulse.
/// @param iy The y component of the impulse.
/// @param px The x coordinate of the point in body local space.
/// @param py The y coordinate of the point in body local space.
void cpBodyApplyImpulseAtLocalPoint(int body, double ix, double iy, double px, double py) => _unsupported();

/// Get the velocity on a body at a point in world coordinates.
/// @param body The body.
/// @param x The x coordinate of the point in world space.
/// @param y The y coordinate of the point in world space.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocityAtWorldPoint(int body, double x, double y) => _unsupported();

/// Get the velocity on a body at a point in body local coordinates.
/// @param body The body.
/// @param x The x coordinate of the point in body local space.
/// @param y The y coordinate of the point in body local space.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocityAtLocalPoint(int body, double x, double y) => _unsupported();

/// Get the amount of kinetic energy contained by the body.
/// @param body The body.
/// @return The kinetic energy.
double cpBodyKineticEnergy(int body) => _unsupported();

// ============================================================================
// Shape Functions
// ============================================================================

/// Allocate and initialize a circle shape.
/// @param body The body to attach the shape to.
/// @param radius The radius of the circle.
/// @param offsetX The x offset of the circle center from the body's center of gravity.
/// @param offsetY The y offset of the circle center from the body's center of gravity.
/// @return A pointer to the new circle shape.
int cpCircleShapeNew(int body, double radius, double offsetX, double offsetY) => _unsupported();

/// Allocate and initialize a segment shape.
/// @param body The body to attach the shape to.
/// @param ax The x coordinate of the first endpoint.
/// @param ay The y coordinate of the first endpoint.
/// @param bx The x coordinate of the second endpoint.
/// @param by The y coordinate of the second endpoint.
/// @param radius The radius of the segment (for rounded corners).
/// @return A pointer to the new segment shape.
int cpSegmentShapeNew(int body, double ax, double ay, double bx, double by, double radius) => _unsupported();

/// Allocate and initialize a box-shaped polygon.
/// @param body The body to attach the shape to.
/// @param width The width of the box.
/// @param height The height of the box.
/// @param radius The radius of the box (for rounded corners).
/// @return A pointer to the new polygon shape.
int cpPolyShapeNewBox(int body, double width, double height, double radius) => _unsupported();

/// Allocate and initialize a polygon shape.
/// @param body The body to attach the shape to.
/// @param verts A list of vertex coordinates as [x1, y1, x2, y2, ...].
/// @param radius The radius of the polygon (for rounded corners).
/// @return A pointer to the new polygon shape.
int cpPolyShapeNew(int body, List<double> verts, double radius) => _unsupported();

/// Free a shape.
/// @param shape The shape to free.
void cpShapeFree(int shape) => _unsupported();

/// Get the elasticity (bounciness) of a shape.
/// @param shape The shape.
/// @return The elasticity (0.0 = no bounce, 1.0 = perfect bounce).
double cpShapeGetElasticity(int shape) => _unsupported();

/// Set the elasticity (bounciness) of a shape.
/// @param shape The shape.
/// @param elasticity The elasticity (0.0 = no bounce, 1.0 = perfect bounce).
void cpShapeSetElasticity(int shape, double elasticity) => _unsupported();

/// Get the friction coefficient of a shape.
/// @param shape The shape.
/// @return The friction coefficient.
double cpShapeGetFriction(int shape) => _unsupported();

/// Set the friction coefficient of a shape.
/// @param shape The shape.
/// @param friction The friction coefficient.
void cpShapeSetFriction(int shape, double friction) => _unsupported();

/// Get the surface velocity of a shape.
/// @param shape The shape.
/// @return A tuple of (x, y) surface velocity components.
Vector cpShapeGetSurfaceVelocity(int shape) => _unsupported();

/// Set the surface velocity of a shape.
/// @param shape The shape.
/// @param x The x component of the surface velocity.
/// @param y The y component of the surface velocity.
void cpShapeSetSurfaceVelocity(int shape, double x, double y) => _unsupported();

/// Get the collision type of a shape.
/// @param shape The shape.
/// @return The collision type.
int cpShapeGetCollisionType(int shape) => _unsupported();

/// Set the collision type of a shape.
/// @param shape The shape.
/// @param collisionType The collision type.
void cpShapeSetCollisionType(int shape, int collisionType) => _unsupported();

/// Get the collision filter categories of a shape.
/// @param shape The shape.
/// @return The filter categories.
/// Get the collision filter of a shape.
/// @param shape The shape.
/// @return A tuple of (group, categories, mask) filter values.
ShapeFilter cpShapeGetFilter(int shape) => _unsupported();

/// Set the collision filter of a shape.
/// @param shape The shape.
/// @param group The collision group.
/// @param categories The collision categories.
/// @param mask The collision mask.
void cpShapeSetFilter(int shape, int group, int categories, int mask) => _unsupported();

/// Get whether a shape is a sensor (non-colliding trigger).
/// @param shape The shape.
/// @return Non-zero if the shape is a sensor.
int cpShapeGetSensor(int shape) => _unsupported();

/// Set whether a shape is a sensor (non-colliding trigger).
/// @param shape The shape.
/// @param sensor Non-zero to make the shape a sensor.
void cpShapeSetSensor(int shape, int sensor) => _unsupported();

/// Get the body that a shape is attached to.
/// @param shape The shape.
/// @return A pointer to the body.
int cpShapeGetBody(int shape) => _unsupported();

/// Set the body that a shape is attached to.
/// @param shape The shape.
/// @param body The body pointer (0 to detach).
void cpShapeSetBody(int shape, int body) => _unsupported();

/// Get the calculated moment of inertia for a shape.
/// @param shape The shape.
/// @return The moment of inertia.
double cpShapeGetMoment(int shape) => _unsupported();

/// Get the calculated area of a shape.
/// @param shape The shape.
/// @return The area.
double cpShapeGetArea(int shape) => _unsupported();

/// Get the calculated center of gravity of a shape.
/// @param shape The shape.
/// @return A tuple of (x, y) center of gravity coordinates.
Vector cpShapeGetCenterOfGravity(int shape) => _unsupported();

/// Get the axis-aligned bounding box of a shape.
/// @param shape The shape.
/// @return A tuple of (left, bottom, right, top) bounding box coordinates.
BoundingBox cpShapeGetBB(int shape) => _unsupported();

/// Get the mass of a shape.
/// @param shape The shape.
/// @return The mass.
double cpShapeGetMass(int shape) => _unsupported();

/// Set the mass of a shape.
/// @param shape The shape.
/// @param mass The mass.
void cpShapeSetMass(int shape, double mass) => _unsupported();

/// Get the density of a shape.
/// @param shape The shape.
/// @return The density.
double cpShapeGetDensity(int shape) => _unsupported();

/// Set the density of a shape.
/// @param shape The shape.
/// @param density The density.
void cpShapeSetDensity(int shape, double density) => _unsupported();

/// Get the radius of a circle shape.
/// @param shape The circle shape.
/// @return The radius.
double cpCircleShapeGetRadius(int shape) => _unsupported();

/// Get the offset of a circle shape from the body's center of gravity.
/// @param shape The circle shape.
/// @return A tuple of (x, y) offset components.
Vector cpCircleShapeGetOffset(int shape) => _unsupported();

/// Get the first endpoint of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) coordinates of the first endpoint.
Vector cpSegmentShapeGetA(int shape) => _unsupported();

/// Get the second endpoint of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) coordinates of the second endpoint.
Vector cpSegmentShapeGetB(int shape) => _unsupported();

/// Get the radius of a segment shape.
/// @param shape The segment shape.
/// @return The radius.
double cpSegmentShapeGetRadius(int shape) => _unsupported();

/// Get the normal vector of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) normal components.
Vector cpSegmentShapeGetNormal(int shape) => _unsupported();

/// Set the neighbor segments for a segment shape.
/// @param shape The segment shape.
/// @param prevX The x coordinate of the previous segment endpoint.
/// @param prevY The y coordinate of the previous segment endpoint.
/// @param nextX The x coordinate of the next segment endpoint.
/// @param nextY The y coordinate of the next segment endpoint.
void cpSegmentShapeSetNeighbors(int shape, double prevX, double prevY, double nextX, double nextY) => _unsupported();

/// Get the number of vertices in a polygon shape.
/// @param shape The polygon shape.
/// @return The number of vertices.
int cpPolyShapeGetCount(int shape) => _unsupported();

/// Get a vertex of a polygon shape.
/// @param shape The polygon shape.
/// @param index The vertex index.
/// @return A tuple of (x, y) vertex coordinates.
Vector cpPolyShapeGetVert(int shape, int index) => _unsupported();

/// Get the radius of a polygon shape.
/// @param shape The polygon shape.
/// @return The radius.
double cpPolyShapeGetRadius(int shape) => _unsupported();

// ============================================================================
// Constraint Functions
// ============================================================================

/// Free a constraint.
/// @param constraint The constraint to free.
void cpConstraintFree(int constraint) => _unsupported();

/// Get the maximum force that a constraint can apply.
/// @param constraint The constraint.
/// @return The maximum force.
double cpConstraintGetMaxForce(int constraint) => _unsupported();

/// Set the maximum force that a constraint can apply.
/// @param constraint The constraint.
/// @param maxForce The maximum force.
void cpConstraintSetMaxForce(int constraint, double maxForce) => _unsupported();

/// Get the error bias of a constraint.
/// @param constraint The constraint.
/// @return The error bias.
double cpConstraintGetErrorBias(int constraint) => _unsupported();

/// Set the error bias of a constraint.
/// @param constraint The constraint.
/// @param errorBias The error bias.
void cpConstraintSetErrorBias(int constraint, double errorBias) => _unsupported();

/// Get the maximum bias velocity of a constraint.
/// @param constraint The constraint.
/// @return The maximum bias.
double cpConstraintGetMaxBias(int constraint) => _unsupported();

/// Set the maximum bias velocity of a constraint.
/// @param constraint The constraint.
/// @param maxBias The maximum bias.
void cpConstraintSetMaxBias(int constraint, double maxBias) => _unsupported();

/// Get whether the two bodies connected by a constraint can collide.
/// @param constraint The constraint.
/// @return Non-zero if the bodies can collide.
int cpConstraintGetCollideBodies(int constraint) => _unsupported();

/// Set whether the two bodies connected by a constraint can collide.
/// @param constraint The constraint.
/// @param collideBodies Non-zero to allow collisions between the bodies.
void cpConstraintSetCollideBodies(int constraint, int collideBodies) => _unsupported();

/// Get the impulse that the constraint applied this step.
/// @param constraint The constraint.
/// @return The impulse.
double cpConstraintGetImpulse(int constraint) => _unsupported();

/// Get the first body connected by a constraint.
/// @param constraint The constraint.
/// @return A pointer to the first body.
int cpConstraintGetBodyA(int constraint) => _unsupported();

/// Get the second body connected by a constraint.
/// @param constraint The constraint.
/// @return A pointer to the second body.
int cpConstraintGetBodyB(int constraint) => _unsupported();

// Pin Joint
/// Allocate and initialize a pin joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param anchorAx The x coordinate of the anchor point on bodyA.
/// @param anchorAy The y coordinate of the anchor point on bodyA.
/// @param anchorBx The x coordinate of the anchor point on bodyB.
/// @param anchorBy The y coordinate of the anchor point on bodyB.
/// @return A pointer to the new pin joint.
int cpPinJointNew(int bodyA, int bodyB, double anchorAx, double anchorAy, double anchorBx, double anchorBy) =>
    _unsupported();

/// Get the anchor point on bodyA for a pin joint.
/// @param constraint The pin joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPinJointGetAnchorA(int constraint) => _unsupported();

/// Set the anchor point on bodyA for a pin joint.
/// @param constraint The pin joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPinJointSetAnchorA(int constraint, double x, double y) => _unsupported();

/// Get the anchor point on bodyB for a pin joint.
/// @param constraint The pin joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPinJointGetAnchorB(int constraint) => _unsupported();

/// Set the anchor point on bodyB for a pin joint.
/// @param constraint The pin joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPinJointSetAnchorB(int constraint, double x, double y) => _unsupported();

/// Get the distance between the anchor points for a pin joint.
/// @param constraint The pin joint.
/// @return The distance.
double cpPinJointGetDist(int constraint) => _unsupported();

/// Set the distance between the anchor points for a pin joint.
/// @param constraint The pin joint.
/// @param dist The distance.
void cpPinJointSetDist(int constraint, double dist) => _unsupported();

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
) => _unsupported();

/// Get the anchor point on bodyA for a slide joint.
/// @param constraint The slide joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpSlideJointGetAnchorA(int constraint) => _unsupported();

/// Set the anchor point on bodyA for a slide joint.
/// @param constraint The slide joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpSlideJointSetAnchorA(int constraint, double x, double y) => _unsupported();

/// Get the anchor point on bodyB for a slide joint.
/// @param constraint The slide joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpSlideJointGetAnchorB(int constraint) => _unsupported();

/// Set the anchor point on bodyB for a slide joint.
/// @param constraint The slide joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpSlideJointSetAnchorB(int constraint, double x, double y) => _unsupported();

/// Get the minimum distance for a slide joint.
/// @param constraint The slide joint.
/// @return The minimum distance.
double cpSlideJointGetMin(int constraint) => _unsupported();

/// Set the minimum distance for a slide joint.
/// @param constraint The slide joint.
/// @param min The minimum distance.
void cpSlideJointSetMin(int constraint, double min) => _unsupported();

/// Get the maximum distance for a slide joint.
/// @param constraint The slide joint.
/// @return The maximum distance.
double cpSlideJointGetMax(int constraint) => _unsupported();

/// Set the maximum distance for a slide joint.
/// @param constraint The slide joint.
/// @param max The maximum distance.
void cpSlideJointSetMax(int constraint, double max) => _unsupported();

// Pivot Joint
/// Allocate and initialize a pivot joint with a single pivot point.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param pivotX The x coordinate of the pivot point in world space.
/// @param pivotY The y coordinate of the pivot point in world space.
/// @return A pointer to the new pivot joint.
int cpPivotJointNew(int bodyA, int bodyB, double pivotX, double pivotY) => _unsupported();

/// Allocate and initialize a pivot joint with separate anchor points.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param anchorAx The x coordinate of the anchor point on bodyA.
/// @param anchorAy The y coordinate of the anchor point on bodyA.
/// @param anchorBx The x coordinate of the anchor point on bodyB.
/// @param anchorBy The y coordinate of the anchor point on bodyB.
/// @return A pointer to the new pivot joint.
int cpPivotJointNew2(int bodyA, int bodyB, double anchorAx, double anchorAy, double anchorBx, double anchorBy) =>
    _unsupported();

/// Get the anchor point on bodyA for a pivot joint.
/// @param constraint The pivot joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPivotJointGetAnchorA(int constraint) => _unsupported();

/// Set the anchor point on bodyA for a pivot joint.
/// @param constraint The pivot joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPivotJointSetAnchorA(int constraint, double x, double y) => _unsupported();

/// Get the anchor point on bodyB for a pivot joint.
/// @param constraint The pivot joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPivotJointGetAnchorB(int constraint) => _unsupported();

/// Set the anchor point on bodyB for a pivot joint.
/// @param constraint The pivot joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPivotJointSetAnchorB(int constraint, double x, double y) => _unsupported();

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
) => _unsupported();

/// Get the first groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) groove endpoint coordinates.
Vector cpGrooveJointGetGrooveA(int constraint) => _unsupported();

/// Set the first groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the groove endpoint.
/// @param y The y coordinate of the groove endpoint.
void cpGrooveJointSetGrooveA(int constraint, double x, double y) => _unsupported();

/// Get the second groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) groove endpoint coordinates.
Vector cpGrooveJointGetGrooveB(int constraint) => _unsupported();

/// Set the second groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the groove endpoint.
/// @param y The y coordinate of the groove endpoint.
void cpGrooveJointSetGrooveB(int constraint, double x, double y) => _unsupported();

/// Get the anchor point on bodyB for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpGrooveJointGetAnchorB(int constraint) => _unsupported();

/// Set the anchor point on bodyB for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpGrooveJointSetAnchorB(int constraint, double x, double y) => _unsupported();

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
) => _unsupported();

/// Get the anchor point on bodyA for a damped spring.
/// @param constraint The damped spring.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpDampedSpringGetAnchorA(int constraint) => _unsupported();

/// Set the anchor point on bodyA for a damped spring.
/// @param constraint The damped spring.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpDampedSpringSetAnchorA(int constraint, double x, double y) => _unsupported();

/// Get the anchor point on bodyB for a damped spring.
/// @param constraint The damped spring.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpDampedSpringGetAnchorB(int constraint) => _unsupported();

/// Set the anchor point on bodyB for a damped spring.
/// @param constraint The damped spring.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpDampedSpringSetAnchorB(int constraint, double x, double y) => _unsupported();

/// Get the rest length of a damped spring.
/// @param constraint The damped spring.
/// @return The rest length.
double cpDampedSpringGetRestLength(int constraint) => _unsupported();

/// Set the rest length of a damped spring.
/// @param constraint The damped spring.
/// @param restLength The rest length.
void cpDampedSpringSetRestLength(int constraint, double restLength) => _unsupported();

/// Get the stiffness of a damped spring.
/// @param constraint The damped spring.
/// @return The stiffness.
double cpDampedSpringGetStiffness(int constraint) => _unsupported();

/// Set the stiffness of a damped spring.
/// @param constraint The damped spring.
/// @param stiffness The stiffness.
void cpDampedSpringSetStiffness(int constraint, double stiffness) => _unsupported();

/// Get the damping of a damped spring.
/// @param constraint The damped spring.
/// @return The damping.
double cpDampedSpringGetDamping(int constraint) => _unsupported();

/// Set the damping of a damped spring.
/// @param constraint The damped spring.
/// @param damping The damping.
void cpDampedSpringSetDamping(int constraint, double damping) => _unsupported();

// Damped Rotary Spring
/// Allocate and initialize a damped rotary spring constraint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param restAngle The rest angle of the spring in radians.
/// @param stiffness The spring stiffness.
/// @param damping The spring damping.
/// @return A pointer to the new damped rotary spring constraint.
int cpDampedRotarySpringNew(int bodyA, int bodyB, double restAngle, double stiffness, double damping) => _unsupported();

/// Get the rest angle of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The rest angle in radians.
double cpDampedRotarySpringGetRestAngle(int constraint) => _unsupported();

/// Set the rest angle of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param restAngle The rest angle in radians.
void cpDampedRotarySpringSetRestAngle(int constraint, double restAngle) => _unsupported();

/// Get the stiffness of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The stiffness.
double cpDampedRotarySpringGetStiffness(int constraint) => _unsupported();

/// Set the stiffness of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param stiffness The stiffness.
void cpDampedRotarySpringSetStiffness(int constraint, double stiffness) => _unsupported();

/// Get the damping of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The damping.
double cpDampedRotarySpringGetDamping(int constraint) => _unsupported();

/// Set the damping of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param damping The damping.
void cpDampedRotarySpringSetDamping(int constraint, double damping) => _unsupported();

// Rotary Limit Joint
/// Allocate and initialize a rotary limit joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param min The minimum angle in radians.
/// @param max The maximum angle in radians.
/// @return A pointer to the new rotary limit joint.
int cpRotaryLimitJointNew(int bodyA, int bodyB, double min, double max) => _unsupported();

/// Get the minimum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @return The minimum angle in radians.
double cpRotaryLimitJointGetMin(int constraint) => _unsupported();

/// Set the minimum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @param min The minimum angle in radians.
void cpRotaryLimitJointSetMin(int constraint, double min) => _unsupported();

/// Get the maximum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @return The maximum angle in radians.
double cpRotaryLimitJointGetMax(int constraint) => _unsupported();

/// Set the maximum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @param max The maximum angle in radians.
void cpRotaryLimitJointSetMax(int constraint, double max) => _unsupported();

// Ratchet Joint
/// Allocate and initialize a ratchet joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param phase The phase offset in radians.
/// @param ratchet The ratchet angle in radians.
/// @return A pointer to the new ratchet joint.
int cpRatchetJointNew(int bodyA, int bodyB, double phase, double ratchet) => _unsupported();

/// Get the current angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The current angle in radians.
double cpRatchetJointGetAngle(int constraint) => _unsupported();

/// Set the current angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param angle The current angle in radians.
void cpRatchetJointSetAngle(int constraint, double angle) => _unsupported();

/// Get the phase offset for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The phase offset in radians.
double cpRatchetJointGetPhase(int constraint) => _unsupported();

/// Set the phase offset for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param phase The phase offset in radians.
void cpRatchetJointSetPhase(int constraint, double phase) => _unsupported();

/// Get the ratchet angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The ratchet angle in radians.
double cpRatchetJointGetRatchet(int constraint) => _unsupported();

/// Set the ratchet angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param ratchet The ratchet angle in radians.
void cpRatchetJointSetRatchet(int constraint, double ratchet) => _unsupported();

// Gear Joint
/// Allocate and initialize a gear joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param phase The phase offset in radians.
/// @param ratio The gear ratio.
/// @return A pointer to the new gear joint.
int cpGearJointNew(int bodyA, int bodyB, double phase, double ratio) => _unsupported();

/// Get the phase offset for a gear joint.
/// @param constraint The gear joint.
/// @return The phase offset in radians.
double cpGearJointGetPhase(int constraint) => _unsupported();

/// Set the phase offset for a gear joint.
/// @param constraint The gear joint.
/// @param phase The phase offset in radians.
void cpGearJointSetPhase(int constraint, double phase) => _unsupported();

/// Get the gear ratio for a gear joint.
/// @param constraint The gear joint.
/// @return The gear ratio.
double cpGearJointGetRatio(int constraint) => _unsupported();

/// Set the gear ratio for a gear joint.
/// @param constraint The gear joint.
/// @param ratio The gear ratio.
void cpGearJointSetRatio(int constraint, double ratio) => _unsupported();

// Simple Motor
/// Allocate and initialize a simple motor constraint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param rate The rate of rotation in radians per second.
/// @return A pointer to the new simple motor constraint.
int cpSimpleMotorNew(int bodyA, int bodyB, double rate) => _unsupported();

/// Get the rate of rotation for a simple motor.
/// @param constraint The simple motor.
/// @return The rate of rotation in radians per second.
double cpSimpleMotorGetRate(int constraint) => _unsupported();

/// Set the rate of rotation for a simple motor.
/// @param constraint The simple motor.
/// @param rate The rate of rotation in radians per second.
void cpSimpleMotorSetRate(int constraint, double rate) => _unsupported();

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
double cpMomentForCircle(double mass, double r1, double r2, double offsetX, double offsetY) => _unsupported();

/// Calculate the moment of inertia for a line segment.
/// @param mass The mass of the segment.
/// @param ax The x coordinate of the first endpoint.
/// @param ay The y coordinate of the first endpoint.
/// @param bx The x coordinate of the second endpoint.
/// @param by The y coordinate of the second endpoint.
/// @param radius The radius of the segment (for rounded corners).
/// @return The moment of inertia.
double cpMomentForSegment(double mass, double ax, double ay, double bx, double by, double radius) => _unsupported();

/// Calculate the moment of inertia for a solid box.
/// @param mass The mass of the box.
/// @param width The width of the box.
/// @param height The height of the box.
/// @return The moment of inertia.
double cpMomentForBox(double mass, double width, double height) => _unsupported();

/// Calculate the area of a hollow circle.
/// @param r1 The inner radius (0 for solid circles).
/// @param r2 The outer radius.
/// @return The area.
double cpAreaForCircle(double r1, double r2) => _unsupported();

/// Calculate the area of a fattened (capsule shaped) line segment.
/// @param ax The x coordinate of the first endpoint.
/// @param ay The y coordinate of the first endpoint.
/// @param bx The x coordinate of the second endpoint.
/// @param by The y coordinate of the second endpoint.
/// @param radius The radius of the segment.
/// @return The area.
double cpAreaForSegment(double ax, double ay, double bx, double by, double radius) => _unsupported();

/// Calculate the signed area of a polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @param radius The radius (for rounded corners).
/// @return The signed area (clockwise winding gives positive area).
double cpAreaForPoly(List<double> verts, double radius) => _unsupported();

/// Calculate the centroid of a polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @return A tuple of (x, y) centroid coordinates.
Vector cpCentroidForPoly(List<double> verts) => _unsupported();

/// Calculate the moment of inertia for a box defined by a bounding box.
/// @param mass The mass of the box.
/// @param left The left edge of the bounding box.
/// @param bottom The bottom edge of the bounding box.
/// @param right The right edge of the bounding box.
/// @param top The top edge of the bounding box.
/// @return The moment of inertia.
double cpMomentForBox2(double mass, double left, double bottom, double right, double top) => _unsupported();

/// Calculate the convex hull of a set of points.
/// @param points The flattened list of points [x1, y1, x2, y2, ...].
/// @param tolerance The tolerance for the convex hull calculation.
/// @return A flattened list of hull vertices [x1, y1, x2, y2, ...].
List<double> cpConvexHull(List<double> points, {double tolerance = 0.0}) => _unsupported();

/// Calculate the moment of inertia for a polygon.
/// @param mass The mass of the polygon.
/// @param verts A list of vertex coordinates as [x1, y1, x2, y2, ...].
/// @param offsetX The x offset of the center of gravity.
/// @param offsetY The y offset of the center of gravity.
/// @param radius The radius of the polygon (for rounded corners).
/// @return The moment of inertia.
double cpMomentForPoly(double mass, List<double> verts, double offsetX, double offsetY, double radius) =>
    _unsupported();
