## 1.0.4

- **Windows:** fixed native asset hook downloading the wrong prebuilt archive
  name (`windows-x86_64` vs published `windows-x64`), which caused “Prebuilt
  library not found” on Windows.
- **Android:** prebuilts are built with 16 KB ELF page-size compatibility
  (`-Wl,-z,max-page-size=16384` and `-DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON`)
  for Google Play / Android 15+ requirements.
- Prebuilt Chipmunk2D source revision is now **7.0.3-patch.2**
  (`chipmunk2d_version` in `pubspec.yaml`).

## 1.0.3

- Simplified `_dynamicImport` wrapper in web/index.html (now a one-liner)
- Added documentation requirement for web platform: `_dynamicImport` helper must
  be included in `web/index.html`
- Improved README with clear web setup instructions

## 1.0.2

- Removed unused dependencies (native_toolchain_c, path_provider)
- Cleaned up dependency list to only include required packages

## 1.0.1

- Minor updates to pubspec.yaml (added repository and issue_tracker fields)
- Merged download_prebuilt.dart into build.dart

## 1.0.0

- Initial release of chipmunk2d_physics_ffi
- Complete Dart FFI bindings for Chipmunk2D physics engine version 7.0.3
- Full API coverage with idiomatic Dart wrapper classes
- Support for all body types (dynamic, kinematic, static)
- Support for all shape types (circle, box, segment, polygon)
- Support for all 10 joint/constraint types
- Collision detection and filtering
- Spatial queries (point, segment, bounding box)
- Cross-platform support: iOS, Android, macOS, Linux, Windows, and Web
- Web support via Emscripten-compiled WASM module
- Comprehensive test suite
- Full dart doc documentation
