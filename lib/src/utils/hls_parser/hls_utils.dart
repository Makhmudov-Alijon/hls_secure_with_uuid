// ignore_for_file: parameter_assignments

import 'dart:io';

class HlsUtils {
  static String getCurrentPath(Directory directory, String path) {
    final pathSegments = path.split('/');
    final includedDirectories = <String>[];
    var findDirectory = false;
    final directoryName = directory.path.split('/').last;

    if (directory.path == path) {
      return directoryName;
    }

    for (final path in pathSegments) {
      if (findDirectory) {
        includedDirectories.add(path);
      }
      if (path == directoryName) {
        findDirectory = true;
      }
    }

    return includedDirectories.join('/');
  }

  static String hlsUrlToLocal(
    Directory appDir,
    String url, [
    bool addFile = false,
  ]) {
    final urlSegments = url.split('/')
      ..removeAt(0)
      ..removeAt(1);
    return "${addFile ? "file://" : ""}${appDir.path}${urlSegments.join('/')}";
  }

  static String asciiToHex(String input) {
    return '0x${input.codeUnits.map((unit) => unit.toRadixString(16)).join()}';
  }

  static Future<List<File>> searchFilesByNameInDirectoryy(
      Directory directory, String fileName) async {
    final foundFiles = <File>[];

    if (!directory.existsSync()) {
      return foundFiles;
    }

    Future<void> searchDirectory(Directory directory) async {
      await for (final entity in directory.list(followLinks: false)) {
        if (entity is File && entity.path.endsWith('/local_hls.json')) {
          foundFiles.add(entity);
        } else if (entity is Directory) {
          await searchDirectory(entity);
        }
      }
    }

    await searchDirectory(directory);
    return foundFiles;
  }

  static Future<int?> getTotalDirectorySizee(Directory dir) async {
    var totalSize = 0;
    if (!dir.existsSync()) return null;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        if (!entity.existsSync()) return null;
        totalSize += await entity.length();
      }
    }

    return totalSize;
  }

  static int? getTotalDirectorySizeSync(Directory dir) {
    var totalSize = 0;
    if (!dir.existsSync()) return null;
    for (final entity in dir.listSync(recursive: true, followLinks: false)) {
      if (entity is File) {
        if (!entity.existsSync()) return null;
        totalSize += entity.lengthSync();
      }
    }

    return totalSize;
  }
}
