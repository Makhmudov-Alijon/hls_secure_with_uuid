// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:download_manager/download_manager.dart';

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
    required this.baseDir,
    required this.localHlsId,
    required this.isRemote,
  });

  /// This id identifies the path of movie folder
  final LocalHlsId localHlsId;

  /// Base directory where files will be saved
  final Directory baseDir;

  final bool isRemote;

  bool get isSerial =>
      localHlsId.seasonId != null && localHlsId.episodeId != null;

  String get movieIdFolder {
    return "${localHlsId.movieId}${isSerial ? "/${localHlsId.seasonId}/${localHlsId.episodeId}" : ""}";
  }

  String _filenameFromUrl(String? url) {
    if (url == null) {
      return '';
    } else if (url.contains('?')) {
      return url.split('?').first.split('/').last;
    } else {
      return url.split('/').last;
    }
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

  String _hlsDataSource(bool isRemote) {
    return isRemote ? 'remote' : 'local';
  }

  String _masterPath({
    String? url,
    String? fileName,
    bool enablePrefix = false,
    bool useAbsolute = true,
  }) {
    return _checkLink(
      'media/${_hlsDataSource(isRemote)}/$movieIdFolder/${fileName ?? _filenameFromUrl(url)}',
      enablePrefix,
      useAbsolute,
    );
  }

  String _videoPath({
    required HlsResolutionType resolutionType,
    String? url,
    String? fileName,
    bool enablePrefix = false,
    bool useAbsolute = true,
  }) {
    return _checkLink(
      'media/${_hlsDataSource(isRemote)}/$movieIdFolder/video/${resolutionType.quality}p/${fileName ?? _filenameFromUrl(url)}',
      enablePrefix,
      useAbsolute,
    );
  }

  String _audioPath({
    required HlsAudioTrack audioTrack,
    String? url,
    String? fileName,
    bool enablePrefix = false,
    bool useAbsolute = true,
  }) {
    print("filename: ${_filenameFromUrl(url)}");
    return _checkLink(
      'media/${_hlsDataSource(isRemote)}/$movieIdFolder/audio/${audioTrack.trackName}/${audioTrack.trackType.shortName}/${fileName ?? _filenameFromUrl(url)}',
      enablePrefix,
      useAbsolute,
    );
  }

  Directory get masterDir => Directory(_masterPath());

  Directory audioDir({required HlsAudioTrack audioTrack}) => Directory(
        _audioPath(
          audioTrack: audioTrack,
        ),
      );

  Directory videoDir({required HlsResolutionType resolutionType}) => Directory(
        _videoPath(
          resolutionType: resolutionType,
        ),
      );

  File fileFromMaster(String url) {
    return File(
      _masterPath(
        url: url,
      ),
    );
  }

  File fileFromVideo({
    required String url,
    required HlsResolutionType resolutionType,
  }) {
    return File(
      _videoPath(
        url: url,
        resolutionType: resolutionType,
      ),
    );
  }

  File fileFromAudio({
    required String url,
    required HlsAudioTrack audioTrack,
  }) {
    return File(
      _audioPath(
        url: url,
        audioTrack: audioTrack,
      ),
    );
  }

  File masterFile() {
    return File(
      _masterPath(
        fileName: HlsFilenames.master,
      ),
    );
  }

  File audioMasterFile({required HlsAudioTrack audioTrack}) {
    return File(
      _audioPath(
        fileName: HlsFilenames.master,
        audioTrack: audioTrack,
      ),
    );
  }

  File videoMasterFile({required HlsResolutionType resolutionType}) {
    return File(
      _videoPath(
        fileName: HlsFilenames.master,
        resolutionType: resolutionType,
      ),
    );
  }

  File get posterFile => File(
        _masterPath(
          fileName: HlsFilenames.hlsPoster,
        ),
      );

  File get localHlsFile => File(
        _masterPath(
          fileName: HlsFilenames.localHlsJson,
        ),
      );

  File get downloadTaskFile => File(
        _masterPath(
          fileName: HlsFilenames.downloadTask,
        ),
      );

  File get encKeyFile => File(
        _masterPath(
          fileName: HlsFilenames.enc,
        ),
      );
}
