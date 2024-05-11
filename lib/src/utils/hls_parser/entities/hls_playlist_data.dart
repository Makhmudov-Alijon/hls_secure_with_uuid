import '../../../../download_manager.dart';
import 'hls_playlist_item.dart';
import 'hls_playlist_type.dart';

class HlsPlaylistData {
  const HlsPlaylistData({
    required this.playlistItems,
    required this.playlistType,
  });

  final List<HlsPlaylistItem> playlistItems;
  final HlsPlaylistType playlistType;

  @override
  String toString() {
    return playlistItems.map((e) => e.toString()).join('\r\n');
  }

  Future<String> toLocalPlaylist({
    required HlsPathManager pathManager,
    bool ignoreSegments = false,
    bool ignoreOtherResolutions = true,
  }) async {
    final strings = <String>[];

    for (var item in playlistItems) {
      final url = item.url;
      switch (playlistType) {
        case HlsPlaylistType.masterPlaylist:
          if (url != null) {
            if (item.containsParam(param: HlsParamConstants.resolution)) {
              if (!url.contains(pathManager.resolutionType.title) &&
                  ignoreOtherResolutions) {
                continue;
              } else {
                item = item.copyWith(
                  url: pathManager
                      .videoFileFrom(
                        url,
                        HlsResolutionType.v1080p.fromString(url),
                      )
                      .playlistPath,
                );
              }
            }
          }

          if (item.containsParam(
              param: HlsParamConstants.type,
              paramValue: HlsParamValueConstants.audio)) {
            item = item.copyWith(
              hlsValueParameters: {
                ...item.hlsValueParameters,
                HlsParamConstants.uri: HlsParamValue(
                  value: pathManager
                      .audioFileFrom(
                          item.hlsValueParameters[HlsParamConstants.uri]!.value)
                      .playlistPath
                      .inQuotes,
                ),
              },
            );
          }
        case HlsPlaylistType.audioSegmentPlaylist:
          if (ignoreSegments) break;

          if (url != null) {
            item = item.copyWith(
              url: pathManager.audioFileFrom(url).playlistPath,
            );
          }

          if (item.containsParam(param: HlsParamConstants.method) &&
              item.containsParam(param: HlsParamConstants.uri)) {
            item = item.copyWith(
              hlsValueParameters: {
                ...item.hlsValueParameters,
                HlsParamConstants.uri: HlsParamValue(
                  value: pathManager
                      .masterFileFrom(
                          item.hlsValueParameters[HlsParamConstants.uri]!.value)
                      .playlistPath,
                ),
              },
            );
          }
        case HlsPlaylistType.videoSegmentPlaylist:
          if (ignoreSegments) break;

          if (url != null) {
            item = item.copyWith(
              url: pathManager.videoFileFrom(url).playlistPath,
            );
          }

          if (item.containsParam(param: HlsParamConstants.method) &&
              item.containsParam(param: HlsParamConstants.uri)) {
            item = item.copyWith(
              hlsValueParameters: {
                ...item.hlsValueParameters,
                HlsParamConstants.uri: HlsParamValue(
                  value: pathManager
                      .masterFileFrom(
                          item.hlsValueParameters[HlsParamConstants.uri]!.value)
                      .playlistPath,
                ),
              },
            );
          }
      }
      strings.add(item.toString());
    }
    return strings.join('\n');
  }
}
