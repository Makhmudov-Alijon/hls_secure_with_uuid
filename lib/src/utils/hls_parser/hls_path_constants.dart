import 'dart:io';

import 'package:path_provider/path_provider.dart';

class HlsPathConstants {
  static Future<Directory> get baseDir => getApplicationDocumentsDirectory();

  static Future<Directory> get mediaDir async {
    return Directory(
      '${(await baseDir).path}/${HlsFolders.media}/${HlsFolders.local}',
    );
  }
}

class HlsFolders {
  static const media = 'media';

  static const video = 'video';

  static const audio = 'audio';

  static const remote = 'remote';

  static const local = 'local';
}

class HlsFilenames {

  static const hlsPoster = 'poster.png';


  static const master = 'master.m3u8';

  static const enc = 'enc.key';
}
