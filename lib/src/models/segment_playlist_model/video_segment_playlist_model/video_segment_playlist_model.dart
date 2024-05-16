import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/utils/hls_link_swapper/hls_link_swapper_group.dart';
import 'package:download_manager/src/utils/hls_parser/entities/hls_playlist_data.dart';

import '../../../utils/hls_link_swapper/hls_link_swapper.dart';
import '../../master_playlist_model/hls_enctyption_key.dart';

class VideoSegmentPlaylistModel {
  const VideoSegmentPlaylistModel({
    required this.segments,
    required this.totalDuration,
    required this.resolution,
    required HlsPlaylistData playlistData,
    required HlsLinkSwapper linkSwapper,
    required HlsLinkSwapper keySwapper,
    this.encKey,
  })  : _playlistData = playlistData,
        _linkSwapper = linkSwapper,
        _keySwapper = keySwapper;

  factory VideoSegmentPlaylistModel.parse({
    required String playlist,
    required HlsPathManager pathManager,
    required HlsResolution resolution,
  }) {
    final parsedPlaylist = HlsParser(playlist: playlist).parseData();
    final segments = <HlsSegment>[];
    final linkSwapper = HlsLinkSwapper(useAbsolute: false);
    final keySwapper = HlsLinkSwapper(useAbsolute: false);
    final baseDir = pathManager.videoDir(resolutionType: resolution.resolution);
    final encKey = parsedPlaylist.encKey;
    if (encKey != null) {
      keySwapper.addLinkFromFile(
        originalLink: encKey.url,
        file: pathManager.encKeyFile,
        baseDir: baseDir,
      );
    }
    var totalDuration = 0.0;
    for (final item in parsedPlaylist.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        final duration = double.parse(
          item.hlsValueParameters[HlsParamConstants.empty]!.value,
        );
        final url = item.url!;
        totalDuration += duration;
        final saveFile = pathManager.fileFromVideo(
          url: item.url!,
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
      segments: segments,
      totalDuration: totalDuration,
      resolution: resolution,
      linkSwapper: linkSwapper,
      playlistData: parsedPlaylist,
      encKey: encKey,
      keySwapper: keySwapper,
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
  final HlsEncryptionKey? encKey;
  final HlsLinkSwapper _keySwapper;
}
