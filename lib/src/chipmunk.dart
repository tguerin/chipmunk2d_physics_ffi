/// Cross-platform Chipmunk2D initialization.
///
/// This file provides a unified way to initialize Chipmunk2D on all platforms.
///
/// ## Usage
///
/// **On web, you must call `initializeChipmunk()` before using any Chipmunk2D functions:**
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Required on web, no-op on native platforms
///   await initializeChipmunk();
///
///   runApp(MyApp());
/// }
/// ```
///
/// On native platforms (iOS, Android, macOS, Linux, Windows), initialization
/// is automatic and this function is a no-op.
library;

export 'platform/chipmunk_bindings.dart' show initializeChipmunk, isChipmunkInitialized;
