// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:download_manager/download_manager.dart';

import '../../entities/thumbs_playlist_type.dart';

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

  /// Defines if hls should be paste inside remote folder
  final bool isRemote;

  bool get isSerial =>
      localHlsId.seasonId != null && localHlsId.episodeId != null;

  String get contentIdFolder {
    final contentId = localHlsId.contentId;
    final filmId = localHlsId.filmId;
    final seasonId = localHlsId.seasonId;
    final episodeId = localHlsId.episodeId;

    if (filmId != null && seasonId == null && episodeId == null) {
      return 'movies/${contentId}_$filmId';
    } else if (filmId == null && seasonId != null && episodeId != null) {
      return 'series/$contentId/season_$seasonId/episode_$episodeId';
    }

    throw UnimplementedError('Not specified required id');
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

  String _checkForBase(String url, [bool useAbsolute = true]) {
    return useAbsolute ? '${baseDir.path}/$url' : url;
  }

  String _hlsDataSource(bool isRemote) {
    return isRemote ? 'remote' : 'local';
  }

  String _masterPath({String? url, String? fileName}) {
    return _checkForBase(
      'media/${_hlsDataSource(isRemote)}/$contentIdFolder/${fileName ?? _filenameFromUrl(url)}',
    );
  }

  String _videoPath({
    required HlsResolutionType resolutionType,
    String? url,
    String? fileName,
  }) {
    return _checkForBase(
      'media/${_hlsDataSource(isRemote)}/$contentIdFolder/video/${resolutionType.quality}p/${fileName ?? _filenameFromUrl(url)}',
    );
  }

  String _thumbnailPath({
    required ThumbsPlaylistType thumbnailsType,
    required bool enableFilename,
  }) {
    return _checkForBase(
      'media/${_hlsDataSource(isRemote)}/$contentIdFolder/thumbnails/${enableFilename ? '${thumbnailsType.name}.vtt' : ''}',
    );
  }

  String _audioPath({
    required HlsAudioTrack audioTrack,
    String? url,
    String? fileName,
  }) {
    return _checkForBase(
      'media/${_hlsDataSource(isRemote)}/$contentIdFolder/audio/${audioTrack.trackName}/${audioTrack.trackType.shortName}/${fileName ?? _filenameFromUrl(url)}',
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

  Directory thumbnailDir({required ThumbsPlaylistType type}) => Directory(
        _thumbnailPath(
          thumbnailsType: type,
          enableFilename: false,
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

  File get masterFile {
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

  File thumbnailFile({required ThumbsPlaylistType playlistType}) {
    return File(
      _thumbnailPath(
        thumbnailsType: playlistType,
        enableFilename: true,
      ),
    );
  }

  File get mediaThumbnailsFile => File(
        _thumbnailPath(
          thumbnailsType: ThumbsPlaylistType.medium,
          enableFilename: true,
        ),
      );

  File get largeThumbnailsFile => File(
        _thumbnailPath(
          thumbnailsType: ThumbsPlaylistType.large,
          enableFilename: true,
        ),
      );

  File get posterFile => File(
        _masterPath(
          fileName: HlsFilenames.hlsPoster,
        ),
      );

  File get encKeyFile => File(
        _masterPath(
          fileName: HlsFilenames.enc,
        ),
      );
}
