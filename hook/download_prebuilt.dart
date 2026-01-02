import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

Future<String?> downloadPrebuiltLibrary({
  required OS targetOS,
  required Architecture architecture,
  required String version,
  required String outputDir,
}) async {
  // Map OS names to match GitHub release asset names
  final osName = _mapOSName(targetOS);
  final archName = _mapArchName(architecture, targetOS);

  final archiveName = 'chipmunk2d_physics_ffi-$osName-$archName.tar.gz';
  final url = 'https://github.com/tguerin/chipmunk2d_physics_ffi/releases/download/prebuilt-$version/$archiveName';

  final archiveFile = File(path.join(outputDir, archiveName));
  final extractDir = Directory(path.join(outputDir, 'extracted_$archName'));

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return null;
    }

    await archiveFile.writeAsBytes(response.bodyBytes);

    if (extractDir.existsSync()) await extractDir.delete(recursive: true);
    await extractDir.create(recursive: true);

    final result = await Process.run('tar', ['-xzf', archiveFile.path, '-C', extractDir.path]);
    if (result.exitCode != 0) {
      return null;
    }

    await for (final entity in extractDir.list(recursive: true)) {
      if (entity is File) {
        final basename = path.basename(entity.path);
        // Match any file that contains chipmunk2d_physics_ffi and has the right extension
        if (basename.contains('chipmunk2d_physics_ffi') &&
            (basename.endsWith('.dylib') ||
                basename.endsWith('.so') ||
                basename.endsWith('.dll') ||
                basename.endsWith('.js') ||
                basename.endsWith('.wasm'))) {
          return entity.path;
        }
      }
    }
  } on Exception catch (_) {
    return null;
  } finally {
    if (archiveFile.existsSync()) await archiveFile.delete();
  }
  return null;
}

String _mapOSName(OS os) {
  // Map code_assets OS names to GitHub release asset names
  switch (os) {
    case OS.macOS:
      return 'macos';
    case OS.iOS:
      return 'ios';
    case OS.linux:
      return 'linux';
    case OS.windows:
      return 'windows';
    case OS.android:
      return 'android';
    default:
      return os.name.toLowerCase();
  }
}

String _mapArchName(Architecture arch, OS os) {
  // Map architecture names to match GitHub release asset names
  if (os == OS.iOS) {
    // iOS has special naming: arch-sdk (e.g., arm64-iphoneos, arm64-iphonesimulator)
    // This is handled separately in the workflow, but for now we'll use a simple mapping
    return arch.name;
  }

  switch (arch) {
    case Architecture.arm64:
      if (os == OS.android) return 'arm64-v8a';
      return 'arm64';
    case Architecture.x64:
      if (os == OS.linux) return 'x64';
      if (os == OS.android) return 'x86_64';
      return 'x86_64';
    default:
      // Handle other architectures by name
      final archName = arch.name;
      if (os == OS.android && archName.contains('arm')) {
        // Check if it's 32-bit arm
        if (archName.contains('32') || archName == 'arm') return 'armeabi-v7a';
      }
      return archName;
  }
}
