import 'dart:io';

import '../../models/local_hls_model/local_hls_id.dart';
import '../../models/master_playlist_model/hls_resolution.dart';
import 'hls_path_constants.dart';

extension FileSystemEntityExtension on FileSystemEntity {
  String get fileName => path.split('?').first.split('/').last;
}

extension FileExtension on File {
  String get fileExtension => fileName.split('.').last;

  String get playlistPath => 'file://$path';

  void createIfNotExist() {
    final file = this;
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
  }
}

extension DirectoryExtension on Directory {
  void createIfNotExist() {
    final directory = this;
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }
}

extension HlsStringExtension on String {
  String get inQuotes => '"$this"';

  String get escapeQuotes => replaceAll('"', '');
}

class HlsPathManager {
  const HlsPathManager({
    required this.resolutionType,
    required this.baseDir,
    required this.localHlsId,
  });

  final LocalHlsId localHlsId;

  final HlsResolutionType resolutionType;

  bool get isSerial =>
      localHlsId.seasonId != null && localHlsId.episodeId != null;

  /// Base directory where files will be saved
  final Directory baseDir;

  String get movieIdFolder {
    return "${localHlsId.movieId}${isSerial ? "/${localHlsId.seasonId}/${localHlsId.episodeId}" : ""}";
  }

  String _getFileName(String? url) {
    return url?.split('?').first.split('/').last ?? '';
  }

  String _checkForPrefix(String url, bool enablePrefix) {
    return enablePrefix ? "file://$url" : url;
  }

  String _checkForBase(String url, bool enableBase) {
    return enableBase ? "${baseDir.path}/$url" : url;
  }

  String _checkLink(String url, bool enablePrefix, bool enableBase) {
    return _checkForPrefix(
      _checkForBase(
        url,
        enableBase,
      ),
      enablePrefix,
    );
  }

  String _masterPath(
      [String? url, bool enablePrefix = false, bool enableBase = true]) {
    return _checkLink(
      'media/$movieIdFolder/${_getFileName(url)}',
      enablePrefix,
      enableBase,
    );
  }

  String _videoPath([
    String? url,
    bool enablePrefix = false,
    bool enableBase = true,
    HlsResolutionType? resolutionType,
  ]) {
    return _checkLink(
      'media/$movieIdFolder/video/${(resolutionType ?? this.resolutionType).quality}p/${_getFileName(url)}',
      enablePrefix,
      enableBase,
    );
  }

  String _audioPath(
      [String? url, bool enablePrefix = false, bool enableBase = true]) {
    return _checkLink(
      'media/$movieIdFolder/audio/${_getFileName(url)}',
      enablePrefix,
      enableBase,
    );
  }

  Directory get masterDir => Directory(_masterPath());

  Directory get audioDir => Directory(_audioPath());

  Directory get videoDir => Directory(_videoPath());

  Directory get relativeMasterDir => Directory(_masterPath(null, false, false));

  Directory get relativeAudioDir => Directory(_audioPath(null, false, false));

  Directory get relativeVideoDir => Directory(_videoPath(null, false, false));

  File masterFileFrom(String url) {
    return File(_masterPath(url));
  }

  File videoFileFrom(String url, [HlsResolutionType? resolutionType]) {
    return File(_videoPath(url, false, true, resolutionType));
  }

  File audioFileFrom(String url) {
    return File(_audioPath(url));
  }

  File get posterFile => File('${masterDir.path}/${HlsFilenames.hlsPoster}');

  File get localHlsFile =>
      File('${masterDir.path}/${HlsFilenames.localHlsJson}');

  File get downloadTaskFile =>
      File('${masterDir.path}/${HlsFilenames.downloadTask}');
}
