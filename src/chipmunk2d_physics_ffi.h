#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
// On Unix-like systems, we need to explicitly export symbols when visibility is hidden
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

// Include Chipmunk2D headers
// The chipmunk2d directory should be available during build
#include <chipmunk/chipmunk.h>

// Chipmunk2D wrapper functions for FFI
// These functions expose Chipmunk2D API to Dart

// Space management
FFI_PLUGIN_EXPORT cpSpace* cp_space_new(void);
FFI_PLUGIN_EXPORT void cp_space_free(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_step(cpSpace* space, cpFloat dt);
FFI_PLUGIN_EXPORT void cp_space_set_gravity(cpSpace* space, cpVect gravity);
FFI_PLUGIN_EXPORT cpVect cp_space_get_gravity(cpSpace* space);
FFI_PLUGIN_EXPORT int cp_space_get_iterations(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_set_iterations(cpSpace* space, int iterations);
FFI_PLUGIN_EXPORT cpFloat cp_space_get_damping(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_set_damping(cpSpace* space, cpFloat damping);
FFI_PLUGIN_EXPORT cpFloat cp_space_get_idle_speed_threshold(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_set_idle_speed_threshold(cpSpace* space, cpFloat idleSpeedThreshold);
FFI_PLUGIN_EXPORT cpFloat cp_space_get_sleep_time_threshold(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_set_sleep_time_threshold(cpSpace* space, cpFloat sleepTimeThreshold);
FFI_PLUGIN_EXPORT cpFloat cp_space_get_collision_slop(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_set_collision_slop(cpSpace* space, cpFloat collisionSlop);
FFI_PLUGIN_EXPORT cpFloat cp_space_get_collision_bias(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_set_collision_bias(cpSpace* space, cpFloat collisionBias);
FFI_PLUGIN_EXPORT unsigned int cp_space_get_collision_persistence(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_set_collision_persistence(cpSpace* space, unsigned int collisionPersistence);
FFI_PLUGIN_EXPORT void cp_space_reindex_static(cpSpace* space);
FFI_PLUGIN_EXPORT void cp_space_reindex_shape(cpSpace* space, cpShape* shape);
FFI_PLUGIN_EXPORT void cp_space_reindex_shapes_for_body(cpSpace* space, cpBody* body);
FFI_PLUGIN_EXPORT cpBody* cp_space_get_static_body(cpSpace* space);
FFI_PLUGIN_EXPORT cpFloat cp_space_get_current_time_step(cpSpace* space);
FFI_PLUGIN_EXPORT int cp_space_is_locked(cpSpace* space);
FFI_PLUGIN_EXPORT int cp_space_contains_body(cpSpace* space, cpBody* body);
FFI_PLUGIN_EXPORT int cp_space_contains_shape(cpSpace* space, cpShape* shape);
FFI_PLUGIN_EXPORT int cp_space_contains_constraint(cpSpace* space, cpConstraint* constraint);

// Body management
FFI_PLUGIN_EXPORT cpBody* cp_body_new(cpFloat mass, cpFloat moment);
FFI_PLUGIN_EXPORT cpBody* cp_body_new_kinematic(void);
FFI_PLUGIN_EXPORT cpBody* cp_body_new_static(void);
FFI_PLUGIN_EXPORT void cp_body_free(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_position(cpBody* body, cpVect pos);
FFI_PLUGIN_EXPORT cpVect cp_body_get_position(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_velocity(cpBody* body, cpVect velocity);
FFI_PLUGIN_EXPORT cpVect cp_body_get_velocity(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_angle(cpBody* body, cpFloat angle);
FFI_PLUGIN_EXPORT cpFloat cp_body_get_angle(cpBody* body);
FFI_PLUGIN_EXPORT cpFloat cp_body_get_mass(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_mass(cpBody* body, cpFloat mass);
FFI_PLUGIN_EXPORT cpFloat cp_body_get_moment(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_moment(cpBody* body, cpFloat moment);
FFI_PLUGIN_EXPORT cpVect cp_body_get_center_of_gravity(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_center_of_gravity(cpBody* body, cpVect cog);
FFI_PLUGIN_EXPORT cpVect cp_body_get_force(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_force(cpBody* body, cpVect force);
FFI_PLUGIN_EXPORT cpFloat cp_body_get_angular_velocity(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_angular_velocity(cpBody* body, cpFloat angularVelocity);
FFI_PLUGIN_EXPORT cpFloat cp_body_get_torque(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_torque(cpBody* body, cpFloat torque);
FFI_PLUGIN_EXPORT cpVect cp_body_get_rotation(cpBody* body);
FFI_PLUGIN_EXPORT int cp_body_get_type(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_set_type(cpBody* body, int type);
FFI_PLUGIN_EXPORT int cp_body_is_sleeping(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_activate(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_activate_static(cpBody* body, cpShape* filter);
FFI_PLUGIN_EXPORT void cp_body_sleep(cpBody* body);
FFI_PLUGIN_EXPORT void cp_body_sleep_with_group(cpBody* body, cpBody* group);
FFI_PLUGIN_EXPORT cpVect cp_body_local_to_world(cpBody* body, cpVect point);
FFI_PLUGIN_EXPORT cpVect cp_body_world_to_local(cpBody* body, cpVect point);
FFI_PLUGIN_EXPORT void cp_body_apply_force_at_world_point(cpBody* body, cpVect force, cpVect point);
FFI_PLUGIN_EXPORT void cp_body_apply_force_at_local_point(cpBody* body, cpVect force, cpVect point);
FFI_PLUGIN_EXPORT void cp_body_apply_impulse_at_world_point(cpBody* body, cpVect impulse, cpVect point);
FFI_PLUGIN_EXPORT void cp_body_apply_impulse_at_local_point(cpBody* body, cpVect impulse, cpVect point);
FFI_PLUGIN_EXPORT cpVect cp_body_get_velocity_at_world_point(cpBody* body, cpVect point);
FFI_PLUGIN_EXPORT cpVect cp_body_get_velocity_at_local_point(cpBody* body, cpVect point);
FFI_PLUGIN_EXPORT cpFloat cp_body_kinetic_energy(cpBody* body);
FFI_PLUGIN_EXPORT cpSpace* cp_body_get_space(cpBody* body);

// Shape management
FFI_PLUGIN_EXPORT cpShape* cp_circle_shape_new(cpBody* body, cpFloat radius, cpVect offset);
FFI_PLUGIN_EXPORT cpShape* cp_box_shape_new(cpBody* body, cpFloat width, cpFloat height, cpFloat radius);
FFI_PLUGIN_EXPORT cpShape* cp_segment_shape_new(cpBody* body, cpVect a, cpVect b, cpFloat radius);
FFI_PLUGIN_EXPORT cpShape* cp_poly_shape_new(cpBody* body, int count, cpVect* verts, cpTransform transform, cpFloat radius);
FFI_PLUGIN_EXPORT cpShape* cp_poly_shape_new_raw(cpBody* body, int count, cpVect* verts, cpFloat radius);
FFI_PLUGIN_EXPORT cpShape* cp_box_shape_new2(cpBody* body, cpBB box, cpFloat radius);
FFI_PLUGIN_EXPORT void cp_shape_free(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_friction(cpShape* shape, cpFloat friction);
FFI_PLUGIN_EXPORT cpFloat cp_shape_get_friction(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_elasticity(cpShape* shape, cpFloat elasticity);
FFI_PLUGIN_EXPORT cpFloat cp_shape_get_elasticity(cpShape* shape);
FFI_PLUGIN_EXPORT cpShapeFilter cp_shape_get_filter(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_filter(cpShape* shape, cpShapeFilter filter);
FFI_PLUGIN_EXPORT cpShapeFilter cp_shape_filter_new(cpGroup group, cpBitmask categories, cpBitmask mask);
FFI_PLUGIN_EXPORT cpFloat cp_shape_get_mass(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_mass(cpShape* shape, cpFloat mass);
FFI_PLUGIN_EXPORT cpFloat cp_shape_get_density(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_density(cpShape* shape, cpFloat density);
FFI_PLUGIN_EXPORT cpFloat cp_shape_get_moment(cpShape* shape);
FFI_PLUGIN_EXPORT cpFloat cp_shape_get_area(cpShape* shape);
FFI_PLUGIN_EXPORT cpVect cp_shape_get_center_of_gravity(cpShape* shape);
FFI_PLUGIN_EXPORT cpBB cp_shape_get_bb(cpShape* shape);
FFI_PLUGIN_EXPORT int cp_shape_get_sensor(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_sensor(cpShape* shape, int sensor);
FFI_PLUGIN_EXPORT cpVect cp_shape_get_surface_velocity(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_surface_velocity(cpShape* shape, cpVect surfaceVelocity);
FFI_PLUGIN_EXPORT uintptr_t cp_shape_get_collision_type(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_collision_type(cpShape* shape, uintptr_t collisionType);
FFI_PLUGIN_EXPORT cpBody* cp_shape_get_body(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_shape_set_body(cpShape* shape, cpBody* body);
FFI_PLUGIN_EXPORT cpSpace* cp_shape_get_space(cpShape* shape);
FFI_PLUGIN_EXPORT cpFloat cp_shape_point_query(cpShape* shape, cpVect p, cpPointQueryInfo* out);
FFI_PLUGIN_EXPORT int cp_shape_segment_query(cpShape* shape, cpVect a, cpVect b, cpFloat radius, cpSegmentQueryInfo* info);
FFI_PLUGIN_EXPORT cpContactPointSet cp_shapes_collide(cpShape* a, cpShape* b);
// Circle shape specific
FFI_PLUGIN_EXPORT cpVect cp_circle_shape_get_offset(cpShape* shape);
FFI_PLUGIN_EXPORT cpFloat cp_circle_shape_get_radius(cpShape* shape);
// Segment shape specific
FFI_PLUGIN_EXPORT cpVect cp_segment_shape_get_a(cpShape* shape);
FFI_PLUGIN_EXPORT cpVect cp_segment_shape_get_b(cpShape* shape);
FFI_PLUGIN_EXPORT cpVect cp_segment_shape_get_normal(cpShape* shape);
FFI_PLUGIN_EXPORT cpFloat cp_segment_shape_get_radius(cpShape* shape);
FFI_PLUGIN_EXPORT void cp_segment_shape_set_neighbors(cpShape* shape, cpVect prev, cpVect next);
// Poly shape specific
FFI_PLUGIN_EXPORT int cp_poly_shape_get_count(cpShape* shape);
FFI_PLUGIN_EXPORT cpVect cp_poly_shape_get_vert(cpShape* shape, int index);
FFI_PLUGIN_EXPORT cpFloat cp_poly_shape_get_radius(cpShape* shape);

// Space-Body-Shape relationships
FFI_PLUGIN_EXPORT void cp_space_add_body(cpSpace* space, cpBody* body);
FFI_PLUGIN_EXPORT void cp_space_remove_body(cpSpace* space, cpBody* body);
FFI_PLUGIN_EXPORT void cp_space_add_shape(cpSpace* space, cpShape* shape);
FFI_PLUGIN_EXPORT void cp_space_remove_shape(cpSpace* space, cpShape* shape);
FFI_PLUGIN_EXPORT void cp_space_add_constraint(cpSpace* space, cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_space_remove_constraint(cpSpace* space, cpConstraint* constraint);

// Vector utilities
FFI_PLUGIN_EXPORT cpVect cp_vect_new(cpFloat x, cpFloat y);
FFI_PLUGIN_EXPORT cpFloat cp_vect_get_x(cpVect v);
FFI_PLUGIN_EXPORT cpFloat cp_vect_get_y(cpVect v);

// Collision detection and spatial queries
FFI_PLUGIN_EXPORT cpShape* cp_space_point_query_nearest(cpSpace* space, cpVect point, cpFloat maxDistance, cpShapeFilter filter, cpPointQueryInfo* out);
FFI_PLUGIN_EXPORT cpShape* cp_space_segment_query_first(cpSpace* space, cpVect start, cpVect end, cpFloat radius, cpShapeFilter filter, cpSegmentQueryInfo* out);
FFI_PLUGIN_EXPORT int cp_space_shape_query(cpSpace* space, cpShape* shape, void* func, void* data);

// Constraint management
FFI_PLUGIN_EXPORT void cp_constraint_free(cpConstraint* constraint);
FFI_PLUGIN_EXPORT cpSpace* cp_constraint_get_space(cpConstraint* constraint);
FFI_PLUGIN_EXPORT cpBody* cp_constraint_get_body_a(cpConstraint* constraint);
FFI_PLUGIN_EXPORT cpBody* cp_constraint_get_body_b(cpConstraint* constraint);
FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_max_force(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_constraint_set_max_force(cpConstraint* constraint, cpFloat maxForce);
FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_error_bias(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_constraint_set_error_bias(cpConstraint* constraint, cpFloat errorBias);
FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_max_bias(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_constraint_set_max_bias(cpConstraint* constraint, cpFloat maxBias);
FFI_PLUGIN_EXPORT int cp_constraint_get_collide_bodies(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_constraint_set_collide_bodies(cpConstraint* constraint, int collideBodies);
FFI_PLUGIN_EXPORT cpFloat cp_constraint_get_impulse(cpConstraint* constraint);
// Pin joint
FFI_PLUGIN_EXPORT cpConstraint* cp_pin_joint_new(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB);
FFI_PLUGIN_EXPORT cpVect cp_pin_joint_get_anchor_a(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_pin_joint_set_anchor_a(cpConstraint* constraint, cpVect anchorA);
FFI_PLUGIN_EXPORT cpVect cp_pin_joint_get_anchor_b(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_pin_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB);
FFI_PLUGIN_EXPORT cpFloat cp_pin_joint_get_dist(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_pin_joint_set_dist(cpConstraint* constraint, cpFloat dist);
// Slide joint
FFI_PLUGIN_EXPORT cpConstraint* cp_slide_joint_new(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB, cpFloat min, cpFloat max);
FFI_PLUGIN_EXPORT cpVect cp_slide_joint_get_anchor_a(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_slide_joint_set_anchor_a(cpConstraint* constraint, cpVect anchorA);
FFI_PLUGIN_EXPORT cpVect cp_slide_joint_get_anchor_b(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_slide_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB);
FFI_PLUGIN_EXPORT cpFloat cp_slide_joint_get_min(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_slide_joint_set_min(cpConstraint* constraint, cpFloat min);
FFI_PLUGIN_EXPORT cpFloat cp_slide_joint_get_max(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_slide_joint_set_max(cpConstraint* constraint, cpFloat max);
// Pivot joint
FFI_PLUGIN_EXPORT cpConstraint* cp_pivot_joint_new(cpBody* a, cpBody* b, cpVect pivot);
FFI_PLUGIN_EXPORT cpConstraint* cp_pivot_joint_new2(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB);
FFI_PLUGIN_EXPORT cpVect cp_pivot_joint_get_anchor_a(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_pivot_joint_set_anchor_a(cpConstraint* constraint, cpVect anchorA);
FFI_PLUGIN_EXPORT cpVect cp_pivot_joint_get_anchor_b(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_pivot_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB);
// Groove joint
FFI_PLUGIN_EXPORT cpConstraint* cp_groove_joint_new(cpBody* a, cpBody* b, cpVect groove_a, cpVect groove_b, cpVect anchorB);
FFI_PLUGIN_EXPORT cpVect cp_groove_joint_get_groove_a(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_groove_joint_set_groove_a(cpConstraint* constraint, cpVect grooveA);
FFI_PLUGIN_EXPORT cpVect cp_groove_joint_get_groove_b(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_groove_joint_set_groove_b(cpConstraint* constraint, cpVect grooveB);
FFI_PLUGIN_EXPORT cpVect cp_groove_joint_get_anchor_b(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_groove_joint_set_anchor_b(cpConstraint* constraint, cpVect anchorB);
// Damped spring
FFI_PLUGIN_EXPORT cpConstraint* cp_damped_spring_new(cpBody* a, cpBody* b, cpVect anchorA, cpVect anchorB, cpFloat restLength, cpFloat stiffness, cpFloat damping);
FFI_PLUGIN_EXPORT cpVect cp_damped_spring_get_anchor_a(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_spring_set_anchor_a(cpConstraint* constraint, cpVect anchorA);
FFI_PLUGIN_EXPORT cpVect cp_damped_spring_get_anchor_b(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_spring_set_anchor_b(cpConstraint* constraint, cpVect anchorB);
FFI_PLUGIN_EXPORT cpFloat cp_damped_spring_get_rest_length(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_spring_set_rest_length(cpConstraint* constraint, cpFloat restLength);
FFI_PLUGIN_EXPORT cpFloat cp_damped_spring_get_stiffness(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_spring_set_stiffness(cpConstraint* constraint, cpFloat stiffness);
FFI_PLUGIN_EXPORT cpFloat cp_damped_spring_get_damping(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_spring_set_damping(cpConstraint* constraint, cpFloat damping);
// Damped rotary spring
FFI_PLUGIN_EXPORT cpConstraint* cp_damped_rotary_spring_new(cpBody* a, cpBody* b, cpFloat restAngle, cpFloat stiffness, cpFloat damping);
FFI_PLUGIN_EXPORT cpFloat cp_damped_rotary_spring_get_rest_angle(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_rotary_spring_set_rest_angle(cpConstraint* constraint, cpFloat restAngle);
FFI_PLUGIN_EXPORT cpFloat cp_damped_rotary_spring_get_stiffness(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_rotary_spring_set_stiffness(cpConstraint* constraint, cpFloat stiffness);
FFI_PLUGIN_EXPORT cpFloat cp_damped_rotary_spring_get_damping(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_damped_rotary_spring_set_damping(cpConstraint* constraint, cpFloat damping);
// Rotary limit joint
FFI_PLUGIN_EXPORT cpConstraint* cp_rotary_limit_joint_new(cpBody* a, cpBody* b, cpFloat min, cpFloat max);
FFI_PLUGIN_EXPORT cpFloat cp_rotary_limit_joint_get_min(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_rotary_limit_joint_set_min(cpConstraint* constraint, cpFloat min);
FFI_PLUGIN_EXPORT cpFloat cp_rotary_limit_joint_get_max(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_rotary_limit_joint_set_max(cpConstraint* constraint, cpFloat max);
// Ratchet joint
FFI_PLUGIN_EXPORT cpConstraint* cp_ratchet_joint_new(cpBody* a, cpBody* b, cpFloat phase, cpFloat ratchet);
FFI_PLUGIN_EXPORT cpFloat cp_ratchet_joint_get_angle(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_ratchet_joint_set_angle(cpConstraint* constraint, cpFloat angle);
FFI_PLUGIN_EXPORT cpFloat cp_ratchet_joint_get_phase(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_ratchet_joint_set_phase(cpConstraint* constraint, cpFloat phase);
FFI_PLUGIN_EXPORT cpFloat cp_ratchet_joint_get_ratchet(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_ratchet_joint_set_ratchet(cpConstraint* constraint, cpFloat ratchet);
// Gear joint
FFI_PLUGIN_EXPORT cpConstraint* cp_gear_joint_new(cpBody* a, cpBody* b, cpFloat phase, cpFloat ratio);
FFI_PLUGIN_EXPORT cpFloat cp_gear_joint_get_phase(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_gear_joint_set_phase(cpConstraint* constraint, cpFloat phase);
FFI_PLUGIN_EXPORT cpFloat cp_gear_joint_get_ratio(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_gear_joint_set_ratio(cpConstraint* constraint, cpFloat ratio);
// Simple motor
FFI_PLUGIN_EXPORT cpConstraint* cp_simple_motor_new(cpBody* a, cpBody* b, cpFloat rate);
FFI_PLUGIN_EXPORT cpFloat cp_simple_motor_get_rate(cpConstraint* constraint);
FFI_PLUGIN_EXPORT void cp_simple_motor_set_rate(cpConstraint* constraint, cpFloat rate);

// Arbiter
FFI_PLUGIN_EXPORT cpFloat cp_arbiter_get_restitution(cpArbiter* arb);
FFI_PLUGIN_EXPORT void cp_arbiter_set_restitution(cpArbiter* arb, cpFloat restitution);
FFI_PLUGIN_EXPORT cpFloat cp_arbiter_get_friction(cpArbiter* arb);
FFI_PLUGIN_EXPORT void cp_arbiter_set_friction(cpArbiter* arb, cpFloat friction);
FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_surface_velocity(cpArbiter* arb);
FFI_PLUGIN_EXPORT void cp_arbiter_set_surface_velocity(cpArbiter* arb, cpVect vr);
FFI_PLUGIN_EXPORT cpVect cp_arbiter_total_impulse(cpArbiter* arb);
FFI_PLUGIN_EXPORT cpFloat cp_arbiter_total_ke(cpArbiter* arb);
FFI_PLUGIN_EXPORT int cp_arbiter_ignore(cpArbiter* arb);
FFI_PLUGIN_EXPORT void cp_arbiter_get_shapes(cpArbiter* arb, cpShape** a, cpShape** b);
FFI_PLUGIN_EXPORT void cp_arbiter_get_bodies(cpArbiter* arb, cpBody** a, cpBody** b);
FFI_PLUGIN_EXPORT cpContactPointSet cp_arbiter_get_contact_point_set(cpArbiter* arb);
FFI_PLUGIN_EXPORT void cp_arbiter_set_contact_point_set(cpArbiter* arb, cpContactPointSet* set);
FFI_PLUGIN_EXPORT int cp_arbiter_is_first_contact(cpArbiter* arb);
FFI_PLUGIN_EXPORT int cp_arbiter_is_removal(cpArbiter* arb);
FFI_PLUGIN_EXPORT int cp_arbiter_get_count(cpArbiter* arb);
FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_normal(cpArbiter* arb);
FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_point_a(cpArbiter* arb, int i);
FFI_PLUGIN_EXPORT cpVect cp_arbiter_get_point_b(cpArbiter* arb, int i);
FFI_PLUGIN_EXPORT cpFloat cp_arbiter_get_depth(cpArbiter* arb, int i);

// Utility functions
FFI_PLUGIN_EXPORT cpFloat cp_moment_for_circle(cpFloat m, cpFloat r1, cpFloat r2, cpVect offset);
FFI_PLUGIN_EXPORT cpFloat cp_area_for_circle(cpFloat r1, cpFloat r2);
FFI_PLUGIN_EXPORT cpFloat cp_moment_for_segment(cpFloat m, cpVect a, cpVect b, cpFloat radius);
FFI_PLUGIN_EXPORT cpFloat cp_area_for_segment(cpVect a, cpVect b, cpFloat radius);
FFI_PLUGIN_EXPORT cpFloat cp_moment_for_poly(cpFloat m, int count, cpVect* verts, cpVect offset, cpFloat radius);
FFI_PLUGIN_EXPORT cpFloat cp_area_for_poly(int count, cpVect* verts, cpFloat radius);
FFI_PLUGIN_EXPORT cpVect cp_centroid_for_poly(int count, cpVect* verts);
FFI_PLUGIN_EXPORT cpFloat cp_moment_for_box(cpFloat m, cpFloat width, cpFloat height);
FFI_PLUGIN_EXPORT cpFloat cp_moment_for_box2(cpFloat m, cpBB box);
FFI_PLUGIN_EXPORT int cp_convex_hull(int count, cpVect* verts, cpVect* result, int* first, cpFloat tol);
