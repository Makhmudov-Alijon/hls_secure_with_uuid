import 'dart:io';

import 'package:path_provider/path_provider.dart';

class HlsPathConstants {
  static Future<Directory> get baseDir => getApplicationDocumentsDirectory();

  static Future<Directory> get mediaDir async {
    return Directory("${(await baseDir).path}/${HlsFolders.media}");
  }
}

class HlsFolders {
  static const media = 'media';

  static const video = 'video';

  static const audio = 'audio';
}

class HlsFilenames {
  static const localHlsJson = 'local_hls.json';

  static const hlsPoster = 'poster.png';

  static const downloadTask = 'download_task.json';
}
