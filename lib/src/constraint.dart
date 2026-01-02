import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/body.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Base class for physics constraints (joints).
/// Constraints connect two bodies together and enforce relationships between them.
abstract class Constraint {
  final ffi.Pointer<bindings.cpConstraint> _native;
  bool _disposed = false;

  /// Gets the native pointer (for internal use).
  ffi.Pointer<bindings.cpConstraint> get native {
    if (_disposed) throw StateError('Constraint has been disposed');
    return _native;
  }

  /// The maximum force that this constraint is allowed to use.
  /// Defaults to INFINITY.
  double get maxForce {
    if (_disposed) throw StateError('Constraint has been disposed');
    return bindings.cp_constraint_get_max_force(_native);
  }

  set maxForce(double maxForce) {
    if (_disposed) throw StateError('Constraint has been disposed');
    bindings.cp_constraint_set_max_force(_native, maxForce);
  }

  /// Rate at which joint error is corrected.
  /// Defaults to pow(1.0 - 0.1, 60.0) meaning that it will
  /// correct 10% of the error every 1/60th of a second.
  double get errorBias {
    if (_disposed) throw StateError('Constraint has been disposed');
    return bindings.cp_constraint_get_error_bias(_native);
  }

  set errorBias(double errorBias) {
    if (_disposed) throw StateError('Constraint has been disposed');
    bindings.cp_constraint_set_error_bias(_native, errorBias);
  }

  /// Maximum rate at which joint error is corrected.
  /// Defaults to INFINITY.
  double get maxBias {
    if (_disposed) throw StateError('Constraint has been disposed');
    return bindings.cp_constraint_get_max_bias(_native);
  }

  set maxBias(double maxBias) {
    if (_disposed) throw StateError('Constraint has been disposed');
    bindings.cp_constraint_set_max_bias(_native, maxBias);
  }

  /// Whether the two bodies connected by the constraint are allowed to collide.
  /// Defaults to false.
  bool get collideBodies {
    if (_disposed) throw StateError('Constraint has been disposed');
    return bindings.cp_constraint_get_collide_bodies(_native) != 0;
  }

  set collideBodies(bool collideBodies) {
    if (_disposed) throw StateError('Constraint has been disposed');
    bindings.cp_constraint_set_collide_bodies(_native, collideBodies ? 1 : 0);
  }

  /// The last impulse applied by this constraint.
  /// This function should only be called from a post-solve, post-step or cpBodyEachArbiter callback.
  double get impulse {
    if (_disposed) throw StateError('Constraint has been disposed');
    return bindings.cp_constraint_get_impulse(_native);
  }

  /// The first body the constraint is attached to.
  Body get bodyA {
    if (_disposed) throw StateError('Constraint has been disposed');
    final nativeBody = bindings.cp_constraint_get_body_a(_native);
    return Body.fromNative(nativeBody);
  }

  /// The second body the constraint is attached to.
  Body get bodyB {
    if (_disposed) throw StateError('Constraint has been disposed');
    final nativeBody = bindings.cp_constraint_get_body_b(_native);
    return Body.fromNative(nativeBody);
  }

  /// Disposes of this constraint and frees its resources.
  void dispose() {
    if (!_disposed) {
      bindings.cp_constraint_free(_native);
      _disposed = true;
    }
  }

  Constraint._(this._native);
}

/// A pin joint keeps two anchor points on two bodies at a fixed distance from each other.
class PinJoint extends Constraint {
  /// Creates a pin joint connecting two bodies at specific anchor points.
  factory PinJoint(Body a, Body b, Vector anchorA, Vector anchorB) {
    final native = bindings.cp_pin_joint_new(
      a.native,
      b.native,
      anchorA.toNative(),
      anchorB.toNative(),
    );
    if (native.address == 0) {
      throw Exception('Failed to create pin joint');
    }
    return PinJoint._(native);
  }

  PinJoint._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Location of the first anchor relative to the first body.
  Vector get anchorA {
    if (_disposed) throw StateError('PinJoint has been disposed');
    return Vector.fromNative(bindings.cp_pin_joint_get_anchor_a(_native));
  }

  set anchorA(Vector anchorA) {
    if (_disposed) throw StateError('PinJoint has been disposed');
    bindings.cp_pin_joint_set_anchor_a(_native, anchorA.toNative());
  }

  /// Location of the second anchor relative to the second body.
  Vector get anchorB {
    if (_disposed) throw StateError('PinJoint has been disposed');
    return Vector.fromNative(bindings.cp_pin_joint_get_anchor_b(_native));
  }

  set anchorB(Vector anchorB) {
    if (_disposed) throw StateError('PinJoint has been disposed');
    bindings.cp_pin_joint_set_anchor_b(_native, anchorB.toNative());
  }

  /// Distance the joint will maintain between the two anchors.
  double get distance {
    if (_disposed) throw StateError('PinJoint has been disposed');
    return bindings.cp_pin_joint_get_dist(_native);
  }

  set distance(double dist) {
    if (_disposed) throw StateError('PinJoint has been disposed');
    bindings.cp_pin_joint_set_dist(_native, dist);
  }
}

/// A slide joint keeps two anchor points on two bodies within a range of distances from each other.
class SlideJoint extends Constraint {
  /// Creates a slide joint connecting two bodies at specific anchor points with min/max distance limits.
  factory SlideJoint(Body a, Body b, Vector anchorA, Vector anchorB, double min, double max) {
    final native = bindings.cp_slide_joint_new(
      a.native,
      b.native,
      anchorA.toNative(),
      anchorB.toNative(),
      min,
      max,
    );
    if (native.address == 0) {
      throw Exception('Failed to create slide joint');
    }
    return SlideJoint._(native);
  }

  SlideJoint._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Location of the first anchor relative to the first body.
  Vector get anchorA {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return Vector.fromNative(bindings.cp_slide_joint_get_anchor_a(_native));
  }

  set anchorA(Vector anchorA) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    bindings.cp_slide_joint_set_anchor_a(_native, anchorA.toNative());
  }

  /// Location of the second anchor relative to the second body.
  Vector get anchorB {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return Vector.fromNative(bindings.cp_slide_joint_get_anchor_b(_native));
  }

  set anchorB(Vector anchorB) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    bindings.cp_slide_joint_set_anchor_b(_native, anchorB.toNative());
  }

  /// Minimum distance the joint will maintain between the two anchors.
  double get min {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return bindings.cp_slide_joint_get_min(_native);
  }

  set min(double min) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    bindings.cp_slide_joint_set_min(_native, min);
  }

  /// Maximum distance the joint will maintain between the two anchors.
  double get max {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return bindings.cp_slide_joint_get_max(_native);
  }

  set max(double max) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    bindings.cp_slide_joint_set_max(_native, max);
  }
}

/// A pivot joint keeps two anchor points on two bodies at the same location.
class PivotJoint extends Constraint {
  /// Creates a pivot joint connecting two bodies at a common pivot point (in world coordinates).
  factory PivotJoint.atWorldPoint(Body a, Body b, Vector pivot) {
    final native = bindings.cp_pivot_joint_new(
      a.native,
      b.native,
      pivot.toNative(),
    );
    if (native.address == 0) {
      throw Exception('Failed to create pivot joint');
    }
    return PivotJoint._(native);
  }

  /// Creates a pivot joint connecting two bodies at specific anchor points (in body local coordinates).
  factory PivotJoint.atLocalPoints(Body a, Body b, Vector anchorA, Vector anchorB) {
    final native = bindings.cp_pivot_joint_new2(
      a.native,
      b.native,
      anchorA.toNative(),
      anchorB.toNative(),
    );
    if (native.address == 0) {
      throw Exception('Failed to create pivot joint');
    }
    return PivotJoint._(native);
  }

  PivotJoint._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Location of the first anchor relative to the first body.
  Vector get anchorA {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    return Vector.fromNative(bindings.cp_pivot_joint_get_anchor_a(_native));
  }

  set anchorA(Vector anchorA) {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    bindings.cp_pivot_joint_set_anchor_a(_native, anchorA.toNative());
  }

  /// Location of the second anchor relative to the second body.
  Vector get anchorB {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    return Vector.fromNative(bindings.cp_pivot_joint_get_anchor_b(_native));
  }

  set anchorB(Vector anchorB) {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    bindings.cp_pivot_joint_set_anchor_b(_native, anchorB.toNative());
  }
}

/// A groove joint keeps a pivot on one body constrained to a groove on another body.
class GrooveJoint extends Constraint {
  /// Creates a groove joint.
  /// The pivot on body B is constrained to move along the groove defined on body A.
  factory GrooveJoint(Body a, Body b, Vector grooveA, Vector grooveB, Vector anchorB) {
    final native = bindings.cp_groove_joint_new(
      a.native,
      b.native,
      grooveA.toNative(),
      grooveB.toNative(),
      anchorB.toNative(),
    );
    if (native.address == 0) {
      throw Exception('Failed to create groove joint');
    }
    return GrooveJoint._(native);
  }

  GrooveJoint._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// First endpoint of the groove relative to the first body.
  Vector get grooveA {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    return Vector.fromNative(bindings.cp_groove_joint_get_groove_a(_native));
  }

  set grooveA(Vector grooveA) {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    bindings.cp_groove_joint_set_groove_a(_native, grooveA.toNative());
  }

  /// Second endpoint of the groove relative to the first body.
  Vector get grooveB {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    return Vector.fromNative(bindings.cp_groove_joint_get_groove_b(_native));
  }

  set grooveB(Vector grooveB) {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    bindings.cp_groove_joint_set_groove_b(_native, grooveB.toNative());
  }

  /// Location of the pivot anchor relative to the second body.
  Vector get anchorB {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    return Vector.fromNative(bindings.cp_groove_joint_get_anchor_b(_native));
  }

  set anchorB(Vector anchorB) {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    bindings.cp_groove_joint_set_anchor_b(_native, anchorB.toNative());
  }
}

/// A damped spring connects two bodies with a spring force.
class DampedSpring extends Constraint {
  /// Creates a damped spring connecting two bodies.
  factory DampedSpring(
    Body a,
    Body b,
    Vector anchorA,
    Vector anchorB,
    double restLength,
    double stiffness,
    double damping,
  ) {
    final native = bindings.cp_damped_spring_new(
      a.native,
      b.native,
      anchorA.toNative(),
      anchorB.toNative(),
      restLength,
      stiffness,
      damping,
    );
    if (native.address == 0) {
      throw Exception('Failed to create damped spring');
    }
    return DampedSpring._(native);
  }

  DampedSpring._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Location of the first anchor relative to the first body.
  Vector get anchorA {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return Vector.fromNative(bindings.cp_damped_spring_get_anchor_a(_native));
  }

  set anchorA(Vector anchorA) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    bindings.cp_damped_spring_set_anchor_a(_native, anchorA.toNative());
  }

  /// Location of the second anchor relative to the second body.
  Vector get anchorB {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return Vector.fromNative(bindings.cp_damped_spring_get_anchor_b(_native));
  }

  set anchorB(Vector anchorB) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    bindings.cp_damped_spring_set_anchor_b(_native, anchorB.toNative());
  }

  /// Rest length of the spring.
  double get restLength {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return bindings.cp_damped_spring_get_rest_length(_native);
  }

  set restLength(double restLength) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    bindings.cp_damped_spring_set_rest_length(_native, restLength);
  }

  /// Stiffness of the spring in force/distance.
  double get stiffness {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return bindings.cp_damped_spring_get_stiffness(_native);
  }

  set stiffness(double stiffness) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    bindings.cp_damped_spring_set_stiffness(_native, stiffness);
  }

  /// Damping of the spring.
  double get damping {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return bindings.cp_damped_spring_get_damping(_native);
  }

  set damping(double damping) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    bindings.cp_damped_spring_set_damping(_native, damping);
  }
}

/// A damped rotary spring connects two bodies with a rotational spring force.
class DampedRotarySpring extends Constraint {
  /// Creates a damped rotary spring connecting two bodies.
  factory DampedRotarySpring(
    Body a,
    Body b,
    double restAngle,
    double stiffness,
    double damping,
  ) {
    final native = bindings.cp_damped_rotary_spring_new(
      a.native,
      b.native,
      restAngle,
      stiffness,
      damping,
    );
    if (native.address == 0) {
      throw Exception('Failed to create damped rotary spring');
    }
    return DampedRotarySpring._(native);
  }

  DampedRotarySpring._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Rest angle of the spring in radians.
  double get restAngle {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    return bindings.cp_damped_rotary_spring_get_rest_angle(_native);
  }

  set restAngle(double restAngle) {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    bindings.cp_damped_rotary_spring_set_rest_angle(_native, restAngle);
  }

  /// Stiffness of the spring.
  double get stiffness {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    return bindings.cp_damped_rotary_spring_get_stiffness(_native);
  }

  set stiffness(double stiffness) {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    bindings.cp_damped_rotary_spring_set_stiffness(_native, stiffness);
  }

  /// Damping of the spring.
  double get damping {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    return bindings.cp_damped_rotary_spring_get_damping(_native);
  }

  set damping(double damping) {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    bindings.cp_damped_rotary_spring_set_damping(_native, damping);
  }
}

/// A rotary limit joint limits the angular rotation between two bodies.
class RotaryLimitJoint extends Constraint {
  /// Creates a rotary limit joint connecting two bodies.
  factory RotaryLimitJoint(Body a, Body b, double min, double max) {
    final native = bindings.cp_rotary_limit_joint_new(
      a.native,
      b.native,
      min,
      max,
    );
    if (native.address == 0) {
      throw Exception('Failed to create rotary limit joint');
    }
    return RotaryLimitJoint._(native);
  }

  RotaryLimitJoint._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Minimum angle in radians.
  double get min {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    return bindings.cp_rotary_limit_joint_get_min(_native);
  }

  set min(double min) {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    bindings.cp_rotary_limit_joint_set_min(_native, min);
  }

  /// Maximum angle in radians.
  double get max {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    return bindings.cp_rotary_limit_joint_get_max(_native);
  }

  set max(double max) {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    bindings.cp_rotary_limit_joint_set_max(_native, max);
  }
}

/// A ratchet joint is a rotary constraint that acts like a socket wrench.
class RatchetJoint extends Constraint {
  /// Creates a ratchet joint connecting two bodies.
  factory RatchetJoint(Body a, Body b, double phase, double ratchet) {
    final native = bindings.cp_ratchet_joint_new(
      a.native,
      b.native,
      phase,
      ratchet,
    );
    if (native.address == 0) {
      throw Exception('Failed to create ratchet joint');
    }
    return RatchetJoint._(native);
  }

  RatchetJoint._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Current angle in radians.
  double get angle {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    return bindings.cp_ratchet_joint_get_angle(_native);
  }

  set angle(double angle) {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    bindings.cp_ratchet_joint_set_angle(_native, angle);
  }

  /// Phase offset in radians.
  double get phase {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    return bindings.cp_ratchet_joint_get_phase(_native);
  }

  set phase(double phase) {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    bindings.cp_ratchet_joint_set_phase(_native, phase);
  }

  /// Ratchet angle in radians.
  double get ratchet {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    return bindings.cp_ratchet_joint_get_ratchet(_native);
  }

  set ratchet(double ratchet) {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    bindings.cp_ratchet_joint_set_ratchet(_native, ratchet);
  }
}

/// A gear joint keeps the angular velocity ratio of a pair of bodies constant.
class GearJoint extends Constraint {
  /// Creates a gear joint connecting two bodies.
  factory GearJoint(Body a, Body b, double phase, double ratio) {
    final native = bindings.cp_gear_joint_new(
      a.native,
      b.native,
      phase,
      ratio,
    );
    if (native.address == 0) {
      throw Exception('Failed to create gear joint');
    }
    return GearJoint._(native);
  }

  GearJoint._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Phase offset in radians.
  double get phase {
    if (_disposed) throw StateError('GearJoint has been disposed');
    return bindings.cp_gear_joint_get_phase(_native);
  }

  set phase(double phase) {
    if (_disposed) throw StateError('GearJoint has been disposed');
    bindings.cp_gear_joint_set_phase(_native, phase);
  }

  /// Angular velocity ratio.
  double get ratio {
    if (_disposed) throw StateError('GearJoint has been disposed');
    return bindings.cp_gear_joint_get_ratio(_native);
  }

  set ratio(double ratio) {
    if (_disposed) throw StateError('GearJoint has been disposed');
    bindings.cp_gear_joint_set_ratio(_native, ratio);
  }
}

/// A simple motor maintains a constant angular velocity between two bodies.
class SimpleMotor extends Constraint {
  /// Creates a simple motor connecting two bodies.
  factory SimpleMotor(Body a, Body b, double rate) {
    final native = bindings.cp_simple_motor_new(
      a.native,
      b.native,
      rate,
    );
    if (native.address == 0) {
      throw Exception('Failed to create simple motor');
    }
    return SimpleMotor._(native);
  }

  SimpleMotor._(ffi.Pointer<bindings.cpConstraint> native) : super._(native);

  /// Rate of the motor in radians per second.
  double get rate {
    if (_disposed) throw StateError('SimpleMotor has been disposed');
    return bindings.cp_simple_motor_get_rate(_native);
  }

  set rate(double rate) {
    if (_disposed) throw StateError('SimpleMotor has been disposed');
    bindings.cp_simple_motor_set_rate(_native, rate);
  }
}
