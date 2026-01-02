/// The type of a physics body.
///
/// Bodies can be one of three types:
/// - [BodyType.dynamic]: Affected by gravity, forces, and collisions (default)
/// - [BodyType.kinematic]: Infinite mass, user controlled, not affected by forces
/// - [BodyType.static]: Never moves, used for ground/walls
enum BodyType {
  /// Dynamic body - affected by gravity, forces, and collisions.
  dynamic(0),

  /// Kinematic body - infinite mass, user controlled, not affected by forces.
  kinematic(1),

  /// Static body - never moves, used for ground/walls.
  static(2)
  ;

  const BodyType(this.value);

  /// Creates a BodyType from a native Chipmunk2D body type value.
  factory BodyType.fromValue(int value) {
    switch (value) {
      case 0:
        return BodyType.dynamic;
      case 1:
        return BodyType.kinematic;
      case 2:
        return BodyType.static;
      default:
        throw ArgumentError('Invalid body type value: $value');
    }
  }

  /// The native Chipmunk2D body type value.
  final int value;
}
