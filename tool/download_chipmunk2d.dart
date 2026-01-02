#!/usr/bin/env dart
// We can use print because this is a tool script
// ignore_for_file: avoid_print
// Script to download Chipmunk2D source code for a specific version

import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart tool/download_chipmunk2d.dart <version>');
    print('Example: dart tool/download_chipmunk2d.dart 7.0.3');
    print('Example: dart tool/download_chipmunk2d.dart 7.0.3-patch.1');
    exit(1);
  }

  final version = args[0];
  final chipmunkDir = Directory('chipmunk2d');

  // Remove existing directory if it exists
  if (chipmunkDir.existsSync()) {
    await chipmunkDir.delete(recursive: true);
  }

  print('Downloading Chipmunk2D version: $version');

  // Download from GitHub
  // Use fork only for patched versions, otherwise use original repo
  final String repo;
  final String tag;
  if (version.contains('patch')) {
    repo = 'tguerin/Chipmunk2D';
    tag = version;
  } else {
    repo = 'slembcke/Chipmunk2D';
    tag = 'Chipmunk-$version';
  }
  final url = 'https://github.com/$repo/archive/refs/tags/$tag.tar.gz';
  final tarFile = File('chipmunk2d.tar.gz');

  final process = await Process.start('curl', ['-L', '-o', tarFile.path, url]);
  await process.exitCode;

  if (!tarFile.existsSync()) {
    print('Error: Failed to download Chipmunk2D');
    exit(1);
  }

  // Extract tar.gz
  print('Extracting...');
  final extractProcess = await Process.start('tar', ['-xzf', tarFile.path]);
  await extractProcess.exitCode;

  // Find the extracted directory
  // Handle both tag formats: Chipmunk-7.0.3 and 7.0.3-patch.1
  final extractedDir = Directory('Chipmunk2D-${tag.replaceAll('v', '')}');
  if (!extractedDir.existsSync()) {
    // Try alternative naming
    final altDir = Directory('Chipmunk2D-$version');
    if (altDir.existsSync()) {
      await altDir.rename(chipmunkDir.path);
    } else {
      print('Error: Could not find extracted directory');
      exit(1);
    }
  } else {
    await extractedDir.rename(chipmunkDir.path);
  }

  // Clean up tar file
  await tarFile.delete();

  print('Chipmunk2D downloaded successfully to: ${chipmunkDir.path}');
}
