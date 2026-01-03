# chipmunk2d_physics_ffi

A comprehensive Dart FFI binding for [Chipmunk2D](https://chipmunk-physics.net/)
physics engine version 7.0.3. This package provides a complete, idiomatic Dart
API for 2D physics simulation in Flutter and Dart applications.

## Features

- **Complete API Coverage**: 1-1 API compliance with Chipmunk2D 7.0.3
- **Idiomatic Dart API**: Clean, object-oriented wrapper around Chipmunk's C API
  with type-safe enums and helper methods
- **Full Feature Set**:
  - Dynamic, kinematic, and static bodies
  - Circle, box, segment, and polygon shapes
  - 10 joint types (Pin, Slide, Pivot, Groove, Springs, Rotary, Ratchet, Gear,
    Motor)
  - Collision detection and filtering with helper methods
  - Spatial queries (point, segment, bounding box) with typed result classes
  - Sleeping and activation system
  - Force and impulse application
  - Moment of inertia and area calculations
- **Cross-Platform**: Supports iOS, Android, macOS, Linux, Windows, and Web
- **Performance**: Direct FFI bindings with minimal overhead

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  chipmunk2d_physics_ffi: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';

void main() async {
  // On web, initialize Chipmunk2D before use (no-op on native platforms)
  WidgetsFlutterBinding.ensureInitialized();
  await initializeChipmunk();
  
  // Create a physics space
  final space = Space();
  space.gravity = Vector(0, -100); // Gravity pointing down

  // Create a dynamic body
  final body = Body.dynamic(1.0, 1.0); // mass, moment
  body.position = Vector(0, 100);

  // Create a circle shape
  final shape = CircleShape(body, 10.0); // radius
  shape.friction = 0.7;
  shape.elasticity = 0.5;

  // Add to space
  space.addBody(body);
  space.addShape(shape);

  // Create a static ground
  final ground = space.staticBody;
  final groundShape = BoxShape(ground, 1000, 20);
  space.addShape(groundShape);

  // Simulate
  for (var i = 0; i < 60; i++) {
    space.step(1.0 / 60.0); // 60 FPS
    print('Body position: ${body.position}');
  }

  // Cleanup
  shape.dispose();
  body.dispose();
  space.dispose();
}
```

## Core Concepts

### Space

The `Space` is the simulation container. It manages all bodies, shapes, and
constraints, and steps the simulation forward in time.

```dart
final space = Space();
space.gravity = Vector(0, -100);
space.iterations = 10; // Solver iterations
space.damping = 0.9; // Global damping
space.step(1.0 / 60.0); // Step simulation
```

### Body

A `Body` represents a rigid body in the simulation. Bodies can be:

- **Dynamic**: Affected by forces, gravity, and collisions
- **Kinematic**: User-controlled, not affected by forces
- **Static**: Immovable, used for ground/walls

```dart
// Dynamic body
final body = Body.dynamic(1.0, 1.0); // mass, moment
body.position = Vector(0, 0);
body.velocity = Vector(10, 0);
body.angle = 0.5; // radians

// Apply forces
body.applyForceAtWorldPoint(Vector(0, -100), body.position);
body.applyImpulseAtWorldPoint(Vector(10, 0), body.position);

// Coordinate conversion
final worldPoint = body.localToWorld(Vector(5, 0));
final localPoint = body.worldToLocal(worldPoint);
```

### Shape

Shapes define the collision geometry of bodies. Supported shape types:

- **CircleShape**: Perfect for balls, wheels, etc.
- **BoxShape**: Rectangles with optional rounded corners
- **SegmentShape**: Line segments for walls, platforms
- **PolyShape**: Convex polygons for complex shapes

```dart
// Circle
final circle = CircleShape(body, 10.0, offset: Vector(0, 0));
circle.friction = 0.7;
circle.elasticity = 0.5;
circle.sensor = false; // Set to true for trigger zones

// Box
final box = BoxShape(body, 50, 30, radius: 2.0); // width, height, corner radius

// Segment (line)
final segment = SegmentShape(body, Vector(0, 0), Vector(100, 0), 2.0);

// Polygon
final vertices = [
  Vector(0, 0),
  Vector(50, 0),
  Vector(50, 30),
  Vector(0, 30),
];
final poly = PolyShape(body, vertices, radius: 1.0);
```

### Constraints (Joints)

Constraints connect two bodies together. Available joint types:

- **PinJoint**: Fixed distance between two anchor points
- **SlideJoint**: Distance constrained to min/max range
- **PivotJoint**: Bodies pivot around a common point
- **GrooveJoint**: Pivot constrained to a groove
- **DampedSpring**: Spring with damping
- **DampedRotarySpring**: Rotational spring
- **RotaryLimitJoint**: Limits angular rotation
- **RatchetJoint**: One-way rotational constraint
- **GearJoint**: Synchronized rotation
- **SimpleMotor**: Constant velocity rotation

```dart
// Pin joint
final joint = PinJoint(bodyA, bodyB, anchorA, anchorB);
joint.distance = 50.0;
space.addConstraint(joint);

// Spring
final spring = DampedSpring(
  bodyA, bodyB,
  anchorA, anchorB,
  100.0, // rest length
  1000.0, // stiffness
  10.0, // damping
);
space.addConstraint(spring);
```

## API Overview

### Body API

```dart
// Properties
body.position        // Vector
body.velocity        // Vector
body.angle           // double (radians)
body.angularVelocity // double (radians/sec)
body.mass            // double
body.moment          // double
body.centerOfGravity // Vector
body.force           // Vector
body.torque          // double
body.rotation        // Vector
body.type            // BodyType (BodyType.dynamic, BodyType.kinematic, BodyType.static)
body.isSleeping      // bool

// Methods
body.activate()
body.sleep()
body.localToWorld(Vector)
body.worldToLocal(Vector)
body.applyForceAtWorldPoint(Vector force, Vector point)
body.applyImpulseAtWorldPoint(Vector impulse, Vector point)
body.getVelocityAtWorldPoint(Vector point)
```

### Shape API

```dart
// Properties
shape.friction          // double
shape.elasticity        // double
shape.filter            // ShapeFilter
shape.mass              // double
shape.density           // double
shape.moment            // double
shape.area              // double
shape.centerOfGravity   // Vector
shape.boundingBox       // BoundingBox
shape.sensor            // bool
shape.surfaceVelocity   // Vector
shape.collisionType     // int
shape.body              // Body?

// Collision Filtering
final filter = ShapeFilter.all(); // Collide with everything (default)
final filter = ShapeFilter.none(); // Collide with nothing
final filter = ShapeFilter.category(0x1); // Only collide with category 1
final filter = ShapeFilter.excludeCategory(0x2); // Collide with all except category 2
final filter = ShapeFilter.group(1); // Group that doesn't collide with itself

// CircleShape specific
circle.offset  // Vector
circle.radius // double

// SegmentShape specific
segment.endpointA  // Vector
segment.endpointB  // Vector
segment.normal     // Vector
segment.radius     // double
segment.setNeighbors(Vector prev, Vector next)

// PolyShape specific
poly.vertexCount      // int
poly.getVertex(int)   // Vector
poly.radius           // double
```

### Space API

```dart
// Properties
space.gravity                // Vector
space.iterations             // int
space.damping                // double
space.idleSpeedThreshold     // double
space.sleepTimeThreshold     // double
space.collisionSlop          // double
space.collisionBias          // double
space.collisionPersistence   // int
space.currentTimeStep        // double
space.isLocked               // bool
space.staticBody             // Body

// Methods
space.addBody(Body)
space.removeBody(Body)
space.addShape(Shape)
space.removeShape(Shape)
space.addConstraint(Constraint)
space.removeConstraint(Constraint)
space.containsBody(Body)     // bool
space.containsShape(Shape)   // bool
space.containsConstraint(Constraint) // bool
space.step(double dt)
space.reindexStatic()
space.reindexShape(Shape)
space.reindexShapesForBody(Body)
```

### Query Information

The library provides Dart classes for query results:

```dart
// Point query information
final info = PointQueryInfo(
  point: Vector(10, 20),
  distance: 5.0,
  gradient: Vector(1, 0),
  shape: shape, // optional
);

// Segment query information
final segInfo = SegmentQueryInfo(
  point: Vector(15, 25),
  normal: Vector(0, 1),
  alpha: 0.5,
  shape: shape, // optional
);
```

## Utility Functions

### Moment Calculations

```dart
import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart';

// Calculate moment of inertia
final moment = momentForCircle(1.0, 0.0, 10.0, Vector.zero);
final boxMoment = momentForBox(1.0, 50.0, 30.0);
final polyMoment = momentForPoly(1.0, vertices, Vector.zero, 0.0);

// Calculate areas
final area = areaForCircle(0.0, 10.0);
final segmentArea = areaForSegment(Vector(0, 0), Vector(100, 0), 2.0);

// Calculate centroid
final centroid = centroidForPoly(vertices);

// Convex hull
final hull = convexHull(points, tolerance: 0.0);
```

### Bounding Box

```dart
final bb = BoundingBox(
  left: -10,
  bottom: -10,
  right: 10,
  top: 10,
);

// Or create from extents
final bb2 = BoundingBox.forExtents(Vector(0, 0), 10, 10);
final bb3 = BoundingBox.forCircle(Vector(0, 0), 10);

// Operations
bb.intersects(other);
bb.containsPoint(Vector(5, 5));
bb.merge(other);
bb.expand(Vector(15, 15));
```

## Performance Tips

1. **Use fast getters**: For hot loops, use `positionX`/`positionY` instead of
   `position` to avoid Vector allocation
2. **Batch operations**: Add/remove multiple objects before stepping
3. **Sleeping**: Enable sleeping for inactive bodies to improve performance
4. **Spatial queries**: Use spatial queries efficiently - they're fast but avoid
   calling them every frame for many objects
5. **Reindexing**: Only call `reindexStatic()` when you actually move static
   shapes

## Platform Support

This package supports:

- ✅ iOS
- ✅ Android
- ✅ macOS
- ✅ Linux
- ✅ Windows
- ✅ Web

### Web Support

On web, you **must** call `initializeChipmunk()` before using any Chipmunk2D
functions:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Required on web, no-op on native platforms
  await initializeChipmunk();
  
  runApp(MyApp());
}
```

The WASM module is automatically included in your Flutter web build - no
additional setup required!

## Chipmunk2D Version

This package is built against **Chipmunk2D 7.0.3**. For API documentation and
examples, refer to the
[official Chipmunk2D documentation](https://chipmunk-physics.net/documentation.php).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is licensed under the MIT License, matching Chipmunk2D's license.

## Links

- [Chipmunk2D Official Site](https://chipmunk-physics.net/)
- [Chipmunk2D Documentation](https://chipmunk-physics.net/documentation.php)
- [Package on pub.dev](https://pub.dev/packages/chipmunk2d_physics_ffi)
