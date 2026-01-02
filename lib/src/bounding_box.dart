import 'dart:ffi' as ffi;

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi_bindings_generated.dart' as bindings;
import 'package:chipmunk2d_physics_ffi/src/vector.dart';

/// Chipmunk's axis-aligned 2D bounding box type (left, bottom, right, top).
class BoundingBox {
  /// Left edge of the bounding box.
  final double left;

  /// Bottom edge of the bounding box.
  final double bottom;

  /// Right edge of the bounding box.
  final double right;

  /// Top edge of the bounding box.
  final double top;

  /// Creates a bounding box with the given edges.
  ///
  /// [left] and [bottom] define the bottom-left corner,
  /// [right] and [top] define the top-right corner.
  const BoundingBox({
    required this.left,
    required this.bottom,
    required this.right,
    required this.top,
  });

  /// Creates a bounding box from Chipmunk's cpBB structure.
  factory BoundingBox.fromNative(bindings.cpBB native) {
    return BoundingBox(
      left: native.l,
      bottom: native.b,
      right: native.r,
      top: native.t,
    );
  }

  /// Converts this bounding box to Chipmunk's cpBB structure.
  bindings.cpBB toNative() {
    final bb = ffi.Struct.create<bindings.cpBB>()
      ..l = left
      ..b = bottom
      ..r = right
      ..t = top;
    return bb;
  }

  /// Creates a bounding box centered on a point with the given extents (half sizes).
  factory BoundingBox.forExtents(Vector center, double halfWidth, double halfHeight) {
    return BoundingBox(
      left: center.x - halfWidth,
      bottom: center.y - halfHeight,
      right: center.x + halfWidth,
      top: center.y + halfHeight,
    );
  }

  /// Creates a bounding box for a circle with the given position and radius.
  factory BoundingBox.forCircle(Vector position, double radius) {
    return BoundingBox.forExtents(position, radius, radius);
  }

  /// Returns true if this bounding box intersects with another.
  bool intersects(BoundingBox other) {
    return left <= other.right && other.left <= right && bottom <= other.top && other.bottom <= top;
  }

  /// Returns true if this bounding box completely contains another.
  bool containsBox(BoundingBox other) {
    return left <= other.left && right >= other.right && bottom <= other.bottom && top >= other.top;
  }

  /// Returns true if this bounding box contains a point.
  bool containsPoint(Vector point) {
    return left <= point.x && right >= point.x && bottom <= point.y && top >= point.y;
  }

  /// Returns a bounding box that holds both bounding boxes.
  BoundingBox merge(BoundingBox other) {
    return BoundingBox(
      left: left < other.left ? left : other.left,
      bottom: bottom < other.bottom ? bottom : other.bottom,
      right: right > other.right ? right : other.right,
      top: top > other.top ? top : other.top,
    );
  }

  /// Returns a bounding box expanded to include a point.
  BoundingBox expand(Vector point) {
    return BoundingBox(
      left: left < point.x ? left : point.x,
      bottom: bottom < point.y ? bottom : point.y,
      right: right > point.x ? right : point.x,
      top: top > point.y ? top : point.y,
    );
  }

  /// Returns the center of the bounding box.
  Vector get center {
    return Vector(
      (left + right) / 2,
      (bottom + top) / 2,
    );
  }

  /// Returns the width of the bounding box.
  double get width => right - left;

  /// Returns the height of the bounding box.
  double get height => top - bottom;

  /// Returns the area of the bounding box.
  double get area => width * height;

  @override
  String toString() => 'BoundingBox(left: $left, bottom: $bottom, right: $right, top: $top)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoundingBox && left == other.left && bottom == other.bottom && right == other.right && top == other.top;

  @override
  int get hashCode => Object.hash(left, bottom, right, top);
}
