/// Platform-agnostic Chipmunk2D bindings interface.
///
/// This file uses conditional imports to select the appropriate implementation:
/// - Native platforms (iOS, Android, macOS, Linux, Windows): Uses dart:ffi
/// - Web: Uses dart:js_interop to call Emscripten-compiled WASM
library;

// Export platform-specific implementations
export 'chipmunk_bindings_stub.dart'
    if (dart.library.ffi) 'chipmunk_bindings_native.dart'
    if (dart.library.js_interop) 'chipmunk_bindings_web.dart';
