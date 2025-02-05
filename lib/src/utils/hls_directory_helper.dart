import 'dart:io';


import 'package:path_provider/path_provider.dart';

class HlsDirectoryHelper {
  HlsDirectoryHelper._();

  static HlsDirectoryHelper instance = HlsDirectoryHelper._();

  Directory? _appDir;

  Directory get appDir {
    try {
      return _appDir!;
    } catch (e) {
      throw Exception('HlsDirectoryHelper');
    }
  }

  Future<void> initialize() async {
    _appDir = await getApplicationDocumentsDirectory();
  }
}
