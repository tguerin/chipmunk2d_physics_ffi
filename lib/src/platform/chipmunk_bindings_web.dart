/// Web (JS interop) implementation of Chipmunk2D bindings.
///
/// Uses dart:js_interop to call Emscripten-compiled WASM module.
/// The Emscripten module (JS + WASM) is automatically loaded from the package's assets.
library;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:chipmunk2d_physics_ffi/src/bounding_box.dart';
import 'package:chipmunk2d_physics_ffi/src/shape.dart';
import 'package:chipmunk2d_physics_ffi/src/vector.dart';
import 'package:web/web.dart' as web;

// ============================================================================
// WASM Module Instance
// ============================================================================

/// Direct WASM exports (pure WASM, no wrapper).
JSObject? _wasmExports;

/// WASM memory instance (for direct memory access).
JSObject? _wasmMemory;

// ============================================================================
// Function Wrappers
// ============================================================================

/// Cache for functions to avoid repeated lookups.
final Map<String, JSFunction> _functionCache = {};

/// Get a function from WASM exports.
JSFunction _getFunction(String name) {
  return _functionCache.putIfAbsent(name, () {
    _ensureInitialized();
    final fn = _wasmExports!.getProperty(name.toJS) as JSFunction?;
    if (fn == null) {
      throw StateError('WASM function "$name" not found in exports');
    }
    return fn;
  });
}

/// Helper to call a function and get an int result.
int _callInt(String name, List<JSAny?> args) {
  final fn = _getFunction(name);
  final result = _callWithArgs(fn, args);
  return (result! as JSNumber).toDartInt;
}

/// Helper to call a function and get a double result.
double _callDouble(String name, List<JSAny?> args) {
  final fn = _getFunction(name);
  final result = _callWithArgs(fn, args);
  return (result! as JSNumber).toDartDouble;
}

/// Helper to call a void function.
void _callVoid(String name, List<JSAny?> args) {
  final fn = _getFunction(name);
  _callWithArgs(fn, args);
}

/// Helper to call a function with a list of arguments.
JSAny? _callWithArgs(JSFunction fn, List<JSAny?> args) {
  final applyFn = (fn as JSObject).getProperty('apply'.toJS)! as JSFunction;
  return applyFn.callAsFunction(fn, null, args.toJS);
}

// ============================================================================
// Memory Access Helpers
// ============================================================================

/// Allocate memory in WASM heap.
int _malloc(int size) {
  _ensureInitialized();
  // Try malloc first, then _malloc (common WASM export patterns)
  final mallocFn = _wasmExports!.getProperty('malloc'.toJS) as JSFunction?;
  if (mallocFn != null) {
    return (mallocFn.callAsFunction(null, size.toJS)! as JSNumber).toDartInt;
  }
  final mallocFn2 = _wasmExports!.getProperty('_malloc'.toJS) as JSFunction?;
  if (mallocFn2 != null) {
    return (mallocFn2.callAsFunction(null, size.toJS)! as JSNumber).toDartInt;
  }
  throw StateError('malloc or _malloc not found in WASM exports');
}

/// Free memory in WASM heap.
void _free(int ptr) {
  _ensureInitialized();
  // Try free first, then _free
  final freeFn = _wasmExports!.getProperty('free'.toJS) as JSFunction?;
  if (freeFn != null) {
    freeFn.callAsFunction(null, ptr.toJS);
    return;
  }
  final freeFn2 = _wasmExports!.getProperty('_free'.toJS) as JSFunction?;
  if (freeFn2 != null) {
    freeFn2.callAsFunction(null, ptr.toJS);
    return;
  }
  throw StateError('free or _free not found in WASM exports');
}

/// Get a double value from WASM heap.
double _getDouble(int ptr) {
  _ensureInitialized();
  final buffer = _wasmMemory!.getProperty('buffer'.toJS) as JSObject?;
  if (buffer == null) {
    throw StateError('WASM memory buffer not available');
  }
  final Float64ArrayConstructor = web.window.getProperty('Float64Array'.toJS) as JSFunction?;
  if (Float64ArrayConstructor == null) {
    throw StateError('Float64Array constructor not available');
  }
  final array =
      Float64ArrayConstructor.callAsConstructor(
            buffer,
            ptr.toJS,
            1.toJS,
          )
          as JSObject?;
  if (array == null) {
    throw StateError('Failed to create Float64Array view');
  }
  final value = array.getProperty('0'.toJS);
  if (value is! JSNumber) {
    throw StateError('Failed to read double value from memory');
  }
  return value.toDartDouble;
}

/// Set a double value in WASM heap.
void _setDouble(int ptr, double value) {
  _ensureInitialized();
  final buffer = _wasmMemory!.getProperty('buffer'.toJS) as JSObject?;
  if (buffer == null) {
    throw StateError('WASM memory buffer not available');
  }
  final Float64ArrayConstructor = web.window.getProperty('Float64Array'.toJS) as JSFunction?;
  if (Float64ArrayConstructor == null) {
    throw StateError('Float64Array constructor not available');
  }
  final array =
      Float64ArrayConstructor.callAsConstructor(
            buffer,
            ptr.toJS,
            1.toJS,
          )
          as JSObject?;
  if (array == null) {
    throw StateError('Failed to create Float64Array view');
  }
  array.setProperty('0'.toJS, value.toJS);
}

/// Get an integer value from WASM heap (as 64-bit integer).
int _getInt(int ptr) {
  _ensureInitialized();
  final buffer = _wasmMemory!.getProperty('buffer'.toJS) as JSObject?;
  if (buffer == null) {
    throw StateError('WASM memory buffer not available');
  }
  // Use Int32Array for integers (most common case)
  final Int32ArrayConstructor = web.window.getProperty('Int32Array'.toJS) as JSFunction?;
  if (Int32ArrayConstructor != null) {
    final array =
        Int32ArrayConstructor.callAsConstructor(
              buffer,
              ptr.toJS,
              1.toJS,
            )
            as JSObject?;
    if (array != null) {
      final value = array.getProperty('0'.toJS);
      if (value is JSNumber) {
        return value.toDartInt;
      }
    }
  }
  throw StateError('Failed to read integer value from memory');
}

// ============================================================================
// Initialization
// ============================================================================

bool _initialized = false;
Completer<void>? _initCompleter;

/// The standard format for package assets on web is:
/// "packages/`<package_name>`/`<path_to_file_relative_to_package_root>`"
const _defaultJsPath = 'assets/packages/chipmunk2d_physics_ffi/assets/web/chipmunk2d_physics_ffi.js';

/// Internal initialization function for Emscripten module loading.
Future<void> _doInitialize() async {
  if (_initialized) return;
  if (_initCompleter != null) {
    return _initCompleter!.future;
  }

  _initCompleter = Completer<void>();

  try {
    // Emscripten generates a JS module that exports a default factory function
    // The factory function returns a Promise that resolves to the module instance
    final dynamicImportFn = web.window.getProperty('_dynamicImport'.toJS) as JSFunction?;
    if (dynamicImportFn == null) {
      throw StateError(
        '_dynamicImport is not available. '
        'Make sure your web/index.html includes the _dynamicImport helper script.',
      );
    }

    // Use dynamic import to load the Emscripten JS module
    final modulePromise = dynamicImportFn.callAsFunction(null, _defaultJsPath.toJS);
    final moduleNamespace = await (modulePromise as JSPromise).toDart;

    // Emscripten modules export a default function that creates the module instance
    final defaultExport = (moduleNamespace as JSObject).getProperty('default'.toJS);
    if (defaultExport == null) {
      throw StateError('Emscripten module does not export a default function');
    }

    // Call the default export (factory function) to get the module instance
    final factoryFn = defaultExport as JSFunction;
    final modulePromise2 = factoryFn.callAsFunction(null);
    final module = await (modulePromise2 as JSPromise).toDart;

    // The module object contains all exports (functions, memory, etc.)
    final moduleObj = module as JSObject;

    // Store the module as exports (Emscripten exports everything on the module object)
    _wasmExports = moduleObj;

    // Get the WebAssembly.Memory instance
    _wasmMemory = moduleObj.getProperty('memory'.toJS) as JSObject?;
    if (_wasmMemory == null) {
      // Some Emscripten builds use HEAP8.buffer instead
      final heap8 = moduleObj.getProperty('HEAP8'.toJS) as JSObject?;
      if (heap8 != null) {
        final buffer = heap8.getProperty('buffer'.toJS);
        if (buffer != null) {
          // Create a memory-like object for compatibility
          _wasmMemory = JSObject()..setProperty('buffer'.toJS, buffer);
        }
      }
    }

    if (_wasmMemory == null) {
      throw StateError('Emscripten module does not export memory or HEAP8');
    }

    _initialized = true;
    _initCompleter!.complete();
  } catch (e) {
    _initCompleter!.completeError(e);
    _initCompleter = null;
    rethrow;
  }
}

/// Initialize the Chipmunk2D bindings.
///
/// **On web, this must be called before using any Chipmunk2D functions.**
/// On native platforms, this is a no-op.
///
/// Example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await initializeChipmunk(); // Required on web
///   runApp(MyApp());
/// }
/// ```
Future<void> initializeChipmunk() async {
  if (_initialized) return;
  await _doInitialize();
}

/// Whether the bindings have been initialized.
bool get isChipmunkInitialized => _initialized;

/// Ensure the module is initialized before use.
/// Throws if not initialized.
void _ensureInitialized() {
  if (!_initialized) {
    throw StateError(
      'Chipmunk2D is not initialized. '
      'Call await initializeChipmunk() before using any Chipmunk2D functions.',
    );
  }
}

// ============================================================================
// Vector Helpers
// ============================================================================

/// Allocate a cpVect and write x,y values. Returns pointer.
int _allocVect(double x, double y) {
  final ptr = _malloc(16); // 2 doubles = 16 bytes
  _setDouble(ptr, x);
  _setDouble(ptr + 8, y);
  return ptr;
}

/// Read x,y from a cpVect pointer.
Vector _readVect(int ptr) {
  return Vector(_getDouble(ptr), _getDouble(ptr + 8));
}

// ============================================================================
// Space Functions
// ============================================================================

/// Allocate and initialize a cpSpace.
/// Returns a pointer to the new space.
int cpSpaceNew() {
  _ensureInitialized();
  return _callInt('_cp_space_new', []);
}

/// Free a space and all its bodies, shapes and constraints.
/// @param space The space to free.
void cpSpaceFree(int space) => _callVoid('_cp_space_free', [space.toJS]);

/// Step the space forward in time by dt.
/// @param space The space to step.
/// @param dt The time step.
void cpSpaceStep(int space, double dt) => _callVoid('_cp_space_step', [space.toJS, dt.toJS]);

/// Set the gravity vector for the space.
/// @param space The space.
/// @param x The x component of gravity.
/// @param y The y component of gravity.
void cpSpaceSetGravity(int space, double x, double y) {
  // Allocate cpVect on stack, call function, then we need to handle struct passing
  // For Emscripten, structs are passed by pointer, so we allocate and pass
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_space_set_gravity', [space.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the gravity vector for the space.
/// @param space The space.
/// @return A tuple of (x, y) gravity components.
Vector cpSpaceGetGravity(int space) {
  // For return structs, Emscripten uses a hidden first parameter for the return value
  final resultPtr = _malloc(16);
  _callVoid('_cp_space_get_gravity', [resultPtr.toJS, space.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Get the number of iterations to use when solving constraints and collisions.
/// @param space The space.
/// @return The number of iterations.
int cpSpaceGetIterations(int space) => _callInt('_cp_space_get_iterations', [space.toJS]);

/// Set the number of iterations to use when solving constraints and collisions.
/// More iterations improves stability but is slower. Default is 10.
/// @param space The space.
/// @param iterations The number of iterations.
void cpSpaceSetIterations(int space, int iterations) =>
    _callVoid('_cp_space_set_iterations', [space.toJS, iterations.toJS]);

/// Get the damping rate for the space.
/// @param space The space.
/// @return The damping rate (fraction of velocity retained per second).
double cpSpaceGetDamping(int space) => _callDouble('_cp_space_get_damping', [space.toJS]);

/// Set the damping rate for the space.
/// @param space The space.
/// @param damping The damping rate (fraction of velocity retained per second).
void cpSpaceSetDamping(int space, double damping) => _callVoid('_cp_space_set_damping', [space.toJS, damping.toJS]);

/// Get the speed threshold for a body to be considered idle.
/// @param space The space.
/// @return The idle speed threshold.
double cpSpaceGetIdleSpeedThreshold(int space) => _callDouble('_cp_space_get_idle_speed_threshold', [space.toJS]);

/// Set the speed threshold for a body to be considered idle.
/// @param space The space.
/// @param threshold The idle speed threshold.
void cpSpaceSetIdleSpeedThreshold(int space, double threshold) =>
    _callVoid('_cp_space_set_idle_speed_threshold', [space.toJS, threshold.toJS]);

/// Get the time a group of bodies must remain idle to fall asleep.
/// @param space The space.
/// @return The sleep time threshold.
double cpSpaceGetSleepTimeThreshold(int space) => _callDouble('_cp_space_get_sleep_time_threshold', [space.toJS]);

/// Set the time a group of bodies must remain idle to fall asleep.
/// @param space The space.
/// @param threshold The sleep time threshold.
void cpSpaceSetSleepTimeThreshold(int space, double threshold) =>
    _callVoid('_cp_space_set_sleep_time_threshold', [space.toJS, threshold.toJS]);

/// Get the amount of encouraged penetration between colliding shapes.
/// @param space The space.
/// @return The collision slop.
double cpSpaceGetCollisionSlop(int space) => _callDouble('_cp_space_get_collision_slop', [space.toJS]);

/// Set the amount of encouraged penetration between colliding shapes.
/// @param space The space.
/// @param slop The collision slop.
void cpSpaceSetCollisionSlop(int space, double slop) =>
    _callVoid('_cp_space_set_collision_slop', [space.toJS, slop.toJS]);

/// Get how fast overlapping shapes are pushed apart.
/// @param space The space.
/// @return The collision bias.
double cpSpaceGetCollisionBias(int space) => _callDouble('_cp_space_get_collision_bias', [space.toJS]);

/// Set how fast overlapping shapes are pushed apart.
/// @param space The space.
/// @param bias The collision bias.
void cpSpaceSetCollisionBias(int space, double bias) =>
    _callVoid('_cp_space_set_collision_bias', [space.toJS, bias.toJS]);

/// Get the number of frames that contact information should persist.
/// @param space The space.
/// @return The collision persistence.
int cpSpaceGetCollisionPersistence(int space) => _callInt('_cp_space_get_collision_persistence', [space.toJS]);

/// Set the number of frames that contact information should persist.
/// @param space The space.
/// @param persistence The collision persistence.
void cpSpaceSetCollisionPersistence(int space, int persistence) =>
    _callVoid('_cp_space_set_collision_persistence', [space.toJS, persistence.toJS]);

/// Get the current (or most recent) time step used with this space.
/// @param space The space.
/// @return The current time step.
double cpSpaceGetCurrentTimeStep(int space) => _callDouble('_cp_space_get_current_time_step', [space.toJS]);

/// Returns true from inside a callback when objects cannot be added/removed.
/// @param space The space.
/// @return Non-zero if the space is locked.
int cpSpaceIsLocked(int space) => _callInt('_cp_space_is_locked', [space.toJS]);

/// Get the space's built-in static body.
/// @param space The space.
/// @return A pointer to the static body.
int cpSpaceGetStaticBody(int space) => _callInt('_cp_space_get_static_body', [space.toJS]);

/// Add a body to a space.
/// @param space The space.
/// @param body The body to add.
void cpSpaceAddBody(int space, int body) => _callVoid('_cp_space_add_body', [space.toJS, body.toJS]);

/// Remove a body from a space.
/// @param space The space.
/// @param body The body to remove.
void cpSpaceRemoveBody(int space, int body) => _callVoid('_cp_space_remove_body', [space.toJS, body.toJS]);

/// Add a shape to a space.
/// @param space The space.
/// @param shape The shape to add.
void cpSpaceAddShape(int space, int shape) => _callVoid('_cp_space_add_shape', [space.toJS, shape.toJS]);

/// Remove a shape from a space.
/// @param space The space.
/// @param shape The shape to remove.
void cpSpaceRemoveShape(int space, int shape) => _callVoid('_cp_space_remove_shape', [space.toJS, shape.toJS]);

/// Add a constraint to a space.
/// @param space The space.
/// @param constraint The constraint to add.
void cpSpaceAddConstraint(int space, int constraint) =>
    _callVoid('_cp_space_add_constraint', [space.toJS, constraint.toJS]);

/// Remove a constraint from a space.
/// @param space The space.
/// @param constraint The constraint to remove.
void cpSpaceRemoveConstraint(int space, int constraint) =>
    _callVoid('_cp_space_remove_constraint', [space.toJS, constraint.toJS]);

/// Test if a collision shape has been added to the space.
/// @param space The space.
/// @param shape The shape to test.
/// @return Non-zero if the shape is in the space.
int cpSpaceContainsShape(int space, int shape) => _callInt('_cp_space_contains_shape', [space.toJS, shape.toJS]);

/// Test if a rigid body has been added to the space.
/// @param space The space.
/// @param body The body to test.
/// @return Non-zero if the body is in the space.
int cpSpaceContainsBody(int space, int body) => _callInt('_cp_space_contains_body', [space.toJS, body.toJS]);

/// Test if a constraint has been added to the space.
/// @param space The space.
/// @param constraint The constraint to test.
/// @return Non-zero if the constraint is in the space.
int cpSpaceContainsConstraint(int space, int constraint) =>
    _callInt('_cp_space_contains_constraint', [space.toJS, constraint.toJS]);

/// Update the collision detection info for the static shapes in the space.
/// @param space The space.
void cpSpaceReindexStatic(int space) => _callVoid('_cp_space_reindex_static', [space.toJS]);

/// Update the collision detection data for a specific shape in the space.
/// @param space The space.
/// @param shape The shape to reindex.
void cpSpaceReindexShape(int space, int shape) => _callVoid('_cp_space_reindex_shape', [space.toJS, shape.toJS]);

/// Update the collision detection data for all shapes attached to a body.
/// @param space The space.
/// @param body The body whose shapes should be reindexed.
void cpSpaceReindexShapesForBody(int space, int body) =>
    _callVoid('_cp_space_reindex_shapes_for_body', [space.toJS, body.toJS]);

// ============================================================================
// Body Functions
// ============================================================================

/// Allocate and initialize a cpBody with the given mass and moment.
/// @param mass The mass of the body.
/// @param moment The moment of inertia of the body.
/// @return A pointer to the new body.
int cpBodyNew(double mass, double moment) => _callInt('_cp_body_new', [mass.toJS, moment.toJS]);

/// Allocate and initialize a cpBody as a kinematic body.
/// Kinematic bodies have infinite mass and moment, and are not affected by forces.
/// @return A pointer to the new kinematic body.
int cpBodyNewKinematic() => _callInt('_cp_body_new_kinematic', []);

/// Allocate and initialize a cpBody as a static body.
/// Static bodies have infinite mass and moment, and never move.
/// @return A pointer to the new static body.
int cpBodyNewStatic() => _callInt('_cp_body_new_static', []);

/// Free a body.
/// @param body The body to free.
void cpBodyFree(int body) => _callVoid('_cp_body_free', [body.toJS]);

/// Get the position of a body.
/// @param body The body.
/// @return A tuple of (x, y) position components.
Vector cpBodyGetPosition(int body) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_body_get_position', [resultPtr.toJS, body.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the position of a body.
/// @param body The body.
/// @param x The x component of the position.
/// @param y The y component of the position.
void cpBodySetPosition(int body, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_body_set_position', [body.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the velocity of a body.
/// @param body The body.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocity(int body) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_body_get_velocity', [resultPtr.toJS, body.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the velocity of a body.
/// @param body The body.
/// @param x The x component of the velocity.
/// @param y The y component of the velocity.
void cpBodySetVelocity(int body, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_body_set_velocity', [body.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the angle of a body in radians.
/// @param body The body.
/// @return The angle in radians.
double cpBodyGetAngle(int body) => _callDouble('_cp_body_get_angle', [body.toJS]);

/// Set the angle of a body in radians.
/// @param body The body.
/// @param angle The angle in radians.
void cpBodySetAngle(int body, double angle) => _callVoid('_cp_body_set_angle', [body.toJS, angle.toJS]);

/// Get the mass of a body.
/// @param body The body.
/// @return The mass.
double cpBodyGetMass(int body) => _callDouble('_cp_body_get_mass', [body.toJS]);

/// Set the mass of a body.
/// @param body The body.
/// @param mass The mass.
void cpBodySetMass(int body, double mass) => _callVoid('_cp_body_set_mass', [body.toJS, mass.toJS]);

/// Get the moment of inertia of a body.
/// @param body The body.
/// @return The moment of inertia.
double cpBodyGetMoment(int body) => _callDouble('_cp_body_get_moment', [body.toJS]);

/// Set the moment of inertia of a body.
/// @param body The body.
/// @param moment The moment of inertia.
void cpBodySetMoment(int body, double moment) => _callVoid('_cp_body_set_moment', [body.toJS, moment.toJS]);

/// Get the angular velocity of a body in radians per second.
/// @param body The body.
/// @return The angular velocity in radians per second.
double cpBodyGetAngularVelocity(int body) => _callDouble('_cp_body_get_angular_velocity', [body.toJS]);

/// Set the angular velocity of a body in radians per second.
/// @param body The body.
/// @param angularVelocity The angular velocity in radians per second.
void cpBodySetAngularVelocity(int body, double angularVelocity) =>
    _callVoid('_cp_body_set_angular_velocity', [body.toJS, angularVelocity.toJS]);

/// Get the center of gravity offset in body local coordinates.
/// @param body The body.
/// @return A tuple of (x, y) center of gravity components.
Vector cpBodyGetCenterOfGravity(int body) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_body_get_center_of_gravity', [resultPtr.toJS, body.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the center of gravity offset in body local coordinates.
/// @param body The body.
/// @param x The x component of the center of gravity.
/// @param y The y component of the center of gravity.
void cpBodySetCenterOfGravity(int body, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_body_set_center_of_gravity', [body.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the force applied to a body for the next time step.
/// @param body The body.
/// @return A tuple of (x, y) force components.
Vector cpBodyGetForce(int body) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_body_get_force', [resultPtr.toJS, body.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the force applied to a body for the next time step.
/// @param body The body.
/// @param x The x component of the force.
/// @param y The y component of the force.
void cpBodySetForce(int body, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_body_set_force', [body.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the torque applied to a body for the next time step.
/// @param body The body.
/// @return The torque.
double cpBodyGetTorque(int body) => _callDouble('_cp_body_get_torque', [body.toJS]);

/// Set the torque applied to a body for the next time step.
/// @param body The body.
/// @param torque The torque.
void cpBodySetTorque(int body, double torque) => _callVoid('_cp_body_set_torque', [body.toJS, torque.toJS]);

/// Get the rotation vector of a body (the x basis vector of its transform).
/// @param body The body.
/// @return A tuple of (x, y) rotation components.
Vector cpBodyGetRotation(int body) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_body_get_rotation', [resultPtr.toJS, body.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Get the type of a body.
/// @param body The body.
/// @return The body type (0=dynamic, 1=kinematic, 2=static).
int cpBodyGetType(int body) => _callInt('_cp_body_get_type', [body.toJS]);

/// Set the type of a body.
/// @param body The body.
/// @param type The body type (0=dynamic, 1=kinematic, 2=static).
void cpBodySetType(int body, int type) => _callVoid('_cp_body_set_type', [body.toJS, type.toJS]);

/// Returns true if the body is sleeping.
/// @param body The body.
/// @return Non-zero if the body is sleeping.
int cpBodyIsSleeping(int body) => _callInt('_cp_body_is_sleeping', [body.toJS]);

/// Wake up a sleeping or idle body.
/// @param body The body.
void cpBodyActivate(int body) => _callVoid('_cp_body_activate', [body.toJS]);

/// Wake up any sleeping or idle bodies touching a static body.
/// @param body The static body.
/// @param filter Optional shape filter (0 for all shapes).
void cpBodyActivateStatic(int body, int filter) => _callVoid('_cp_body_activate_static', [body.toJS, filter.toJS]);

/// Force a body to fall asleep immediately.
/// @param body The body.
void cpBodySleep(int body) => _callVoid('_cp_body_sleep', [body.toJS]);

/// Force a body to fall asleep immediately along with other bodies in a group.
/// @param body The body.
/// @param group The group body.
void cpBodySleepWithGroup(int body, int group) => _callVoid('_cp_body_sleep_with_group', [body.toJS, group.toJS]);

/// Convert body relative/local coordinates to absolute/world coordinates.
/// @param body The body.
/// @param x The x coordinate in body local space.
/// @param y The y coordinate in body local space.
/// @return A tuple of (x, y) world coordinates.
Vector cpBodyLocalToWorld(int body, double x, double y) {
  final resultPtr = _malloc(16);
  final pointPtr = _allocVect(x, y);
  _callVoid('_cp_body_local_to_world', [resultPtr.toJS, body.toJS, pointPtr.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  _free(pointPtr);
  return result;
}

/// Convert body absolute/world coordinates to relative/local coordinates.
/// @param body The body.
/// @param x The x coordinate in world space.
/// @param y The y coordinate in world space.
/// @return A tuple of (x, y) local coordinates.
Vector cpBodyWorldToLocal(int body, double x, double y) {
  final resultPtr = _malloc(16);
  final pointPtr = _allocVect(x, y);
  _callVoid('_cp_body_world_to_local', [resultPtr.toJS, body.toJS, pointPtr.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  _free(pointPtr);
  return result;
}

/// Apply a force to a body. Both the force and point are expressed in world coordinates.
/// @param body The body.
/// @param fx The x component of the force.
/// @param fy The y component of the force.
/// @param px The x coordinate of the point in world space.
/// @param py The y coordinate of the point in world space.
void cpBodyApplyForceAtWorldPoint(int body, double fx, double fy, double px, double py) {
  final forcePtr = _allocVect(fx, fy);
  final pointPtr = _allocVect(px, py);
  _callVoid(
    '_cp_body_apply_force_at_world_point',
    [body.toJS, forcePtr.toJS, pointPtr.toJS],
  );
  _free(forcePtr);
  _free(pointPtr);
}

/// Apply a force to a body. Both the force and point are expressed in body local coordinates.
/// @param body The body.
/// @param fx The x component of the force.
/// @param fy The y component of the force.
/// @param px The x coordinate of the point in body local space.
/// @param py The y coordinate of the point in body local space.
void cpBodyApplyForceAtLocalPoint(int body, double fx, double fy, double px, double py) {
  final forcePtr = _allocVect(fx, fy);
  final pointPtr = _allocVect(px, py);
  _callVoid(
    '_cp_body_apply_force_at_local_point',
    [body.toJS, forcePtr.toJS, pointPtr.toJS],
  );
  _free(forcePtr);
  _free(pointPtr);
}

/// Apply an impulse to a body. Both the impulse and point are expressed in world coordinates.
/// @param body The body.
/// @param ix The x component of the impulse.
/// @param iy The y component of the impulse.
/// @param px The x coordinate of the point in world space.
/// @param py The y coordinate of the point in world space.
void cpBodyApplyImpulseAtWorldPoint(int body, double ix, double iy, double px, double py) {
  final impulsePtr = _allocVect(ix, iy);
  final pointPtr = _allocVect(px, py);
  _callVoid(
    '_cp_body_apply_impulse_at_world_point',
    [body.toJS, impulsePtr.toJS, pointPtr.toJS],
  );
  _free(impulsePtr);
  _free(pointPtr);
}

/// Apply an impulse to a body. Both the impulse and point are expressed in body local coordinates.
/// @param body The body.
/// @param ix The x component of the impulse.
/// @param iy The y component of the impulse.
/// @param px The x coordinate of the point in body local space.
/// @param py The y coordinate of the point in body local space.
void cpBodyApplyImpulseAtLocalPoint(int body, double ix, double iy, double px, double py) {
  final impulsePtr = _allocVect(ix, iy);
  final pointPtr = _allocVect(px, py);
  _callVoid(
    '_cp_body_apply_impulse_at_local_point',
    [body.toJS, impulsePtr.toJS, pointPtr.toJS],
  );
  _free(impulsePtr);
  _free(pointPtr);
}

/// Get the velocity on a body at a point in world coordinates.
/// @param body The body.
/// @param x The x coordinate of the point in world space.
/// @param y The y coordinate of the point in world space.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocityAtWorldPoint(int body, double x, double y) {
  final resultPtr = _malloc(16);
  final pointPtr = _allocVect(x, y);
  _callVoid(
    '_cp_body_get_velocity_at_world_point',
    [resultPtr.toJS, body.toJS, pointPtr.toJS],
  );
  final result = _readVect(resultPtr);
  _free(resultPtr);
  _free(pointPtr);
  return result;
}

/// Get the velocity on a body at a point in body local coordinates.
/// @param body The body.
/// @param x The x coordinate of the point in body local space.
/// @param y The y coordinate of the point in body local space.
/// @return A tuple of (x, y) velocity components.
Vector cpBodyGetVelocityAtLocalPoint(int body, double x, double y) {
  final resultPtr = _malloc(16);
  final pointPtr = _allocVect(x, y);
  _callVoid(
    '_cp_body_get_velocity_at_local_point',
    [resultPtr.toJS, body.toJS, pointPtr.toJS],
  );
  final result = _readVect(resultPtr);
  _free(resultPtr);
  _free(pointPtr);
  return result;
}

/// Get the amount of kinetic energy contained by the body.
/// @param body The body.
/// @return The kinetic energy.
double cpBodyKineticEnergy(int body) => _callDouble('_cp_body_kinetic_energy', [body.toJS]);

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
  final offsetPtr = _allocVect(offsetX, offsetY);
  final result = _callInt(
    '_cp_circle_shape_new',
    [body.toJS, radius.toJS, offsetPtr.toJS],
  );
  _free(offsetPtr);
  return result;
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
  final aPtr = _allocVect(ax, ay);
  final bPtr = _allocVect(bx, by);
  final result = _callInt(
    '_cp_segment_shape_new',
    [body.toJS, aPtr.toJS, bPtr.toJS, radius.toJS],
  );
  _free(aPtr);
  _free(bPtr);
  return result;
}

/// Allocate and initialize a box shape.
/// @param body The body to attach the shape to.
/// @param width The width of the box.
/// @param height The height of the box.
/// @param radius The corner radius of the box.
/// @return A pointer to the new box shape.
int cpPolyShapeNewBox(int body, double width, double height, double radius) => _callInt(
  '_cp_box_shape_new',
  [body.toJS, width.toJS, height.toJS, radius.toJS],
);

/// Allocate and initialize a polygon shape.
/// @param body The body to attach the shape to.
/// @param verts A list of vertex coordinates as [x1, y1, x2, y2, ...].
/// @param radius The radius of the polygon (for rounded corners).
/// @return A pointer to the new polygon shape.
int cpPolyShapeNew(int body, List<double> verts, double radius) {
  final count = verts.length ~/ 2;
  // Allocate memory for vertices (16 bytes per cpVect = 2 doubles)
  final ptr = _malloc(count * 16);
  for (var i = 0; i < count; i++) {
    _setDouble(ptr + i * 16, verts[i * 2]);
    _setDouble(ptr + i * 16 + 8, verts[i * 2 + 1]);
  }
  final result = _callInt(
    '_cp_poly_shape_new_raw',
    [body.toJS, count.toJS, ptr.toJS, radius.toJS],
  );
  _free(ptr);
  return result;
}

/// Free a shape.
/// @param shape The shape to free.
void cpShapeFree(int shape) => _callVoid('_cp_shape_free', [shape.toJS]);

/// Get the elasticity (bounciness) of a shape.
/// @param shape The shape.
/// @return The elasticity (0.0 = no bounce, 1.0 = perfect bounce).
double cpShapeGetElasticity(int shape) => _callDouble('_cp_shape_get_elasticity', [shape.toJS]);

/// Set the elasticity (bounciness) of a shape.
/// @param shape The shape.
/// @param elasticity The elasticity (0.0 = no bounce, 1.0 = perfect bounce).
void cpShapeSetElasticity(int shape, double elasticity) =>
    _callVoid('_cp_shape_set_elasticity', [shape.toJS, elasticity.toJS]);

/// Get the friction coefficient of a shape.
/// @param shape The shape.
/// @return The friction coefficient.
double cpShapeGetFriction(int shape) => _callDouble('_cp_shape_get_friction', [shape.toJS]);

/// Set the friction coefficient of a shape.
/// @param shape The shape.
/// @param friction The friction coefficient.
void cpShapeSetFriction(int shape, double friction) => _callVoid('_cp_shape_set_friction', [shape.toJS, friction.toJS]);

/// Get the surface velocity of a shape.
/// @param shape The shape.
/// @return A tuple of (x, y) surface velocity components.
Vector cpShapeGetSurfaceVelocity(int shape) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_shape_get_surface_velocity', [resultPtr.toJS, shape.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the surface velocity of a shape.
/// @param shape The shape.
/// @param x The x component of the surface velocity.
/// @param y The y component of the surface velocity.
void cpShapeSetSurfaceVelocity(int shape, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_shape_set_surface_velocity', [shape.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the collision type of a shape.
/// @param shape The shape.
/// @return The collision type.
int cpShapeGetCollisionType(int shape) => _callInt('_cp_shape_get_collision_type', [shape.toJS]);

/// Set the collision type of a shape.
/// @param shape The shape.
/// @param collisionType The collision type.
void cpShapeSetCollisionType(int shape, int collisionType) =>
    _callVoid('_cp_shape_set_collision_type', [shape.toJS, collisionType.toJS]);

/// Get the collision filter categories of a shape.
/// @param shape The shape.
/// @return The filter categories.
/// Get the collision filter of a shape.
/// @param shape The shape.
/// @return A tuple of (group, categories, mask) filter values.
ShapeFilter cpShapeGetFilter(int shape) {
  _ensureInitialized();
  // cpShapeFilter is a struct with 3 uintptr_t fields (group, categories, mask)
  // On 64-bit systems, each is 8 bytes, so total is 24 bytes
  final resultPtr = _malloc(24);
  _callVoid('_cp_shape_get_filter', [resultPtr.toJS, shape.toJS]);
  // Read the three fields (each is 8 bytes on 64-bit)
  final group = _getInt(resultPtr);
  final categories = _getInt(resultPtr + 8);
  final mask = _getInt(resultPtr + 16);
  _free(resultPtr);
  return ShapeFilter(
    group: group,
    categories: categories,
    mask: mask,
  );
}

/// Set the collision filter of a shape.
/// @param shape The shape.
/// @param group The collision group.
/// @param categories The collision categories.
/// @param mask The collision mask.
void cpShapeSetFilter(int shape, int group, int categories, int mask) {
  // Create filter using the C function
  final filterPtr = _malloc(24);
  _callVoid(
    '_cp_shape_filter_new',
    [filterPtr.toJS, group.toJS, categories.toJS, mask.toJS],
  );
  _callVoid('_cp_shape_set_filter', [shape.toJS, filterPtr.toJS]);
  _free(filterPtr);
}

/// Get whether a shape is a sensor (non-colliding trigger).
/// @param shape The shape.
/// @return Non-zero if the shape is a sensor.
int cpShapeGetSensor(int shape) => _callInt('_cp_shape_get_sensor', [shape.toJS]);

/// Set whether a shape is a sensor (non-colliding trigger).
/// @param shape The shape.
/// @param sensor Non-zero to make the shape a sensor.
void cpShapeSetSensor(int shape, int sensor) => _callVoid('_cp_shape_set_sensor', [shape.toJS, sensor.toJS]);

/// Get the body that a shape is attached to.
/// @param shape The shape.
/// @return A pointer to the body.
int cpShapeGetBody(int shape) => _callInt('_cp_shape_get_body', [shape.toJS]);

/// Set the body that a shape is attached to.
/// @param shape The shape.
/// @param body The body pointer (0 to detach).
void cpShapeSetBody(int shape, int body) {
  _ensureInitialized();
  _callVoid('_cp_shape_set_body', [shape.toJS, body.toJS]);
}

/// Get the calculated moment of inertia for a shape.
/// @param shape The shape.
/// @return The moment of inertia.
double cpShapeGetMoment(int shape) {
  _ensureInitialized();
  return _callDouble('_cp_shape_get_moment', [shape.toJS]);
}

/// Get the calculated area of a shape.
/// @param shape The shape.
/// @return The area.
double cpShapeGetArea(int shape) {
  _ensureInitialized();
  return _callDouble('_cp_shape_get_area', [shape.toJS]);
}

/// Get the calculated center of gravity of a shape.
/// @param shape The shape.
/// @return A tuple of (x, y) center of gravity coordinates.
Vector cpShapeGetCenterOfGravity(int shape) {
  _ensureInitialized();
  final resultPtr = _malloc(16);
  _callVoid('_cp_shape_get_center_of_gravity', [resultPtr.toJS, shape.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Get the axis-aligned bounding box of a shape.
/// @param shape The shape.
/// @return A tuple of (left, bottom, right, top) bounding box coordinates.
BoundingBox cpShapeGetBB(int shape) {
  // cpBB is 4 doubles (l, b, r, t)
  final resultPtr = _malloc(32);
  _callVoid('_cp_shape_get_bb', [resultPtr.toJS, shape.toJS]);
  final l = _getDouble(resultPtr);
  final b = _getDouble(resultPtr + 8);
  final r = _getDouble(resultPtr + 16);
  final t = _getDouble(resultPtr + 24);
  _free(resultPtr);
  return BoundingBox(
    left: l,
    bottom: b,
    right: r,
    top: t,
  );
}

/// Get the mass of a shape.
/// @param shape The shape.
/// @return The mass.
double cpShapeGetMass(int shape) => _callDouble('_cp_shape_get_mass', [shape.toJS]);

/// Set the mass of a shape.
/// @param shape The shape.
/// @param mass The mass.
void cpShapeSetMass(int shape, double mass) => _callVoid('_cp_shape_set_mass', [shape.toJS, mass.toJS]);

/// Get the density of a shape.
/// @param shape The shape.
/// @return The density.
double cpShapeGetDensity(int shape) => _callDouble('_cp_shape_get_density', [shape.toJS]);

/// Set the density of a shape.
/// @param shape The shape.
/// @param density The density.
void cpShapeSetDensity(int shape, double density) => _callVoid('_cp_shape_set_density', [shape.toJS, density.toJS]);

/// Get the radius of a circle shape.
/// @param shape The circle shape.
/// @return The radius.
double cpCircleShapeGetRadius(int shape) => _callDouble('_cp_circle_shape_get_radius', [shape.toJS]);

/// Get the offset of a circle shape from the body's center of gravity.
/// @param shape The circle shape.
/// @return A tuple of (x, y) offset components.
Vector cpCircleShapeGetOffset(int shape) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_circle_shape_get_offset', [resultPtr.toJS, shape.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Get the first endpoint of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) coordinates of the first endpoint.
Vector cpSegmentShapeGetA(int shape) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_segment_shape_get_a', [resultPtr.toJS, shape.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Get the second endpoint of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) coordinates of the second endpoint.
Vector cpSegmentShapeGetB(int shape) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_segment_shape_get_b', [resultPtr.toJS, shape.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Get the radius of a segment shape.
/// @param shape The segment shape.
/// @return The radius.
double cpSegmentShapeGetRadius(int shape) => _callDouble('_cp_segment_shape_get_radius', [shape.toJS]);

/// Get the normal vector of a segment shape.
/// @param shape The segment shape.
/// @return A tuple of (x, y) normal components.
Vector cpSegmentShapeGetNormal(int shape) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_segment_shape_get_normal', [resultPtr.toJS, shape.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the neighbor segments for a segment shape.
/// @param shape The segment shape.
/// @param prevX The x coordinate of the previous segment endpoint.
/// @param prevY The y coordinate of the previous segment endpoint.
/// @param nextX The x coordinate of the next segment endpoint.
/// @param nextY The y coordinate of the next segment endpoint.
void cpSegmentShapeSetNeighbors(int shape, double prevX, double prevY, double nextX, double nextY) {
  final prevPtr = _allocVect(prevX, prevY);
  final nextPtr = _allocVect(nextX, nextY);
  _callVoid(
    '_cp_segment_shape_set_neighbors',
    [shape.toJS, prevPtr.toJS, nextPtr.toJS],
  );
  _free(prevPtr);
  _free(nextPtr);
}

/// Get the number of vertices in a polygon shape.
/// @param shape The polygon shape.
/// @return The number of vertices.
int cpPolyShapeGetCount(int shape) => _callInt('_cp_poly_shape_get_count', [shape.toJS]);

/// Get a vertex of a polygon shape.
/// @param shape The polygon shape.
/// @param index The vertex index.
/// @return A tuple of (x, y) vertex coordinates.
Vector cpPolyShapeGetVert(int shape, int index) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_poly_shape_get_vert', [resultPtr.toJS, shape.toJS, index.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Get the radius of a polygon shape.
/// @param shape The polygon shape.
/// @return The radius.
double cpPolyShapeGetRadius(int shape) => _callDouble('_cp_poly_shape_get_radius', [shape.toJS]);

// ============================================================================
// Constraint Functions
// ============================================================================

/// Free a constraint.
/// @param constraint The constraint to free.
void cpConstraintFree(int constraint) => _callVoid('_cp_constraint_free', [constraint.toJS]);

/// Get the maximum force that a constraint can apply.
/// @param constraint The constraint.
/// @return The maximum force.
double cpConstraintGetMaxForce(int constraint) => _callDouble('_cp_constraint_get_max_force', [constraint.toJS]);

/// Set the maximum force that a constraint can apply.
/// @param constraint The constraint.
/// @param maxForce The maximum force.
void cpConstraintSetMaxForce(int constraint, double maxForce) =>
    _callVoid('_cp_constraint_set_max_force', [constraint.toJS, maxForce.toJS]);

/// Get the error bias of a constraint.
/// @param constraint The constraint.
/// @return The error bias.
double cpConstraintGetErrorBias(int constraint) => _callDouble('_cp_constraint_get_error_bias', [constraint.toJS]);

/// Set the error bias of a constraint.
/// @param constraint The constraint.
/// @param errorBias The error bias.
void cpConstraintSetErrorBias(int constraint, double errorBias) =>
    _callVoid('_cp_constraint_set_error_bias', [constraint.toJS, errorBias.toJS]);

/// Get the maximum bias velocity of a constraint.
/// @param constraint The constraint.
/// @return The maximum bias.
double cpConstraintGetMaxBias(int constraint) => _callDouble('_cp_constraint_get_max_bias', [constraint.toJS]);

/// Set the maximum bias velocity of a constraint.
/// @param constraint The constraint.
/// @param maxBias The maximum bias.
void cpConstraintSetMaxBias(int constraint, double maxBias) =>
    _callVoid('_cp_constraint_set_max_bias', [constraint.toJS, maxBias.toJS]);

/// Get whether the two bodies connected by a constraint can collide.
/// @param constraint The constraint.
/// @return Non-zero if the bodies can collide.
int cpConstraintGetCollideBodies(int constraint) => _callInt('_cp_constraint_get_collide_bodies', [constraint.toJS]);

/// Set whether the two bodies connected by a constraint can collide.
/// @param constraint The constraint.
/// @param collideBodies Non-zero to allow collisions between the bodies.
void cpConstraintSetCollideBodies(int constraint, int collideBodies) =>
    _callVoid('_cp_constraint_set_collide_bodies', [constraint.toJS, collideBodies.toJS]);

/// Get the impulse that the constraint applied this step.
/// @param constraint The constraint.
/// @return The impulse.
double cpConstraintGetImpulse(int constraint) => _callDouble('_cp_constraint_get_impulse', [constraint.toJS]);

/// Get the first body connected by a constraint.
/// @param constraint The constraint.
/// @return A pointer to the first body.
int cpConstraintGetBodyA(int constraint) => _callInt('_cp_constraint_get_body_a', [constraint.toJS]);

/// Get the second body connected by a constraint.
/// @param constraint The constraint.
/// @return A pointer to the second body.
int cpConstraintGetBodyB(int constraint) => _callInt('_cp_constraint_get_body_b', [constraint.toJS]);

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
  final aPtr = _allocVect(anchorAx, anchorAy);
  final bPtr = _allocVect(anchorBx, anchorBy);
  final result = _callInt(
    '_cp_pin_joint_new',
    [bodyA.toJS, bodyB.toJS, aPtr.toJS, bPtr.toJS],
  );
  _free(aPtr);
  _free(bPtr);
  return result;
}

/// Get the anchor point on bodyA for a pin joint.
/// @param constraint The pin joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPinJointGetAnchorA(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_pin_joint_get_anchor_a', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyA for a pin joint.
/// @param constraint The pin joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPinJointSetAnchorA(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_pin_joint_set_anchor_a', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the anchor point on bodyB for a pin joint.
/// @param constraint The pin joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPinJointGetAnchorB(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_pin_joint_get_anchor_b', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyB for a pin joint.
/// @param constraint The pin joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPinJointSetAnchorB(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_pin_joint_set_anchor_b', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the distance between the anchor points for a pin joint.
/// @param constraint The pin joint.
/// @return The distance.
double cpPinJointGetDist(int constraint) => _callDouble('_cp_pin_joint_get_dist', [constraint.toJS]);

/// Set the distance between the anchor points for a pin joint.
/// @param constraint The pin joint.
/// @param dist The distance.
void cpPinJointSetDist(int constraint, double dist) =>
    _callVoid('_cp_pin_joint_set_dist', [constraint.toJS, dist.toJS]);

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
  final aPtr = _allocVect(anchorAx, anchorAy);
  final bPtr = _allocVect(anchorBx, anchorBy);
  final result = _callInt(
    '_cp_slide_joint_new',
    [bodyA.toJS, bodyB.toJS, aPtr.toJS, bPtr.toJS, min.toJS, max.toJS],
  );
  _free(aPtr);
  _free(bPtr);
  return result;
}

/// Get the anchor point on bodyA for a slide joint.
/// @param constraint The slide joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpSlideJointGetAnchorA(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_slide_joint_get_anchor_a', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyA for a slide joint.
/// @param constraint The slide joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpSlideJointSetAnchorA(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_slide_joint_set_anchor_a', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the anchor point on bodyB for a slide joint.
/// @param constraint The slide joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpSlideJointGetAnchorB(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_slide_joint_get_anchor_b', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyB for a slide joint.
/// @param constraint The slide joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpSlideJointSetAnchorB(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_slide_joint_set_anchor_b', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the minimum distance for a slide joint.
/// @param constraint The slide joint.
/// @return The minimum distance.
double cpSlideJointGetMin(int constraint) => _callDouble('_cp_slide_joint_get_min', [constraint.toJS]);

/// Set the minimum distance for a slide joint.
/// @param constraint The slide joint.
/// @param min The minimum distance.
void cpSlideJointSetMin(int constraint, double min) =>
    _callVoid('_cp_slide_joint_set_min', [constraint.toJS, min.toJS]);

/// Get the maximum distance for a slide joint.
/// @param constraint The slide joint.
/// @return The maximum distance.
double cpSlideJointGetMax(int constraint) => _callDouble('_cp_slide_joint_get_max', [constraint.toJS]);

/// Set the maximum distance for a slide joint.
/// @param constraint The slide joint.
/// @param max The maximum distance.
void cpSlideJointSetMax(int constraint, double max) =>
    _callVoid('_cp_slide_joint_set_max', [constraint.toJS, max.toJS]);

// Pivot Joint
/// Allocate and initialize a pivot joint with a single pivot point.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param pivotX The x coordinate of the pivot point in world space.
/// @param pivotY The y coordinate of the pivot point in world space.
/// @return A pointer to the new pivot joint.
int cpPivotJointNew(int bodyA, int bodyB, double pivotX, double pivotY) {
  final pivotPtr = _allocVect(pivotX, pivotY);
  final result = _callInt(
    '_cp_pivot_joint_new',
    [bodyA.toJS, bodyB.toJS, pivotPtr.toJS],
  );
  _free(pivotPtr);
  return result;
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
  final aPtr = _allocVect(anchorAx, anchorAy);
  final bPtr = _allocVect(anchorBx, anchorBy);
  final result = _callInt(
    '_cp_pivot_joint_new2',
    [bodyA.toJS, bodyB.toJS, aPtr.toJS, bPtr.toJS],
  );
  _free(aPtr);
  _free(bPtr);
  return result;
}

/// Get the anchor point on bodyA for a pivot joint.
/// @param constraint The pivot joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPivotJointGetAnchorA(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_pivot_joint_get_anchor_a', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyA for a pivot joint.
/// @param constraint The pivot joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPivotJointSetAnchorA(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_pivot_joint_set_anchor_a', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the anchor point on bodyB for a pivot joint.
/// @param constraint The pivot joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpPivotJointGetAnchorB(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_pivot_joint_get_anchor_b', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyB for a pivot joint.
/// @param constraint The pivot joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpPivotJointSetAnchorB(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_pivot_joint_set_anchor_b', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
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
  final gaPtr = _allocVect(grooveAx, grooveAy);
  final gbPtr = _allocVect(grooveBx, grooveBy);
  final abPtr = _allocVect(anchorBx, anchorBy);
  final result = _callInt(
    '_cp_groove_joint_new',
    [bodyA.toJS, bodyB.toJS, gaPtr.toJS, gbPtr.toJS, abPtr.toJS],
  );
  _free(gaPtr);
  _free(gbPtr);
  _free(abPtr);
  return result;
}

/// Get the first groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) groove endpoint coordinates.
Vector cpGrooveJointGetGrooveA(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_groove_joint_get_groove_a', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the first groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the groove endpoint.
/// @param y The y coordinate of the groove endpoint.
void cpGrooveJointSetGrooveA(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_groove_joint_set_groove_a', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the second groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) groove endpoint coordinates.
Vector cpGrooveJointGetGrooveB(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_groove_joint_get_groove_b', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the second groove endpoint for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the groove endpoint.
/// @param y The y coordinate of the groove endpoint.
void cpGrooveJointSetGrooveB(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_groove_joint_set_groove_b', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the anchor point on bodyB for a groove joint.
/// @param constraint The groove joint.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpGrooveJointGetAnchorB(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_groove_joint_get_anchor_b', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyB for a groove joint.
/// @param constraint The groove joint.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpGrooveJointSetAnchorB(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_groove_joint_set_anchor_b', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
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
  final aPtr = _allocVect(anchorAx, anchorAy);
  final bPtr = _allocVect(anchorBx, anchorBy);
  final result = _callInt(
    '_cp_damped_spring_new',
    [bodyA.toJS, bodyB.toJS, aPtr.toJS, bPtr.toJS, restLength.toJS, stiffness.toJS, damping.toJS],
  );
  _free(aPtr);
  _free(bPtr);
  return result;
}

/// Get the anchor point on bodyA for a damped spring.
/// @param constraint The damped spring.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpDampedSpringGetAnchorA(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_damped_spring_get_anchor_a', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyA for a damped spring.
/// @param constraint The damped spring.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpDampedSpringSetAnchorA(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_damped_spring_set_anchor_a', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the anchor point on bodyB for a damped spring.
/// @param constraint The damped spring.
/// @return A tuple of (x, y) anchor coordinates.
Vector cpDampedSpringGetAnchorB(int constraint) {
  final resultPtr = _malloc(16);
  _callVoid('_cp_damped_spring_get_anchor_b', [resultPtr.toJS, constraint.toJS]);
  final result = _readVect(resultPtr);
  _free(resultPtr);
  return result;
}

/// Set the anchor point on bodyB for a damped spring.
/// @param constraint The damped spring.
/// @param x The x coordinate of the anchor point.
/// @param y The y coordinate of the anchor point.
void cpDampedSpringSetAnchorB(int constraint, double x, double y) {
  final vectPtr = _allocVect(x, y);
  _callVoid('_cp_damped_spring_set_anchor_b', [constraint.toJS, vectPtr.toJS]);
  _free(vectPtr);
}

/// Get the rest length of a damped spring.
/// @param constraint The damped spring.
/// @return The rest length.
double cpDampedSpringGetRestLength(int constraint) =>
    _callDouble('_cp_damped_spring_get_rest_length', [constraint.toJS]);

/// Set the rest length of a damped spring.
/// @param constraint The damped spring.
/// @param restLength The rest length.
void cpDampedSpringSetRestLength(int constraint, double restLength) =>
    _callVoid('_cp_damped_spring_set_rest_length', [constraint.toJS, restLength.toJS]);

/// Get the stiffness of a damped spring.
/// @param constraint The damped spring.
/// @return The stiffness.
double cpDampedSpringGetStiffness(int constraint) => _callDouble('_cp_damped_spring_get_stiffness', [constraint.toJS]);

/// Set the stiffness of a damped spring.
/// @param constraint The damped spring.
/// @param stiffness The stiffness.
void cpDampedSpringSetStiffness(int constraint, double stiffness) =>
    _callVoid('_cp_damped_spring_set_stiffness', [constraint.toJS, stiffness.toJS]);

/// Get the damping of a damped spring.
/// @param constraint The damped spring.
/// @return The damping.
double cpDampedSpringGetDamping(int constraint) => _callDouble('_cp_damped_spring_get_damping', [constraint.toJS]);

/// Set the damping of a damped spring.
/// @param constraint The damped spring.
/// @param damping The damping.
void cpDampedSpringSetDamping(int constraint, double damping) =>
    _callVoid('_cp_damped_spring_set_damping', [constraint.toJS, damping.toJS]);

// Damped Rotary Spring
/// Allocate and initialize a damped rotary spring constraint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param restAngle The rest angle of the spring in radians.
/// @param stiffness The spring stiffness.
/// @param damping The spring damping.
/// @return A pointer to the new damped rotary spring constraint.
int cpDampedRotarySpringNew(int bodyA, int bodyB, double restAngle, double stiffness, double damping) => _callInt(
  '_cp_damped_rotary_spring_new',
  [bodyA.toJS, bodyB.toJS, restAngle.toJS, stiffness.toJS, damping.toJS],
);

/// Get the rest angle of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The rest angle in radians.
double cpDampedRotarySpringGetRestAngle(int constraint) =>
    _callDouble('_cp_damped_rotary_spring_get_rest_angle', [constraint.toJS]);

/// Set the rest angle of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param restAngle The rest angle in radians.
void cpDampedRotarySpringSetRestAngle(int constraint, double restAngle) =>
    _callVoid('_cp_damped_rotary_spring_set_rest_angle', [constraint.toJS, restAngle.toJS]);

/// Get the stiffness of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The stiffness.
double cpDampedRotarySpringGetStiffness(int constraint) =>
    _callDouble('_cp_damped_rotary_spring_get_stiffness', [constraint.toJS]);

/// Set the stiffness of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param stiffness The stiffness.
void cpDampedRotarySpringSetStiffness(int constraint, double stiffness) =>
    _callVoid('_cp_damped_rotary_spring_set_stiffness', [constraint.toJS, stiffness.toJS]);

/// Get the damping of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @return The damping.
double cpDampedRotarySpringGetDamping(int constraint) =>
    _callDouble('_cp_damped_rotary_spring_get_damping', [constraint.toJS]);

/// Set the damping of a damped rotary spring.
/// @param constraint The damped rotary spring.
/// @param damping The damping.
void cpDampedRotarySpringSetDamping(int constraint, double damping) =>
    _callVoid('_cp_damped_rotary_spring_set_damping', [constraint.toJS, damping.toJS]);

// Rotary Limit Joint
/// Allocate and initialize a rotary limit joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param min The minimum angle in radians.
/// @param max The maximum angle in radians.
/// @return A pointer to the new rotary limit joint.
int cpRotaryLimitJointNew(int bodyA, int bodyB, double min, double max) => _callInt(
  '_cp_rotary_limit_joint_new',
  [bodyA.toJS, bodyB.toJS, min.toJS, max.toJS],
);

/// Get the minimum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @return The minimum angle in radians.
double cpRotaryLimitJointGetMin(int constraint) => _callDouble('_cp_rotary_limit_joint_get_min', [constraint.toJS]);

/// Set the minimum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @param min The minimum angle in radians.
void cpRotaryLimitJointSetMin(int constraint, double min) =>
    _callVoid('_cp_rotary_limit_joint_set_min', [constraint.toJS, min.toJS]);

/// Get the maximum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @return The maximum angle in radians.
double cpRotaryLimitJointGetMax(int constraint) => _callDouble('_cp_rotary_limit_joint_get_max', [constraint.toJS]);

/// Set the maximum angle for a rotary limit joint.
/// @param constraint The rotary limit joint.
/// @param max The maximum angle in radians.
void cpRotaryLimitJointSetMax(int constraint, double max) =>
    _callVoid('_cp_rotary_limit_joint_set_max', [constraint.toJS, max.toJS]);

// Ratchet Joint
/// Allocate and initialize a ratchet joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param phase The phase offset in radians.
/// @param ratchet The ratchet angle in radians.
/// @return A pointer to the new ratchet joint.
int cpRatchetJointNew(int bodyA, int bodyB, double phase, double ratchet) => _callInt(
  '_cp_ratchet_joint_new',
  [bodyA.toJS, bodyB.toJS, phase.toJS, ratchet.toJS],
);

/// Get the current angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The current angle in radians.
double cpRatchetJointGetAngle(int constraint) => _callDouble('_cp_ratchet_joint_get_angle', [constraint.toJS]);

/// Set the current angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param angle The current angle in radians.
void cpRatchetJointSetAngle(int constraint, double angle) =>
    _callVoid('_cp_ratchet_joint_set_angle', [constraint.toJS, angle.toJS]);

/// Get the phase offset for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The phase offset in radians.
double cpRatchetJointGetPhase(int constraint) => _callDouble('_cp_ratchet_joint_get_phase', [constraint.toJS]);

/// Set the phase offset for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param phase The phase offset in radians.
void cpRatchetJointSetPhase(int constraint, double phase) =>
    _callVoid('_cp_ratchet_joint_set_phase', [constraint.toJS, phase.toJS]);

/// Get the ratchet angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @return The ratchet angle in radians.
double cpRatchetJointGetRatchet(int constraint) => _callDouble('_cp_ratchet_joint_get_ratchet', [constraint.toJS]);

/// Set the ratchet angle for a ratchet joint.
/// @param constraint The ratchet joint.
/// @param ratchet The ratchet angle in radians.
void cpRatchetJointSetRatchet(int constraint, double ratchet) =>
    _callVoid('_cp_ratchet_joint_set_ratchet', [constraint.toJS, ratchet.toJS]);

// Gear Joint
/// Allocate and initialize a gear joint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param phase The phase offset in radians.
/// @param ratio The gear ratio.
/// @return A pointer to the new gear joint.
int cpGearJointNew(int bodyA, int bodyB, double phase, double ratio) => _callInt(
  '_cp_gear_joint_new',
  [bodyA.toJS, bodyB.toJS, phase.toJS, ratio.toJS],
);

/// Get the phase offset for a gear joint.
/// @param constraint The gear joint.
/// @return The phase offset in radians.
double cpGearJointGetPhase(int constraint) => _callDouble('_cp_gear_joint_get_phase', [constraint.toJS]);

/// Set the phase offset for a gear joint.
/// @param constraint The gear joint.
/// @param phase The phase offset in radians.
void cpGearJointSetPhase(int constraint, double phase) =>
    _callVoid('_cp_gear_joint_set_phase', [constraint.toJS, phase.toJS]);

/// Get the gear ratio for a gear joint.
/// @param constraint The gear joint.
/// @return The gear ratio.
double cpGearJointGetRatio(int constraint) => _callDouble('_cp_gear_joint_get_ratio', [constraint.toJS]);

/// Set the gear ratio for a gear joint.
/// @param constraint The gear joint.
/// @param ratio The gear ratio.
void cpGearJointSetRatio(int constraint, double ratio) =>
    _callVoid('_cp_gear_joint_set_ratio', [constraint.toJS, ratio.toJS]);

// Simple Motor
/// Allocate and initialize a simple motor constraint.
/// @param bodyA The first body to connect.
/// @param bodyB The second body to connect.
/// @param rate The rate of rotation in radians per second.
/// @return A pointer to the new simple motor constraint.
int cpSimpleMotorNew(int bodyA, int bodyB, double rate) =>
    _callInt('_cp_simple_motor_new', [bodyA.toJS, bodyB.toJS, rate.toJS]);

/// Get the rate of rotation for a simple motor.
/// @param constraint The simple motor.
/// @return The rate of rotation in radians per second.
double cpSimpleMotorGetRate(int constraint) => _callDouble('_cp_simple_motor_get_rate', [constraint.toJS]);

/// Set the rate of rotation for a simple motor.
/// @param constraint The simple motor.
/// @param rate The rate of rotation in radians per second.
void cpSimpleMotorSetRate(int constraint, double rate) =>
    _callVoid('_cp_simple_motor_set_rate', [constraint.toJS, rate.toJS]);

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
  final offsetPtr = _allocVect(offsetX, offsetY);
  final result = _callDouble(
    '_cp_moment_for_circle',
    [mass.toJS, r1.toJS, r2.toJS, offsetPtr.toJS],
  );
  _free(offsetPtr);
  return result;
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
  final aPtr = _allocVect(ax, ay);
  final bPtr = _allocVect(bx, by);
  final result = _callDouble(
    '_cp_moment_for_segment',
    [mass.toJS, aPtr.toJS, bPtr.toJS, radius.toJS],
  );
  _free(aPtr);
  _free(bPtr);
  return result;
}

/// Calculate the moment of inertia for a solid box.
/// @param mass The mass of the box.
/// @param width The width of the box.
/// @param height The height of the box.
/// @return The moment of inertia.
double cpMomentForBox(double mass, double width, double height) =>
    _callDouble('_cp_moment_for_box', [mass.toJS, width.toJS, height.toJS]);

/// Calculate the area of a hollow circle.
/// @param r1 The inner radius (0 for solid circles).
/// @param r2 The outer radius.
/// @return The area.
double cpAreaForCircle(double r1, double r2) {
  _ensureInitialized();
  return _callDouble('_cp_area_for_circle', [r1.toJS, r2.toJS]);
}

/// Calculate the area of a fattened (capsule shaped) line segment.
/// @param ax The x coordinate of the first endpoint.
/// @param ay The y coordinate of the first endpoint.
/// @param bx The x coordinate of the second endpoint.
/// @param by The y coordinate of the second endpoint.
/// @param radius The radius of the segment.
/// @return The area.
double cpAreaForSegment(double ax, double ay, double bx, double by, double radius) {
  _ensureInitialized();
  final aPtr = _allocVect(ax, ay);
  final bPtr = _allocVect(bx, by);
  final result = _callDouble(
    '_cp_area_for_segment',
    [aPtr.toJS, bPtr.toJS, radius.toJS],
  );
  _free(aPtr);
  _free(bPtr);
  return result;
}

/// Calculate the moment of inertia for a solid polygon shape.
/// @param mass The mass of the polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @param offsetX The x offset of the center of gravity.
/// @param offsetY The y offset of the center of gravity.
/// @param radius The radius (for rounded corners).
/// @return The moment of inertia.
double cpMomentForPoly(double mass, List<double> verts, double offsetX, double offsetY, double radius) {
  _ensureInitialized();
  if (verts.length % 2 != 0) {
    throw ArgumentError('Vertex list must have even number of elements (x, y pairs)');
  }
  final count = verts.length ~/ 2;
  final vertsPtr = _malloc(count * 16); // Each cpVect is 16 bytes
  for (var i = 0; i < count; i++) {
    _setDouble(vertsPtr + (i * 16), verts[i * 2]);
    _setDouble(vertsPtr + (i * 16) + 8, verts[i * 2 + 1]);
  }
  final offsetPtr = _allocVect(offsetX, offsetY);
  final result = _callDouble(
    '_cp_moment_for_poly',
    [
      mass.toJS,
      count.toJS,
      vertsPtr.toJS,
      offsetPtr.toJS,
      radius.toJS,
    ],
  );
  _free(vertsPtr);
  _free(offsetPtr);
  return result;
}

/// Calculate the signed area of a polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @param radius The radius (for rounded corners).
/// @return The signed area (clockwise winding gives positive area).
double cpAreaForPoly(List<double> verts, double radius) {
  _ensureInitialized();
  if (verts.length % 2 != 0) {
    throw ArgumentError('Vertex list must have even number of elements (x, y pairs)');
  }
  final count = verts.length ~/ 2;
  final vertsPtr = _malloc(count * 16);
  for (var i = 0; i < count; i++) {
    _setDouble(vertsPtr + (i * 16), verts[i * 2]);
    _setDouble(vertsPtr + (i * 16) + 8, verts[i * 2 + 1]);
  }
  final result = _callDouble(
    '_cp_area_for_poly',
    [
      count.toJS,
      vertsPtr.toJS,
      radius.toJS,
    ],
  );
  _free(vertsPtr);
  return result;
}

/// Calculate the centroid of a polygon.
/// @param verts The flattened list of vertices [x1, y1, x2, y2, ...].
/// @return A tuple of (x, y) centroid coordinates.
Vector cpCentroidForPoly(List<double> verts) {
  _ensureInitialized();
  if (verts.length % 2 != 0) {
    throw ArgumentError('Vertex list must have even number of elements (x, y pairs)');
  }
  final count = verts.length ~/ 2;
  final vertsPtr = _malloc(count * 16);
  for (var i = 0; i < count; i++) {
    _setDouble(vertsPtr + (i * 16), verts[i * 2]);
    _setDouble(vertsPtr + (i * 16) + 8, verts[i * 2 + 1]);
  }
  final resultPtr = _malloc(16);
  _callVoid(
    '_cp_centroid_for_poly',
    [
      count.toJS,
      vertsPtr.toJS,
      resultPtr.toJS,
    ],
  );
  final result = _readVect(resultPtr);
  _free(vertsPtr);
  _free(resultPtr);
  return result;
}

/// Calculate the moment of inertia for a box defined by a bounding box.
/// @param mass The mass of the box.
/// @param left The left edge of the bounding box.
/// @param bottom The bottom edge of the bounding box.
/// @param right The right edge of the bounding box.
/// @param top The top edge of the bounding box.
/// @return The moment of inertia.
double cpMomentForBox2(double mass, double left, double bottom, double right, double top) {
  _ensureInitialized();
  final bbPtr = _malloc(32); // cpBB is 32 bytes (4 doubles)
  _setDouble(bbPtr, left);
  _setDouble(bbPtr + 8, bottom);
  _setDouble(bbPtr + 16, right);
  _setDouble(bbPtr + 24, top);
  final result = _callDouble('_cp_moment_for_box2', [mass.toJS, bbPtr.toJS]);
  _free(bbPtr);
  return result;
}

/// Calculate the convex hull of a set of points.
/// @param points The flattened list of points [x1, y1, x2, y2, ...].
/// @param tolerance The tolerance for the convex hull calculation.
/// @return A flattened list of hull vertices [x1, y1, x2, y2, ...].
List<double> cpConvexHull(List<double> points, {double tolerance = 0.0}) {
  _ensureInitialized();
  if (points.length % 2 != 0) {
    throw ArgumentError('Point list must have even number of elements (x, y pairs)');
  }
  final count = points.length ~/ 2;
  final pointsPtr = _malloc(count * 16);
  for (var i = 0; i < count; i++) {
    _setDouble(pointsPtr + (i * 16), points[i * 2]);
    _setDouble(pointsPtr + (i * 16) + 8, points[i * 2 + 1]);
  }
  final resultPtr = _malloc(count * 16);
  final firstPtr = _malloc(4); // Int32
  final hullCount = _callInt(
    '_cp_convex_hull',
    [
      count.toJS,
      pointsPtr.toJS,
      resultPtr.toJS,
      firstPtr.toJS,
      tolerance.toJS,
    ],
  );
  _free(firstPtr);
  final result = <double>[];
  for (var i = 0; i < hullCount; i++) {
    final v = _readVect(resultPtr + (i * 16));
    result
      ..add(v.x)
      ..add(v.y);
  }
  _free(pointsPtr);
  _free(resultPtr);
  return result;
}
