// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:download_manager/src/models/master_playlist_model/hls_audio.dart';

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
    required this.audioTrack,
  });

  final LocalHlsId localHlsId;

  final HlsResolutionType resolutionType;

  final HlsAudioTrack audioTrack;

  /// Base directory where files will be saved
  final Directory baseDir;

  bool get isSerial =>
      localHlsId.seasonId != null && localHlsId.episodeId != null;

  String get movieIdFolder {
    return "${localHlsId.movieId}${isSerial ? "/${localHlsId.seasonId}/${localHlsId.episodeId}" : ""}";
  }

  String _getFileName(String? url) {
    return url?.split('?').first.split('/').last ?? '';
  }

  String _checkForPrefix(String url, bool enablePrefix) {
    return enablePrefix ? 'file://$url' : url;
  }

  String _checkForBase(String url, bool useAbsolute) {
    return useAbsolute ? '${baseDir.path}/$url' : url;
  }

  String _checkLink(String url, bool enablePrefix, bool useAbsolute) {
    return _checkForPrefix(
      _checkForBase(
        url,
        useAbsolute,
      ),
      enablePrefix,
    );
  }

  String _masterPath([
    String? url,
    String? fileName,
    bool enablePrefix = false,
    bool useAbsolute = true,
  ]) {
    return _checkLink(
      'media/$movieIdFolder/${fileName ?? _getFileName(url)}',
      enablePrefix,
      useAbsolute,
    );
  }

  String _videoPath([
    String? url,
    String? fileName,
    bool enablePrefix = false,
    bool useAbsolute = true,
    HlsResolutionType? resolutionType,
  ]) {
    return _checkLink(
      'media/$movieIdFolder/video/${(resolutionType ?? this.resolutionType).quality}p/${fileName ?? _getFileName(url)}',
      enablePrefix,
      useAbsolute,
    );
  }

  String _audioPath([
    String? url,
    String? fileName,
    bool enablePrefix = false,
    bool useAbsolute = true,
    HlsAudioTrack? audioTrack,
  ]) {
    final track = audioTrack ?? this.audioTrack;
    return _checkLink(
      'media/$movieIdFolder/audio/${track.trackName}/${track.trackType.shortName}/${fileName ?? _getFileName(url)}',
      enablePrefix,
      useAbsolute,
    );
  }

  Directory get masterDir => Directory(_masterPath());

  Directory get audioDir => Directory(_audioPath());

  Directory get videoDir => Directory(_videoPath());

  Directory get relativeMasterDir =>
      Directory(_masterPath(null, null, false, false));

  Directory get relativeAudioDir =>
      Directory(_audioPath(null, null, false, false));

  Directory get relativeVideoDir =>
      Directory(_videoPath(null, null, false, false));

  File masterFileFrom(String url) {
    return File(_masterPath(url));
  }

  File videoFileFrom(String url, [HlsResolutionType? resolutionType]) {
    return File(_videoPath(url, null, false, true, resolutionType));
  }

  File audioFileFrom(String url) {
    return File(_audioPath(url));
  }

  File masterFile() {
    return File(_masterPath(null, HlsFilenames.master));
  }

  File audioMasterFile() {
    return File(_audioPath(null, HlsFilenames.master));
  }

  File videoMasterFile() {
    return File(_videoPath(null, HlsFilenames.master));
  }

  File get posterFile => File('${masterDir.path}/${HlsFilenames.hlsPoster}');

  File get localHlsFile =>
      File('${masterDir.path}/${HlsFilenames.localHlsJson}');

  File get downloadTaskFile =>
      File('${masterDir.path}/${HlsFilenames.downloadTask}');
}
