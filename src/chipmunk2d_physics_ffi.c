#include "chipmunk2d_physics_ffi.h"

// Space management
FFI_PLUGIN_EXPORT cpSpace* cp_space_new(void) {
    return cpSpaceNew();
}

FFI_PLUGIN_EXPORT void cp_space_free(cpSpace* space) {
    cpSpaceFree(space);
}

FFI_PLUGIN_EXPORT void cp_space_step(cpSpace* space, cpFloat dt) {
    cpSpaceStep(space, dt);
}

FFI_PLUGIN_EXPORT void cp_space_set_gravity(cpSpace* space, cpVect gravity) {
    cpSpaceSetGravity(space, gravity);
}

FFI_PLUGIN_EXPORT cpVect cp_space_get_gravity(cpSpace* space) {
    return cpSpaceGetGravity(space);
}

FFI_PLUGIN_EXPORT void cp_space_set_iterations(cpSpace* space, int iterations) {
    cpSpaceSetIterations(space, iterations);
}

FFI_PLUGIN_EXPORT void cp_space_set_collision_slop(cpSpace* space, cpFloat collisionSlop) {
    cpSpaceSetCollisionSlop(space, collisionSlop);
}

FFI_PLUGIN_EXPORT void cp_space_set_damping(cpSpace* space, cpFloat damping) {
    cpSpaceSetDamping(space, damping);
}

FFI_PLUGIN_EXPORT void cp_space_set_idle_speed_threshold(cpSpace* space, cpFloat idleSpeedThreshold) {
    cpSpaceSetIdleSpeedThreshold(space, idleSpeedThreshold);
}

FFI_PLUGIN_EXPORT void cp_space_set_sleep_time_threshold(cpSpace* space, cpFloat sleepTimeThreshold) {
    cpSpaceSetSleepTimeThreshold(space, sleepTimeThreshold);
}

FFI_PLUGIN_EXPORT void cp_space_set_collision_bias(cpSpace* space, cpFloat collisionBias) {
    cpSpaceSetCollisionBias(space, collisionBias);
}

FFI_PLUGIN_EXPORT void cp_space_set_collision_persistence(cpSpace* space, unsigned int collisionPersistence) {
    cpSpaceSetCollisionPersistence(space, collisionPersistence);
}

FFI_PLUGIN_EXPORT void cp_space_reindex_static(cpSpace* space) {
    cpSpaceReindexStatic(space);
}

FFI_PLUGIN_EXPORT void cp_space_reindex_shape(cpSpace* space, cpShape* shape) {
    cpSpaceReindexShape(space, shape);
}

FFI_PLUGIN_EXPORT void cp_space_reindex_shapes_for_body(cpSpace* space, cpBody* body) {
    cpSpaceReindexShapesForBody(space, body);
}

FFI_PLUGIN_EXPORT cpBody* cp_space_get_static_body(cpSpace* space) {
    return cpSpaceGetStaticBody(space);
}

FFI_PLUGIN_EXPORT int cp_space_get_iterations(cpSpace* space) {
    return cpSpaceGetIterations(space);
}

FFI_PLUGIN_EXPORT cpFloat cp_space_get_damping(cpSpace* space) {
    return cpSpaceGetDamping(space);
}

FFI_PLUGIN_EXPORT cpFloat cp_space_get_idle_speed_threshold(cpSpace* space) {
    return cpSpaceGetIdleSpeedThreshold(space);
}

FFI_PLUGIN_EXPORT cpFloat cp_space_get_sleep_time_threshold(cpSpace* space) {
    return cpSpaceGetSleepTimeThreshold(space);
}

FFI_PLUGIN_EXPORT cpFloat cp_space_get_collision_slop(cpSpace* space) {
    return cpSpaceGetCollisionSlop(space);
}

FFI_PLUGIN_EXPORT cpFloat cp_space_get_collision_bias(cpSpace* space) {
    return cpSpaceGetCollisionBias(space);
}

FFI_PLUGIN_EXPORT unsigned int cp_space_get_collision_persistence(cpSpace* space) {
    return cpSpaceGetCollisionPersistence(space);
}

FFI_PLUGIN_EXPORT cpFloat cp_space_get_current_time_step(cpSpace* space) {
    return cpSpaceGetCurrentTimeStep(space);
}

FFI_PLUGIN_EXPORT int cp_space_is_locked(cpSpace* space) {
    return cpSpaceIsLocked(space) ? 1 : 0;
}

FFI_PLUGIN_EXPORT int cp_space_contains_body(cpSpace* space, cpBody* body) {
    return cpSpaceContainsBody(space, body) ? 1 : 0;
}

FFI_PLUGIN_EXPORT int cp_space_contains_shape(cpSpace* space, cpShape* shape) {
    return cpSpaceContainsShape(space, shape) ? 1 : 0;
}

FFI_PLUGIN_EXPORT int cp_space_contains_constraint(cpSpace* space, cpConstraint* constraint) {
    return cpSpaceContainsConstraint(space, constraint) ? 1 : 0;
}

FFI_PLUGIN_EXPORT void cp_space_add_constraint(cpSpace* space, cpConstraint* constraint) {
    cpSpaceAddConstraint(space, constraint);
}

FFI_PLUGIN_EXPORT void cp_space_remove_constraint(cpSpace* space, cpConstraint* constraint) {
    cpSpaceRemoveConstraint(space, constraint);
}

FFI_PLUGIN_EXPORT cpShape* cp_space_segment_query_first(cpSpace* space, cpVect start, cpVect end, cpFloat radius, cpShapeFilter filter, cpSegmentQueryInfo* out) {
    return cpSpaceSegmentQueryFirst(space, start, end, radius, filter, out);
}

FFI_PLUGIN_EXPORT int cp_space_shape_query(cpSpace* space, cpShape* shape, void* func, void* data) {
    // Note: Callback-based queries are not fully supported via FFI
    // This is a placeholder - full implementation would require callback marshalling
    return cpSpaceShapeQuery(space, shape, NULL, data) ? 1 : 0;
}

// Body management
FFI_PLUGIN_EXPORT cpBody* cp_body_new(cpFloat mass, cpFloat moment) {
    return cpBodyNew(mass, moment);
}

FFI_PLUGIN_EXPORT cpBody* cp_body_new_kinematic(void) {
    return cpBodyNewKinematic();
}

FFI_PLUGIN_EXPORT cpBody* cp_body_new_static(void) {
    return cpBodyNewStatic();
}

FFI_PLUGIN_EXPORT void cp_body_free(cpBody* body) {
    cpBodyFree(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_position(cpBody* body, cpVect pos) {
    cpBodySetPosition(body, pos);
}

FFI_PLUGIN_EXPORT cpVect cp_body_get_position(cpBody* body) {
    return cpBodyGetPosition(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_velocity(cpBody* body, cpVect velocity) {
    cpBodySetVelocity(body, velocity);
}

FFI_PLUGIN_EXPORT cpVect cp_body_get_velocity(cpBody* body) {
    return cpBodyGetVelocity(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_angle(cpBody* body, cpFloat angle) {
    cpBodySetAngle(body, angle);
}

FFI_PLUGIN_EXPORT cpFloat cp_body_get_angle(cpBody* body) {
    return cpBodyGetAngle(body);
}

FFI_PLUGIN_EXPORT cpFloat cp_body_get_mass(cpBody* body) {
    return cpBodyGetMass(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_mass(cpBody* body, cpFloat mass) {
    cpBodySetMass(body, mass);
}

FFI_PLUGIN_EXPORT cpFloat cp_body_get_moment(cpBody* body) {
    return cpBodyGetMoment(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_moment(cpBody* body, cpFloat moment) {
    cpBodySetMoment(body, moment);
}

FFI_PLUGIN_EXPORT cpVect cp_body_get_center_of_gravity(cpBody* body) {
    return cpBodyGetCenterOfGravity(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_center_of_gravity(cpBody* body, cpVect cog) {
    cpBodySetCenterOfGravity(body, cog);
}

FFI_PLUGIN_EXPORT cpVect cp_body_get_force(cpBody* body) {
    return cpBodyGetForce(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_force(cpBody* body, cpVect force) {
    cpBodySetForce(body, force);
}

FFI_PLUGIN_EXPORT cpFloat cp_body_get_angular_velocity(cpBody* body) {
    return cpBodyGetAngularVelocity(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_angular_velocity(cpBody* body, cpFloat angularVelocity) {
    cpBodySetAngularVelocity(body, angularVelocity);
}

FFI_PLUGIN_EXPORT cpFloat cp_body_get_torque(cpBody* body) {
    return cpBodyGetTorque(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_torque(cpBody* body, cpFloat torque) {
    cpBodySetTorque(body, torque);
}

FFI_PLUGIN_EXPORT cpVect cp_body_get_rotation(cpBody* body) {
    return cpBodyGetRotation(body);
}

FFI_PLUGIN_EXPORT int cp_body_get_type(cpBody* body) {
    return (int)cpBodyGetType(body);
}

FFI_PLUGIN_EXPORT void cp_body_set_type(cpBody* body, int type) {
    cpBodySetType(body, (cpBodyType)type);
}

FFI_PLUGIN_EXPORT int cp_body_is_sleeping(cpBody* body) {
    return cpBodyIsSleeping(body) ? 1 : 0;
}

FFI_PLUGIN_EXPORT void cp_body_activate(cpBody* body) {
    cpBodyActivate(body);
}

FFI_PLUGIN_EXPORT void cp_body_activate_static(cpBody* body, cpShape* filter) {
    cpBodyActivateStatic(body, filter);
}

FFI_PLUGIN_EXPORT void cp_body_sleep(cpBody* body) {
    cpBodySleep(body);
}

FFI_PLUGIN_EXPORT void cp_body_sleep_with_group(cpBody* body, cpBody* group) {
    cpBodySleepWithGroup(body, group);
}

FFI_PLUGIN_EXPORT cpVect cp_body_local_to_world(cpBody* body, cpVect point) {
    return cpBodyLocalToWorld(body, point);
}

FFI_PLUGIN_EXPORT cpVect cp_body_world_to_local(cpBody* body, cpVect point) {
    return cpBodyWorldToLocal(body, point);
}

FFI_PLUGIN_EXPORT void cp_body_apply_force_at_world_point(cpBody* body, cpVect force, cpVect point) {
    cpBodyApplyForceAtWorldPoint(body, force, point);
}

FFI_PLUGIN_EXPORT void cp_body_apply_force_at_local_point(cpBody* body, cpVect force, cpVect point) {
    cpBodyApplyForceAtLocalPoint(body, force, point);
}

FFI_PLUGIN_EXPORT void cp_body_apply_impulse_at_world_point(cpBody* body, cpVect impulse, cpVect point) {
    cpBodyApplyImpulseAtWorldPoint(body, impulse, point);
}

FFI_PLUGIN_EXPORT void cp_body_apply_impulse_at_local_point(cpBody* body, cpVect impulse, cpVect point) {
    cpBodyApplyImpulseAtLocalPoint(body, impulse, point);
}

FFI_PLUGIN_EXPORT cpVect cp_body_get_velocity_at_world_point(cpBody* body, cpVect point) {
    return cpBodyGetVelocityAtWorldPoint(body, point);
}

FFI_PLUGIN_EXPORT cpVect cp_body_get_velocity_at_local_point(cpBody* body, cpVect point) {
    return cpBodyGetVelocityAtLocalPoint(body, point);
}

FFI_PLUGIN_EXPORT cpFloat cp_body_kinetic_energy(cpBody* body) {
    return cpBodyKineticEnergy(body);
}

FFI_PLUGIN_EXPORT cpSpace* cp_body_get_space(cpBody* body) {
    return cpBodyGetSpace(body);
}

// Shape management
FFI_PLUGIN_EXPORT cpShape* cp_circle_shape_new(cpBody* body, cpFloat radius, cpVect offset) {
    return cpCircleShapeNew(body, radius, offset);
}

FFI_PLUGIN_EXPORT cpShape* cp_box_shape_new(cpBody* body, cpFloat width, cpFloat height, cpFloat radius) {
    return cpBoxShapeNew(body, width, height, radius);
}

FFI_PLUGIN_EXPORT cpShape* cp_segment_shape_new(cpBody* body, cpVect a, cpVect b, cpFloat radius) {
    return cpSegmentShapeNew(body, a, b, radius);
}

FFI_PLUGIN_EXPORT void cp_shape_free(cpShape* shape) {
    cpShapeFree(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_friction(cpShape* shape, cpFloat friction) {
    cpShapeSetFriction(shape, friction);
}

FFI_PLUGIN_EXPORT cpFloat cp_shape_get_friction(cpShape* shape) {
    return cpShapeGetFriction(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_elasticity(cpShape* shape, cpFloat elasticity) {
    cpShapeSetElasticity(shape, elasticity);
}

FFI_PLUGIN_EXPORT cpFloat cp_shape_get_elasticity(cpShape* shape) {
    return cpShapeGetElasticity(shape);
}

FFI_PLUGIN_EXPORT cpShapeFilter cp_shape_get_filter(cpShape* shape) {
    return cpShapeGetFilter(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_filter(cpShape* shape, cpShapeFilter filter) {
    cpShapeSetFilter(shape, filter);
}

FFI_PLUGIN_EXPORT cpShapeFilter cp_shape_filter_new(cpGroup group, cpBitmask categories, cpBitmask mask) {
    return cpShapeFilterNew(group, categories, mask);
}

FFI_PLUGIN_EXPORT cpShape* cp_poly_shape_new(cpBody* body, int count, cpVect* verts, cpTransform transform, cpFloat radius) {
    return cpPolyShapeNew(body, count, verts, transform, radius);
}

FFI_PLUGIN_EXPORT cpShape* cp_poly_shape_new_raw(cpBody* body, int count, cpVect* verts, cpFloat radius) {
    return cpPolyShapeNewRaw(body, count, verts, radius);
}

FFI_PLUGIN_EXPORT cpShape* cp_box_shape_new2(cpBody* body, cpBB box, cpFloat radius) {
    return cpBoxShapeNew2(body, box, radius);
}

FFI_PLUGIN_EXPORT cpFloat cp_shape_get_mass(cpShape* shape) {
    return cpShapeGetMass(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_mass(cpShape* shape, cpFloat mass) {
    cpShapeSetMass(shape, mass);
}

FFI_PLUGIN_EXPORT cpFloat cp_shape_get_density(cpShape* shape) {
    return cpShapeGetDensity(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_density(cpShape* shape, cpFloat density) {
    cpShapeSetDensity(shape, density);
}

FFI_PLUGIN_EXPORT cpFloat cp_shape_get_moment(cpShape* shape) {
    return cpShapeGetMoment(shape);
}

FFI_PLUGIN_EXPORT cpFloat cp_shape_get_area(cpShape* shape) {
    return cpShapeGetArea(shape);
}

FFI_PLUGIN_EXPORT cpVect cp_shape_get_center_of_gravity(cpShape* shape) {
    return cpShapeGetCenterOfGravity(shape);
}

FFI_PLUGIN_EXPORT cpBB cp_shape_get_bb(cpShape* shape) {
    return cpShapeGetBB(shape);
}

FFI_PLUGIN_EXPORT int cp_shape_get_sensor(cpShape* shape) {
    return cpShapeGetSensor(shape) ? 1 : 0;
}

FFI_PLUGIN_EXPORT void cp_shape_set_sensor(cpShape* shape, int sensor) {
    cpShapeSetSensor(shape, sensor ? cpTrue : cpFalse);
}

FFI_PLUGIN_EXPORT cpVect cp_shape_get_surface_velocity(cpShape* shape) {
    return cpShapeGetSurfaceVelocity(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_surface_velocity(cpShape* shape, cpVect surfaceVelocity) {
    cpShapeSetSurfaceVelocity(shape, surfaceVelocity);
}

FFI_PLUGIN_EXPORT uintptr_t cp_shape_get_collision_type(cpShape* shape) {
    return (uintptr_t)cpShapeGetCollisionType(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_collision_type(cpShape* shape, uintptr_t collisionType) {
    cpShapeSetCollisionType(shape, (cpCollisionType)collisionType);
}

FFI_PLUGIN_EXPORT cpBody* cp_shape_get_body(cpShape* shape) {
    return cpShapeGetBody(shape);
}

FFI_PLUGIN_EXPORT void cp_shape_set_body(cpShape* shape, cpBody* body) {
    cpShapeSetBody(shape, body);
}

FFI_PLUGIN_EXPORT cpSpace* cp_shape_get_space(cpShape* shape) {
    return cpShapeGetSpace(shape);
}

FFI_PLUGIN_EXPORT cpFloat cp_shape_point_query(cpShape* shape, cpVect p, cpPointQueryInfo* out) {
    return cpShapePointQuery(shape, p, out);
}

FFI_PLUGIN_EXPORT int cp_shape_segment_query(cpShape* shape, cpVect a, cpVect b, cpFloat radius, cpSegmentQueryInfo* info) {
    return cpShapeSegmentQuery(shape, a, b, radius, info) ? 1 : 0;
}

FFI_PLUGIN_EXPORT cpContactPointSet cp_shapes_collide(cpShape* a, cpShape* b) {
    return cpShapesCollide(a, b);
}

FFI_PLUGIN_EXPORT cpVect cp_circle_shape_get_offset(cpShape* shape) {
    return cpCircleShapeGetOffset(shape);
}

FFI_PLUGIN_EXPORT cpFloat cp_circle_shape_get_radius(cpShape* shape) {
    return cpCircleShapeGetRadius(shape);
}

FFI_PLUGIN_EXPORT cpVect cp_segment_shape_get_a(cpShape* shape) {
    return cpSegmentShapeGetA(shape);
}

FFI_PLUGIN_EXPORT cpVect cp_segment_shape_get_b(cpShape* shape) {
    return cpSegmentShapeGetB(shape);
}

FFI_PLUGIN_EXPORT cpVect cp_segment_shape_get_normal(cpShape* shape) {
    return cpSegmentShapeGetNormal(shape);
}

FFI_PLUGIN_EXPORT cpFloat cp_segment_shape_get_radius(cpShape* shape) {
    return cpSegmentShapeGetRadius(shape);
}

FFI_PLUGIN_EXPORT void cp_segment_shape_set_neighbors(cpShape* shape, cpVect prev, cpVect next) {
    cpSegmentShapeSetNeighbors(shape, prev, next);
}

FFI_PLUGIN_EXPORT int cp_poly_shape_get_count(cpShape* shape) {
    return cpPolyShapeGetCount(shape);
}

FFI_PLUGIN_EXPORT cpVect cp_poly_shape_get_vert(cpShape* shape, int index) {
    return cpPolyShapeGetVert(shape, index);
}

FFI_PLUGIN_EXPORT cpFloat cp_poly_shape_get_radius(cpShape* shape) {
    return cpPolyShapeGetRadius(shape);
}

// Space-Body-Shape relationships
FFI_PLUGIN_EXPORT void cp_space_add_body(cpSpace* space, cpBody* body) {
    cpSpaceAddBody(space, body);
}

FFI_PLUGIN_EXPORT void cp_space_remove_body(cpSpace* space, cpBody* body) {
    cpSpaceRemoveBody(space, body);
}

FFI_PLUGIN_EXPORT void cp_space_add_shape(cpSpace* space, cpShape* shape) {
    cpSpaceAddShape(space, shape);
}

FFI_PLUGIN_EXPORT void cp_space_remove_shape(cpSpace* space, cpShape* shape) {
    cpSpaceRemoveShape(space, shape);
}

// Vector utilities
FFI_PLUGIN_EXPORT cpVect cp_vect_new(cpFloat x, cpFloat y) {
    return cpv(x, y);
}

FFI_PLUGIN_EXPORT cpFloat cp_vect_get_x(cpVect v) {
    return v.x;
}

FFI_PLUGIN_EXPORT cpFloat cp_vect_get_y(cpVect v) {
    return v.y;
}

// Collision detection
FFI_PLUGIN_EXPORT cpShape* cp_space_point_query_nearest(cpSpace* space, cpVect point, cpFloat maxDistance, cpShapeFilter filter, cpPointQueryInfo* out) {
    return cpSpacePointQueryNearest(space, point, maxDistance, filter, out);
}

// Constraint management
FFI_PLUGIN_EXPORT void cp_constraint_free(cpConstraint* constraint) {
    cpConstraintFree(constraint);
}

FFI_PLUGIN_EXPORT cpSpace* cp_constraint_get_space(cpConstraint* constraint) {
    return cpConstraintGetSpace(constraint);
}

FFI_PLUGIN_EXPORT cpBody* cp_constraint_get_body_a(cpConstraint* constraint) {
    return cpConstraintGetBodyA(constraint);
}

FFI_PLUGIN_EXPORT cpBody* cp_constraint_get_body_b(cpConstraint* constraint) {
    return cpConstraintGetBodyB(constraint);
}

FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_max_force(cpConstraint* constraint) {
    return cpConstraintGetMaxForce(constraint);
}

FFI_PLUGIN_EXPORT void cp_constraint_set_max_force(cpConstraint* constraint, cpFloat maxForce) {
    cpConstraintSetMaxForce(constraint, maxForce);
}

FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_error_bias(cpConstraint* constraint) {
    return cpConstraintGetErrorBias(constraint);
}

FFI_PLUGIN_EXPORT void cp_constraint_set_error_bias(cpConstraint* constraint, cpFloat errorBias) {
    cpConstraintSetErrorBias(constraint, errorBias);
}

FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_max_bias(cpConstraint* constraint) {
    return cpConstraintGetMaxBias(constraint);
}

FFI_PLUGIN_EXPORT void cp_constraint_set_max_bias(cpConstraint* constraint, cpFloat maxBias) {
    cpConstraintSetMaxBias(constraint, maxBias);
}

FFI_PLUGIN_EXPORT int cp_constraint_get_collide_bodies(cpConstraint* constraint) {
    return cpConstraintGetCollideBodies(constraint) ? 1 : 0;
}

FFI_PLUGIN_EXPORT void cp_constraint_set_collide_bodies(cpConstraint* constraint, int collideBodies) {
    cpConstraintSetCollideBodies(constraint, collideBodies ? cpTrue : cpFalse);
}

FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_impulse(cpConstraint* constraint) {
    return cpConstraintGetImpulse(constraint);
}

// Pin joint
FFI_PLUGIN_EXPORT cpConstraint* cp_pin_joint_new(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB) {
    return cpPinJointNew(a, b, anchorA, anchorB);
}

FFI_PLUGIN_EXPORT cpVect cp_pin_joint_get_anchor_a(cpConstraint* constraint) {
    return cpPinJointGetAnchorA(constraint);
}

FFI_PLUGIN_EXPORT void cp_pin_joint_set_anchor_a(cpConstraint* constraint, cpVect anchorA) {
    cpPinJointSetAnchorA(constraint, anchorA);
}

FFI_PLUGIN_EXPORT cpVect cp_pin_joint_get_anchor_b(cpConstraint* constraint) {
    return cpPinJointGetAnchorB(constraint);
}

FFI_PLUGIN_EXPORT void cp_pin_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB) {
    cpPinJointSetAnchorB(constraint, anchorB);
}

FFI_PLUGIN_EXPORT cpFloat cp_pin_joint_get_dist(cpConstraint* constraint) {
    return cpPinJointGetDist(constraint);
}

FFI_PLUGIN_EXPORT void cp_pin_joint_set_dist(cpConstraint* constraint, cpFloat dist) {
    cpPinJointSetDist(constraint, dist);
}

// Slide joint
FFI_PLUGIN_EXPORT cpConstraint* cp_slide_joint_new(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB, cpFloat min, cpFloat max) {
    return cpSlideJointNew(a, b, anchorA, anchorB, min, max);
}

FFI_PLUGIN_EXPORT cpVect cp_slide_joint_get_anchor_a(cpConstraint* constraint) {
    return cpSlideJointGetAnchorA(constraint);
}

FFI_PLUGIN_EXPORT void cp_slide_joint_set_anchor_a(cpConstraint* constraint, cpVect anchorA) {
    cpSlideJointSetAnchorA(constraint, anchorA);
}

FFI_PLUGIN_EXPORT cpVect cp_slide_joint_get_anchor_b(cpConstraint* constraint) {
    return cpSlideJointGetAnchorB(constraint);
}

FFI_PLUGIN_EXPORT void cp_slide_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB) {
    cpSlideJointSetAnchorB(constraint, anchorB);
}

FFI_PLUGIN_EXPORT cpFloat cp_slide_joint_get_min(cpConstraint* constraint) {
    return cpSlideJointGetMin(constraint);
}

FFI_PLUGIN_EXPORT void cp_slide_joint_set_min(cpConstraint* constraint, cpFloat min) {
    cpSlideJointSetMin(constraint, min);
}

FFI_PLUGIN_EXPORT cpFloat cp_slide_joint_get_max(cpConstraint* constraint) {
    return cpSlideJointGetMax(constraint);
}

FFI_PLUGIN_EXPORT void cp_slide_joint_set_max(cpConstraint* constraint, cpFloat max) {
    cpSlideJointSetMax(constraint, max);
}

// Pivot joint
FFI_PLUGIN_EXPORT cpConstraint* cp_pivot_joint_new(cpBody* a, cpBody* b, cpVect pivot) {
    return cpPivotJointNew(a, b, pivot);
}

FFI_PLUGIN_EXPORT cpConstraint* cp_pivot_joint_new2(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB) {
    return cpPivotJointNew2(a, b, anchorA, anchorB);
}

FFI_PLUGIN_EXPORT cpVect cp_pivot_joint_get_anchor_a(cpConstraint* constraint) {
    return cpPivotJointGetAnchorA(constraint);
}

FFI_PLUGIN_EXPORT void cp_pivot_joint_set_anchor_a(cpConstraint* constraint, cpVect anchorA) {
    cpPivotJointSetAnchorA(constraint, anchorA);
}

FFI_PLUGIN_EXPORT cpVect cp_pivot_joint_get_anchor_b(cpConstraint* constraint) {
    return cpPivotJointGetAnchorB(constraint);
}

FFI_PLUGIN_EXPORT void cp_pivot_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB) {
    cpPivotJointSetAnchorB(constraint, anchorB);
}

// Groove joint
FFI_PLUGIN_EXPORT cpConstraint* cp_groove_joint_new(cpBody* a, cpBody* b, cpVect groove_a, cpVect groove_b, cpVect anchorB) {
    return cpGrooveJointNew(a, b, groove_a, groove_b, anchorB);
}

FFI_PLUGIN_EXPORT cpVect cp_groove_joint_get_groove_a(cpConstraint* constraint) {
    return cpGrooveJointGetGrooveA(constraint);
}

FFI_PLUGIN_EXPORT void cp_groove_joint_set_groove_a(cpConstraint* constraint, cpVect grooveA) {
    cpGrooveJointSetGrooveA(constraint, grooveA);
}

FFI_PLUGIN_EXPORT cpVect cp_groove_joint_get_groove_b(cpConstraint* constraint) {
    return cpGrooveJointGetGrooveB(constraint);
}

FFI_PLUGIN_EXPORT void cp_groove_joint_set_groove_b(cpConstraint* constraint, cpVect grooveB) {
    cpGrooveJointSetGrooveB(constraint, grooveB);
}

FFI_PLUGIN_EXPORT cpVect cp_groove_joint_get_anchor_b(cpConstraint* constraint) {
    return cpGrooveJointGetAnchorB(constraint);
}

FFI_PLUGIN_EXPORT void cp_groove_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB) {
    cpGrooveJointSetAnchorB(constraint, anchorB);
}

// Damped spring
FFI_PLUGIN_EXPORT cpConstraint* cp_damped_spring_new(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB, cpFloat restLength, cpFloat stiffness, cpFloat damping) {
    return cpDampedSpringNew(a, b, anchorA, anchorB, restLength, stiffness, damping);
}

FFI_PLUGIN_EXPORT cpVect cp_damped_spring_get_anchor_a(cpConstraint* constraint) {
    return cpDampedSpringGetAnchorA(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_spring_set_anchor_a(cpConstraint* constraint, cpVect anchorA) {
    cpDampedSpringSetAnchorA(constraint, anchorA);
}

FFI_PLUGIN_EXPORT cpVect cp_damped_spring_get_anchor_b(cpConstraint* constraint) {
    return cpDampedSpringGetAnchorB(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_spring_set_anchor_b(cpConstraint* constraint, cpVect anchorB) {
    cpDampedSpringSetAnchorB(constraint, anchorB);
}

FFI_PLUGIN_EXPORT cpFloat cp_damped_spring_get_rest_length(cpConstraint* constraint) {
    return cpDampedSpringGetRestLength(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_spring_set_rest_length(cpConstraint* constraint, cpFloat restLength) {
    cpDampedSpringSetRestLength(constraint, restLength);
}

FFI_PLUGIN_EXPORT cpFloat cp_damped_spring_get_stiffness(cpConstraint* constraint) {
    return cpDampedSpringGetStiffness(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_spring_set_stiffness(cpConstraint* constraint, cpFloat stiffness) {
    cpDampedSpringSetStiffness(constraint, stiffness);
}

FFI_PLUGIN_EXPORT cpFloat cp_damped_spring_get_damping(cpConstraint* constraint) {
    return cpDampedSpringGetDamping(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_spring_set_damping(cpConstraint* constraint, cpFloat damping) {
    cpDampedSpringSetDamping(constraint, damping);
}

// Damped rotary spring
FFI_PLUGIN_EXPORT cpConstraint* cp_damped_rotary_spring_new(cpBody* a, cpBody* b, cpFloat restAngle, cpFloat stiffness, cpFloat damping) {
    return cpDampedRotarySpringNew(a, b, restAngle, stiffness, damping);
}

FFI_PLUGIN_EXPORT cpFloat cp_damped_rotary_spring_get_rest_angle(cpConstraint* constraint) {
    return cpDampedRotarySpringGetRestAngle(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_rotary_spring_set_rest_angle(cpConstraint* constraint, cpFloat restAngle) {
    cpDampedRotarySpringSetRestAngle(constraint, restAngle);
}

FFI_PLUGIN_EXPORT cpFloat cp_damped_rotary_spring_get_stiffness(cpConstraint* constraint) {
    return cpDampedRotarySpringGetStiffness(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_rotary_spring_set_stiffness(cpConstraint* constraint, cpFloat stiffness) {
    cpDampedRotarySpringSetStiffness(constraint, stiffness);
}

FFI_PLUGIN_EXPORT cpFloat cp_damped_rotary_spring_get_damping(cpConstraint* constraint) {
    return cpDampedRotarySpringGetDamping(constraint);
}

FFI_PLUGIN_EXPORT void cp_damped_rotary_spring_set_damping(cpConstraint* constraint, cpFloat damping) {
    cpDampedRotarySpringSetDamping(constraint, damping);
}

// Rotary limit joint
FFI_PLUGIN_EXPORT cpConstraint* cp_rotary_limit_joint_new(cpBody* a, cpBody* b, cpFloat min, cpFloat max) {
    return cpRotaryLimitJointNew(a, b, min, max);
}

FFI_PLUGIN_EXPORT cpFloat cp_rotary_limit_joint_get_min(cpConstraint* constraint) {
    return cpRotaryLimitJointGetMin(constraint);
}

FFI_PLUGIN_EXPORT void cp_rotary_limit_joint_set_min(cpConstraint* constraint, cpFloat min) {
    cpRotaryLimitJointSetMin(constraint, min);
}

FFI_PLUGIN_EXPORT cpFloat cp_rotary_limit_joint_get_max(cpConstraint* constraint) {
    return cpRotaryLimitJointGetMax(constraint);
}

FFI_PLUGIN_EXPORT void cp_rotary_limit_joint_set_max(cpConstraint* constraint, cpFloat max) {
    cpRotaryLimitJointSetMax(constraint, max);
}

// Ratchet joint
FFI_PLUGIN_EXPORT cpConstraint* cp_ratchet_joint_new(cpBody* a, cpBody* b, cpFloat phase, cpFloat ratchet) {
    return cpRatchetJointNew(a, b, phase, ratchet);
}

FFI_PLUGIN_EXPORT cpFloat cp_ratchet_joint_get_angle(cpConstraint* constraint) {
    return cpRatchetJointGetAngle(constraint);
}

FFI_PLUGIN_EXPORT void cp_ratchet_joint_set_angle(cpConstraint* constraint, cpFloat angle) {
    cpRatchetJointSetAngle(constraint, angle);
}

FFI_PLUGIN_EXPORT cpFloat cp_ratchet_joint_get_phase(cpConstraint* constraint) {
    return cpRatchetJointGetPhase(constraint);
}

FFI_PLUGIN_EXPORT void cp_ratchet_joint_set_phase(cpConstraint* constraint, cpFloat phase) {
    cpRatchetJointSetPhase(constraint, phase);
}

FFI_PLUGIN_EXPORT cpFloat cp_ratchet_joint_get_ratchet(cpConstraint* constraint) {
    return cpRatchetJointGetRatchet(constraint);
}

FFI_PLUGIN_EXPORT void cp_ratchet_joint_set_ratchet(cpConstraint* constraint, cpFloat ratchet) {
    cpRatchetJointSetRatchet(constraint, ratchet);
}

// Gear joint
FFI_PLUGIN_EXPORT cpConstraint* cp_gear_joint_new(cpBody* a, cpBody* b, cpFloat phase, cpFloat ratio) {
    return cpGearJointNew(a, b, phase, ratio);
}

FFI_PLUGIN_EXPORT cpFloat cp_gear_joint_get_phase(cpConstraint* constraint) {
    return cpGearJointGetPhase(constraint);
}

FFI_PLUGIN_EXPORT void cp_gear_joint_set_phase(cpConstraint* constraint, cpFloat phase) {
    cpGearJointSetPhase(constraint, phase);
}

FFI_PLUGIN_EXPORT cpFloat cp_gear_joint_get_ratio(cpConstraint* constraint) {
    return cpGearJointGetRatio(constraint);
}

FFI_PLUGIN_EXPORT void cp_gear_joint_set_ratio(cpConstraint* constraint, cpFloat ratio) {
    cpGearJointSetRatio(constraint, ratio);
}

// Simple motor
FFI_PLUGIN_EXPORT cpConstraint* cp_simple_motor_new(cpBody* a, cpBody* b, cpFloat rate) {
    return cpSimpleMotorNew(a, b, rate);
}

FFI_PLUGIN_EXPORT cpFloat cp_simple_motor_get_rate(cpConstraint* constraint) {
    return cpSimpleMotorGetRate(constraint);
}

FFI_PLUGIN_EXPORT void cp_simple_motor_set_rate(cpConstraint* constraint, cpFloat rate) {
    cpSimpleMotorSetRate(constraint, rate);
}

// Arbiter
FFI_PLUGIN_EXPORT cpFloat cp_arbiter_get_restitution(cpArbiter* arb) {
    return cpArbiterGetRestitution(arb);
}

FFI_PLUGIN_EXPORT void cp_arbiter_set_restitution(cpArbiter* arb, cpFloat restitution) {
    cpArbiterSetRestitution(arb, restitution);
}

FFI_PLUGIN_EXPORT cpFloat cp_arbiter_get_friction(cpArbiter* arb) {
    return cpArbiterGetFriction(arb);
}

FFI_PLUGIN_EXPORT void cp_arbiter_set_friction(cpArbiter* arb, cpFloat friction) {
    cpArbiterSetFriction(arb, friction);
}

FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_surface_velocity(cpArbiter* arb) {
    return cpArbiterGetSurfaceVelocity(arb);
}

FFI_PLUGIN_EXPORT void cp_arbiter_set_surface_velocity(cpArbiter* arb, cpVect vr) {
    cpArbiterSetSurfaceVelocity(arb, vr);
}

FFI_PLUGIN_EXPORT cpVect cp_arbiter_total_impulse(cpArbiter* arb) {
    return cpArbiterTotalImpulse(arb);
}

FFI_PLUGIN_EXPORT cpFloat cp_arbiter_total_ke(cpArbiter* arb) {
    return cpArbiterTotalKE(arb);
}

FFI_PLUGIN_EXPORT int cp_arbiter_ignore(cpArbiter* arb) {
    return cpArbiterIgnore(arb) ? 1 : 0;
}

FFI_PLUGIN_EXPORT void cp_arbiter_get_shapes(cpArbiter* arb, cpShape** a, cpShape** b) {
    cpArbiterGetShapes(arb, a, b);
}

FFI_PLUGIN_EXPORT void cp_arbiter_get_bodies(cpArbiter* arb, cpBody** a, cpBody** b) {
    cpArbiterGetBodies(arb, a, b);
}

FFI_PLUGIN_EXPORT cpContactPointSet cp_arbiter_get_contact_point_set(cpArbiter* arb) {
    return cpArbiterGetContactPointSet(arb);
}

FFI_PLUGIN_EXPORT void cp_arbiter_set_contact_point_set(cpArbiter* arb, cpContactPointSet* set) {
    cpArbiterSetContactPointSet(arb, set);
}

FFI_PLUGIN_EXPORT int cp_arbiter_is_first_contact(cpArbiter* arb) {
    return cpArbiterIsFirstContact(arb) ? 1 : 0;
}

FFI_PLUGIN_EXPORT int cp_arbiter_is_removal(cpArbiter* arb) {
    return cpArbiterIsRemoval(arb) ? 1 : 0;
}

FFI_PLUGIN_EXPORT int cp_arbiter_get_count(cpArbiter* arb) {
    return cpArbiterGetCount(arb);
}

FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_normal(cpArbiter* arb) {
    return cpArbiterGetNormal(arb);
}

FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_point_a(cpArbiter* arb, int i) {
    return cpArbiterGetPointA(arb, i);
}

FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_point_b(cpArbiter* arb, int i) {
    return cpArbiterGetPointB(arb, i);
}

FFI_PLUGIN_EXPORT cpFloat cp_arbiter_get_depth(cpArbiter* arb, int i) {
    return cpArbiterGetDepth(arb, i);
}

// Utility functions
FFI_PLUGIN_EXPORT cpFloat cp_moment_for_circle(cpFloat m, cpFloat r1, cpFloat r2, cpVect offset) {
    return cpMomentForCircle(m, r1, r2, offset);
}

FFI_PLUGIN_EXPORT cpFloat cp_area_for_circle(cpFloat r1, cpFloat r2) {
    return cpAreaForCircle(r1, r2);
}

FFI_PLUGIN_EXPORT cpFloat cp_moment_for_segment(cpFloat m, cpVect a, cpVect b, cpFloat radius) {
    return cpMomentForSegment(m, a, b, radius);
}

FFI_PLUGIN_EXPORT cpFloat cp_area_for_segment(cpVect a, cpVect b, cpFloat radius) {
    return cpAreaForSegment(a, b, radius);
}

FFI_PLUGIN_EXPORT cpFloat cp_moment_for_poly(cpFloat m, int count, cpVect* verts, cpVect offset, cpFloat radius) {
    return cpMomentForPoly(m, count, verts, offset, radius);
}

FFI_PLUGIN_EXPORT cpFloat cp_area_for_poly(int count, cpVect* verts, cpFloat radius) {
    return cpAreaForPoly(count, verts, radius);
}

FFI_PLUGIN_EXPORT cpVect cp_centroid_for_poly(int count, cpVect* verts) {
    return cpCentroidForPoly(count, verts);
}

FFI_PLUGIN_EXPORT cpFloat cp_moment_for_box(cpFloat m, cpFloat width, cpFloat height) {
    return cpMomentForBox(m, width, height);
}

FFI_PLUGIN_EXPORT cpFloat cp_moment_for_box2(cpFloat m, cpBB box) {
    return cpMomentForBox2(m, box);
}

FFI_PLUGIN_EXPORT int cp_convex_hull(int count, cpVect* verts, cpVect* result, int* first, cpFloat tol) {
    return cpConvexHull(count, verts, result, first, tol);
}
