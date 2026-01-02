import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import 'download_prebuilt.dart';

final _logger = Logger('build');

void main(List<String> args) async {
  await build(args, (input, output) async {
    // Only build if code assets are requested for this invocation
    if (!input.config.buildCodeAssets) return;

    final targetOS = input.config.code.targetOS;
    final targetArch = input.config.code.targetArchitecture;
    final version = _getPackageVersion();

    _logger.info('Handling build for $targetOS ($targetArch)');

    try {
      // 1. Download the prebuilt library
      final prebuiltLibPath = await downloadPrebuiltLibrary(
        targetOS: targetOS,
        architecture: targetArch,
        version: version,
        outputDir: input.outputDirectory.toFilePath(),
      );

      if (prebuiltLibPath == null) {
        throw Exception('Prebuilt library not found for $targetOS $targetArch');
      }

      final libFile = File(prebuiltLibPath);
      final finalPath = input.outputDirectory.resolve(path.basename(prebuiltLibPath));

      // 2. Copy the file to the output directory
      await libFile.copy(finalPath.toFilePath());

      // 3. Register the asset using the new simplified constructor
      // The OS and Architecture are contextually inferred from the BuildOutput
      output.assets.code.add(
        CodeAsset(
          package: input.packageName,
          name: 'chipmunk2d_physics_ffi', // Used for @Native('chipmunk2d_physics_ffi')
          file: finalPath,
          linkMode: DynamicLoadingBundled(),
        ),
      );

      _logger.info('Code asset registered: package:${input.packageName}/chipmunk2d_physics_ffi');
    } catch (e) {
      _logger.severe('Build hook failed: $e');
      rethrow;
    }
  });
}

String _getPackageVersion() {
  final pubspec = File('pubspec.yaml');
  if (pubspec.existsSync()) {
    final content = pubspec.readAsStringSync();
    // First try to get chipmunk2d_version
    final chipmunkMatch = RegExp(r'^chipmunk2d_version:\s*(.+)$', multiLine: true).firstMatch(content);
    if (chipmunkMatch != null) {
      return chipmunkMatch.group(1)?.trim() ?? '7.0.3';
    }
    // Fallback to package version
    final match = RegExp(r'^version:\s*(.+)$', multiLine: true).firstMatch(content);
    return match?.group(1)?.trim().split('+').first ?? '7.0.3';
  }
  return '7.0.3';
}
