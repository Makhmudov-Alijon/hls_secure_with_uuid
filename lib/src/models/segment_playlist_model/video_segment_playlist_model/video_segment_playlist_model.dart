import 'package:download_manager/download_manager.dart';

class VideoSegmentPlaylistModel {
  const VideoSegmentPlaylistModel({
    required this.segments,
    required this.totalDuration,
    required this.resolution,
    required this.iv,
    required this.encKey,
    required this.encKeyUrl,
    required HlsPlaylistData playlistData,
    required HlsLinkSwapper linkSwapper,
    required HlsLinkSwapper keySwapper,
  })  : _playlistData = playlistData,
        _linkSwapper = linkSwapper,
        _keySwapper = keySwapper;

  factory VideoSegmentPlaylistModel.parse({
    required String playlist,
    required String encKey,
    required HlsPathManager pathManager,
    required HlsResolution resolution,
    required String? playlistBaseUrl,
    required String baseUrl,
  }) {
    final parsedPlaylist = HlsParser(playlist: playlist).parseData();
    final segments = <HlsSegment>[];
    final linkSwapper = HlsLinkSwapper(useAbsolute: false);
    final keySwapper = HlsLinkSwapper(useAbsolute: false);
    final baseDir = pathManager.videoDir(resolutionType: resolution.resolution);
    final encKeyUrl = parsedPlaylist.encKeyUrl;
    final iv = parsedPlaylist.iv;
    if (encKeyUrl == null) {
      throw UnimplementedError('encKey not found');
    } else if (iv == null) {
      throw UnimplementedError('iv not found');
    }
    keySwapper.addLinkFromFile(
      originalLink: encKeyUrl.url,
      file: pathManager.encKeyFile,
      baseDir: baseDir,
    );
    var totalDuration = 0.0;
    for (final item in parsedPlaylist.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        final duration = double.parse(
          item.hlsValueParameters[HlsParamConstants.empty]!.value,
        );
        final url = playlistBaseUrl == null
            ? item.url!
            : <String>[baseUrl, playlistBaseUrl, item.url!].join('/');
        totalDuration += duration;
        final saveFile = pathManager.fileFromVideo(
          url: url,
          resolutionType: resolution.resolution,
        );
        linkSwapper.addLinkFromUrl(
          url: url,
          saveFile: saveFile,
          baseDir: baseDir,
        );
        segments.add(
          HlsSegment(
            link: url,
            isVideo: true,
            duration: duration,
            saveFile: saveFile,
          ),
        );
      }
    }

    return VideoSegmentPlaylistModel(
      iv: iv,
      segments: segments,
      totalDuration: totalDuration,
      resolution: resolution,
      linkSwapper: linkSwapper,
      playlistData: parsedPlaylist,
      encKeyUrl: encKeyUrl,
      keySwapper: keySwapper,
      encKey: encKey,
    );
  }

  String toLocalPlaylist({required bool isForWatching}) {
    return _playlistData.toLocalPlaylist(
      linkSwapperGroup: HlsLinkSwapperGroup(
        swappers: [
          if (!isForWatching) _linkSwapper,
          _keySwapper,
        ],
      ),
    );
  }

  final HlsResolution resolution;
  final List<HlsSegment> segments;
  final double totalDuration;
  final HlsLinkSwapper _linkSwapper;
  final HlsPlaylistData _playlistData;
  final HlsEncryptionKey encKeyUrl;
  final String iv;
  final String encKey;
  final HlsLinkSwapper _keySwapper;
}
