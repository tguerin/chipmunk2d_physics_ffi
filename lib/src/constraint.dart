import 'package:chipmunk2d_physics_ffi/src/body.dart';
import 'package:chipmunk2d_physics_ffi/src/platform/chipmunk_bindings.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Base class for physics constraints (joints).
/// Constraints connect two bodies together and enforce relationships between them.
abstract class Constraint {
  final int _native;
  bool _disposed = false;

  /// Creates a Constraint from a native pointer (for internal use).
  Constraint.fromNative(this._native);

  /// Gets the native pointer (for internal use).
  int get native {
    if (_disposed) throw StateError('Constraint has been disposed');
    return _native;
  }

  /// The maximum force that this constraint is allowed to use.
  /// Defaults to INFINITY.
  double get maxForce {
    if (_disposed) throw StateError('Constraint has been disposed');
    return cpConstraintGetMaxForce(_native);
  }

  set maxForce(double maxForce) {
    if (_disposed) throw StateError('Constraint has been disposed');
    cpConstraintSetMaxForce(_native, maxForce);
  }

  /// Rate at which joint error is corrected.
  double get errorBias {
    if (_disposed) throw StateError('Constraint has been disposed');
    return cpConstraintGetErrorBias(_native);
  }

  set errorBias(double errorBias) {
    if (_disposed) throw StateError('Constraint has been disposed');
    cpConstraintSetErrorBias(_native, errorBias);
  }

  /// Maximum rate at which joint error is corrected.
  double get maxBias {
    if (_disposed) throw StateError('Constraint has been disposed');
    return cpConstraintGetMaxBias(_native);
  }

  set maxBias(double maxBias) {
    if (_disposed) throw StateError('Constraint has been disposed');
    cpConstraintSetMaxBias(_native, maxBias);
  }

  /// Whether the two bodies connected by the constraint are allowed to collide.
  bool get collideBodies {
    if (_disposed) throw StateError('Constraint has been disposed');
    return cpConstraintGetCollideBodies(_native) != 0;
  }

  set collideBodies(bool collideBodies) {
    if (_disposed) throw StateError('Constraint has been disposed');
    cpConstraintSetCollideBodies(_native, collideBodies ? 1 : 0);
  }

  /// The last impulse applied by this constraint.
  double get impulse {
    if (_disposed) throw StateError('Constraint has been disposed');
    return cpConstraintGetImpulse(_native);
  }

  /// The first body the constraint is attached to.
  Body get bodyA {
    if (_disposed) throw StateError('Constraint has been disposed');
    return Body.fromNative(cpConstraintGetBodyA(_native));
  }

  /// The second body the constraint is attached to.
  Body get bodyB {
    if (_disposed) throw StateError('Constraint has been disposed');
    return Body.fromNative(cpConstraintGetBodyB(_native));
  }

  /// Disposes of this constraint and frees its resources.
  void dispose() {
    if (!_disposed) {
      cpConstraintFree(_native);
      _disposed = true;
    }
  }

  Constraint._(this._native);
}

/// A pin joint keeps two anchor points on two bodies at a fixed distance.
class PinJoint extends Constraint {
  /// Creates a pin joint connecting two bodies at specified anchor points.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param anchorA The anchor point on body A in local coordinates.
  /// @param anchorB The anchor point on body B in local coordinates.
  factory PinJoint(Body a, Body b, Vector anchorA, Vector anchorB) {
    final native = cpPinJointNew(a.native, b.native, anchorA.x, anchorA.y, anchorB.x, anchorB.y);
    if (native == 0) throw Exception('Failed to create pin joint');
    return PinJoint._(native);
  }

  PinJoint._(super._native) : super._();

  /// The anchor point on body A in local coordinates.
  Vector get anchorA {
    if (_disposed) throw StateError('PinJoint has been disposed');
    return cpPinJointGetAnchorA(_native);
  }

  /// Sets the anchor point on body A in local coordinates.
  set anchorA(Vector v) {
    if (_disposed) throw StateError('PinJoint has been disposed');
    cpPinJointSetAnchorA(_native, v.x, v.y);
  }

  /// The anchor point on body B in local coordinates.
  Vector get anchorB {
    if (_disposed) throw StateError('PinJoint has been disposed');
    return cpPinJointGetAnchorB(_native);
  }

  /// Sets the anchor point on body B in local coordinates.
  set anchorB(Vector v) {
    if (_disposed) throw StateError('PinJoint has been disposed');
    cpPinJointSetAnchorB(_native, v.x, v.y);
  }

  /// The distance between the two anchor points.
  double get distance {
    if (_disposed) throw StateError('PinJoint has been disposed');
    return cpPinJointGetDist(_native);
  }

  /// Sets the distance between the two anchor points.
  set distance(double dist) {
    if (_disposed) throw StateError('PinJoint has been disposed');
    cpPinJointSetDist(_native, dist);
  }
}

/// A slide joint keeps two anchor points within a distance range.
class SlideJoint extends Constraint {
  /// Creates a slide joint connecting two bodies with a distance range.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param anchorA The anchor point on body A in local coordinates.
  /// @param anchorB The anchor point on body B in local coordinates.
  /// @param min The minimum allowed distance between the anchor points.
  /// @param max The maximum allowed distance between the anchor points.
  factory SlideJoint(Body a, Body b, Vector anchorA, Vector anchorB, double min, double max) {
    final native = cpSlideJointNew(a.native, b.native, anchorA.x, anchorA.y, anchorB.x, anchorB.y, min, max);
    if (native == 0) throw Exception('Failed to create slide joint');
    return SlideJoint._(native);
  }

  SlideJoint._(super._native) : super._();

  /// The anchor point on body A in local coordinates.
  Vector get anchorA {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return cpSlideJointGetAnchorA(_native);
  }

  /// Sets the anchor point on body A in local coordinates.
  set anchorA(Vector v) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    cpSlideJointSetAnchorA(_native, v.x, v.y);
  }

  /// The anchor point on body B in local coordinates.
  Vector get anchorB {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return cpSlideJointGetAnchorB(_native);
  }

  /// Sets the anchor point on body B in local coordinates.
  set anchorB(Vector v) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    cpSlideJointSetAnchorB(_native, v.x, v.y);
  }

  /// The minimum allowed distance between the anchor points.
  double get min {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return cpSlideJointGetMin(_native);
  }

  /// Sets the minimum allowed distance between the anchor points.
  set min(double min) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    cpSlideJointSetMin(_native, min);
  }

  /// The maximum allowed distance between the anchor points.
  double get max {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    return cpSlideJointGetMax(_native);
  }

  /// Sets the maximum allowed distance between the anchor points.
  set max(double max) {
    if (_disposed) throw StateError('SlideJoint has been disposed');
    cpSlideJointSetMax(_native, max);
  }
}

/// A pivot joint keeps two anchor points at the same location.
class PivotJoint extends Constraint {
  /// Creates a pivot joint at a world point.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param pivot The pivot point in world coordinates.
  factory PivotJoint.atWorldPoint(Body a, Body b, Vector pivot) {
    final native = cpPivotJointNew(a.native, b.native, pivot.x, pivot.y);
    if (native == 0) throw Exception('Failed to create pivot joint');
    return PivotJoint._(native);
  }

  /// Creates a pivot joint at local points on each body.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param anchorA The anchor point on body A in local coordinates.
  /// @param anchorB The anchor point on body B in local coordinates.
  factory PivotJoint.atLocalPoints(Body a, Body b, Vector anchorA, Vector anchorB) {
    final native = cpPivotJointNew2(a.native, b.native, anchorA.x, anchorA.y, anchorB.x, anchorB.y);
    if (native == 0) throw Exception('Failed to create pivot joint');
    return PivotJoint._(native);
  }

  PivotJoint._(super._native) : super._();

  /// The anchor point on body A in local coordinates.
  Vector get anchorA {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    return cpPivotJointGetAnchorA(_native);
  }

  /// Sets the anchor point on body A in local coordinates.
  set anchorA(Vector v) {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    cpPivotJointSetAnchorA(_native, v.x, v.y);
  }

  /// The anchor point on body B in local coordinates.
  Vector get anchorB {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    return cpPivotJointGetAnchorB(_native);
  }

  /// Sets the anchor point on body B in local coordinates.
  set anchorB(Vector v) {
    if (_disposed) throw StateError('PivotJoint has been disposed');
    cpPivotJointSetAnchorB(_native, v.x, v.y);
  }
}

/// A groove joint constrains a pivot to a groove.
class GrooveJoint extends Constraint {
  /// Creates a groove joint that constrains a pivot to a groove.
  ///
  /// @param a The first body (with the groove).
  /// @param b The second body (with the pivot).
  /// @param grooveA The start point of the groove on body A in local coordinates.
  /// @param grooveB The end point of the groove on body A in local coordinates.
  /// @param anchorB The anchor point on body B in local coordinates.
  factory GrooveJoint(Body a, Body b, Vector grooveA, Vector grooveB, Vector anchorB) {
    final native = cpGrooveJointNew(
      a.native,
      b.native,
      grooveA.x,
      grooveA.y,
      grooveB.x,
      grooveB.y,
      anchorB.x,
      anchorB.y,
    );
    if (native == 0) throw Exception('Failed to create groove joint');
    return GrooveJoint._(native);
  }

  GrooveJoint._(super._native) : super._();

  /// The start point of the groove on body A in local coordinates.
  Vector get grooveA {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    return cpGrooveJointGetGrooveA(_native);
  }

  /// Sets the start point of the groove on body A in local coordinates.
  set grooveA(Vector v) {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    cpGrooveJointSetGrooveA(_native, v.x, v.y);
  }

  /// The end point of the groove on body A in local coordinates.
  Vector get grooveB {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    return cpGrooveJointGetGrooveB(_native);
  }

  /// Sets the end point of the groove on body A in local coordinates.
  set grooveB(Vector v) {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    cpGrooveJointSetGrooveB(_native, v.x, v.y);
  }

  /// The anchor point on body B in local coordinates.
  Vector get anchorB {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    return cpGrooveJointGetAnchorB(_native);
  }

  /// Sets the anchor point on body B in local coordinates.
  set anchorB(Vector v) {
    if (_disposed) throw StateError('GrooveJoint has been disposed');
    cpGrooveJointSetAnchorB(_native, v.x, v.y);
  }
}

/// A damped spring connects two bodies with spring force.
class DampedSpring extends Constraint {
  /// Creates a damped spring connecting two bodies.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param anchorA The anchor point on body A in local coordinates.
  /// @param anchorB The anchor point on body B in local coordinates.
  /// @param restLength The rest length of the spring.
  /// @param stiffness The spring stiffness (force per unit length).
  /// @param damping The damping coefficient.
  factory DampedSpring(
    Body a,
    Body b,
    Vector anchorA,
    Vector anchorB,
    double restLength,
    double stiffness,
    double damping,
  ) {
    final native = cpDampedSpringNew(
      a.native,
      b.native,
      anchorA.x,
      anchorA.y,
      anchorB.x,
      anchorB.y,
      restLength,
      stiffness,
      damping,
    );
    if (native == 0) throw Exception('Failed to create damped spring');
    return DampedSpring._(native);
  }

  DampedSpring._(super._native) : super._();

  /// The anchor point on body A in local coordinates.
  Vector get anchorA {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return cpDampedSpringGetAnchorA(_native);
  }

  /// Sets the anchor point on body A in local coordinates.
  set anchorA(Vector v) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    cpDampedSpringSetAnchorA(_native, v.x, v.y);
  }

  /// The anchor point on body B in local coordinates.
  Vector get anchorB {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return cpDampedSpringGetAnchorB(_native);
  }

  /// Sets the anchor point on body B in local coordinates.
  set anchorB(Vector v) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    cpDampedSpringSetAnchorB(_native, v.x, v.y);
  }

  /// The rest length of the spring.
  double get restLength {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return cpDampedSpringGetRestLength(_native);
  }

  /// Sets the rest length of the spring.
  set restLength(double v) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    cpDampedSpringSetRestLength(_native, v);
  }

  /// The spring stiffness (force per unit length).
  double get stiffness {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return cpDampedSpringGetStiffness(_native);
  }

  /// Sets the spring stiffness (force per unit length).
  set stiffness(double v) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    cpDampedSpringSetStiffness(_native, v);
  }

  /// The damping coefficient.
  double get damping {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    return cpDampedSpringGetDamping(_native);
  }

  /// Sets the damping coefficient.
  set damping(double v) {
    if (_disposed) throw StateError('DampedSpring has been disposed');
    cpDampedSpringSetDamping(_native, v);
  }
}

/// A damped rotary spring connects two bodies with rotational spring force.
class DampedRotarySpring extends Constraint {
  /// Creates a damped rotary spring connecting two bodies.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param restAngle The rest angle of the spring in radians.
  /// @param stiffness The spring stiffness (torque per radian).
  /// @param damping The damping coefficient.
  factory DampedRotarySpring(Body a, Body b, double restAngle, double stiffness, double damping) {
    final native = cpDampedRotarySpringNew(a.native, b.native, restAngle, stiffness, damping);
    if (native == 0) throw Exception('Failed to create damped rotary spring');
    return DampedRotarySpring._(native);
  }

  DampedRotarySpring._(super._native) : super._();

  /// The rest angle of the spring in radians.
  double get restAngle {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    return cpDampedRotarySpringGetRestAngle(_native);
  }

  /// Sets the rest angle of the spring in radians.
  set restAngle(double v) {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    cpDampedRotarySpringSetRestAngle(_native, v);
  }

  /// The spring stiffness (torque per radian).
  double get stiffness {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    return cpDampedRotarySpringGetStiffness(_native);
  }

  /// Sets the spring stiffness (torque per radian).
  set stiffness(double v) {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    cpDampedRotarySpringSetStiffness(_native, v);
  }

  /// The damping coefficient.
  double get damping {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    return cpDampedRotarySpringGetDamping(_native);
  }

  /// Sets the damping coefficient.
  set damping(double v) {
    if (_disposed) throw StateError('DampedRotarySpring has been disposed');
    cpDampedRotarySpringSetDamping(_native, v);
  }
}

/// A rotary limit joint limits the angular rotation between two bodies.
class RotaryLimitJoint extends Constraint {
  /// Creates a rotary limit joint that limits angular rotation.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param min The minimum allowed angle in radians.
  /// @param max The maximum allowed angle in radians.
  factory RotaryLimitJoint(Body a, Body b, double min, double max) {
    final native = cpRotaryLimitJointNew(a.native, b.native, min, max);
    if (native == 0) throw Exception('Failed to create rotary limit joint');
    return RotaryLimitJoint._(native);
  }

  RotaryLimitJoint._(super._native) : super._();

  /// The minimum allowed angle in radians.
  double get min {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    return cpRotaryLimitJointGetMin(_native);
  }

  /// Sets the minimum allowed angle in radians.
  set min(double v) {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    cpRotaryLimitJointSetMin(_native, v);
  }

  /// The maximum allowed angle in radians.
  double get max {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    return cpRotaryLimitJointGetMax(_native);
  }

  /// Sets the maximum allowed angle in radians.
  set max(double v) {
    if (_disposed) throw StateError('RotaryLimitJoint has been disposed');
    cpRotaryLimitJointSetMax(_native, v);
  }
}

/// A ratchet joint is a rotary constraint that acts like a socket wrench.
class RatchetJoint extends Constraint {
  /// Creates a ratchet joint connecting two bodies.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param phase The initial phase offset in radians.
  /// @param ratchet The ratchet angle in radians (the "click" size).
  factory RatchetJoint(Body a, Body b, double phase, double ratchet) {
    final native = cpRatchetJointNew(a.native, b.native, phase, ratchet);
    if (native == 0) throw Exception('Failed to create ratchet joint');
    return RatchetJoint._(native);
  }

  RatchetJoint._(super._native) : super._();

  /// The current angle in radians.
  double get angle {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    return cpRatchetJointGetAngle(_native);
  }

  /// Sets the current angle in radians.
  set angle(double v) {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    cpRatchetJointSetAngle(_native, v);
  }

  /// The phase offset in radians.
  double get phase {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    return cpRatchetJointGetPhase(_native);
  }

  /// Sets the phase offset in radians.
  set phase(double v) {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    cpRatchetJointSetPhase(_native, v);
  }

  /// The ratchet angle in radians (the "click" size).
  double get ratchet {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    return cpRatchetJointGetRatchet(_native);
  }

  /// Sets the ratchet angle in radians (the "click" size).
  set ratchet(double v) {
    if (_disposed) throw StateError('RatchetJoint has been disposed');
    cpRatchetJointSetRatchet(_native, v);
  }
}

/// A gear joint keeps the angular velocity ratio of two bodies constant.
class GearJoint extends Constraint {
  /// Creates a gear joint connecting two bodies.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param phase The initial phase offset in radians.
  /// @param ratio The gear ratio (angular velocity of body B / angular velocity of body A).
  factory GearJoint(Body a, Body b, double phase, double ratio) {
    final native = cpGearJointNew(a.native, b.native, phase, ratio);
    if (native == 0) throw Exception('Failed to create gear joint');
    return GearJoint._(native);
  }

  GearJoint._(super._native) : super._();

  /// The phase offset in radians.
  double get phase {
    if (_disposed) throw StateError('GearJoint has been disposed');
    return cpGearJointGetPhase(_native);
  }

  /// Sets the phase offset in radians.
  set phase(double v) {
    if (_disposed) throw StateError('GearJoint has been disposed');
    cpGearJointSetPhase(_native, v);
  }

  /// The gear ratio (angular velocity of body B / angular velocity of body A).
  double get ratio {
    if (_disposed) throw StateError('GearJoint has been disposed');
    return cpGearJointGetRatio(_native);
  }

  /// Sets the gear ratio (angular velocity of body B / angular velocity of body A).
  set ratio(double v) {
    if (_disposed) throw StateError('GearJoint has been disposed');
    cpGearJointSetRatio(_native, v);
  }
}

/// A simple motor maintains a constant angular velocity between two bodies.
class SimpleMotor extends Constraint {
  /// Creates a simple motor connecting two bodies.
  ///
  /// @param a The first body.
  /// @param b The second body.
  /// @param rate The target relative angular velocity in radians per second.
  factory SimpleMotor(Body a, Body b, double rate) {
    final native = cpSimpleMotorNew(a.native, b.native, rate);
    if (native == 0) throw Exception('Failed to create simple motor');
    return SimpleMotor._(native);
  }

  SimpleMotor._(super._native) : super._();

  /// The target relative angular velocity in radians per second.
  double get rate {
    if (_disposed) throw StateError('SimpleMotor has been disposed');
    return cpSimpleMotorGetRate(_native);
  }

  /// Sets the target relative angular velocity in radians per second.
  set rate(double v) {
    if (_disposed) throw StateError('SimpleMotor has been disposed');
    cpSimpleMotorSetRate(_native, v);
  }
}
