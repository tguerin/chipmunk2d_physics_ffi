import 'dart:ffi' as ffi;
import 'dart:math' as math;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;

/// A 2D vector representing a point or direction in space.
class Vector {
  /// The x component of the vector.
  final double x;

  /// The y component of the vector.
  final double y;

  /// Creates a vector with the given x and y components.
  const Vector(this.x, this.y);

  /// Creates a vector from Chipmunk2D's cpVect structure.
  @pragma('vm:prefer-inline')
  factory Vector.fromNative(bindings.cpVect native) {
    // Access struct fields directly - no FFI call needed
    return Vector(native.x, native.y);
  }

  /// Converts this vector to Chipmunk2D's cpVect structure.
  @pragma('vm:prefer-inline')
  bindings.cpVect toNative() {
    // Create struct directly in Dart - no FFI call needed
    final vect = ffi.Struct.create<bindings.cpVect>()
      ..x = x
      ..y = y;
    return vect;
  }

  /// Zero vector (0, 0).
  static const Vector zero = Vector(0, 0);

  /// Vector addition.
  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);

  /// Vector subtraction.
  Vector operator -(Vector other) => Vector(x - other.x, y - other.y);

  /// Scalar multiplication.
  Vector operator *(double scalar) => Vector(x * scalar, y * scalar);

  /// Scalar division.
  Vector operator /(double scalar) => Vector(x / scalar, y / scalar);

  /// Negation.
  Vector operator -() => Vector(-x, -y);

  /// Dot product.
  ///
  /// Returns the dot product of this vector and [other].
  double dot(Vector other) => x * other.x + y * other.y;

  /// Cross product (returns scalar in 2D).
  ///
  /// Returns the cross product of this vector and [other].
  /// In 2D, this returns the magnitude of the z component.
  double cross(Vector other) => x * other.y - y * other.x;

  /// Length (magnitude) of the vector.
  double get length => math.sqrt(x * x + y * y);

  /// Squared length (faster than length, useful for comparisons).
  double get lengthSquared => x * x + y * y;

  /// Normalized vector (unit vector in the same direction).
  Vector get normalized {
    final len = length;
    return len > 0 ? Vector(x / len, y / len) : Vector.zero;
  }

  @override
  String toString() => 'Vector($x, $y)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}
