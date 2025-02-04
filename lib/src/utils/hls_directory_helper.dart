import 'dart:io';

import 'package:path_provider/path_provider.dart';

class HlsDirectoryHelper {
  HlsDirectoryHelper._();

  static HlsDirectoryHelper instance = HlsDirectoryHelper._();

  late final Directory appDir;

  Future<void> initialize() async {
    appDir = await getApplicationDocumentsDirectory();
  }
}
