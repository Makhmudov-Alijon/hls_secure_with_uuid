// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../utils/hls_parser/entities/hls_playlist_data.dart';
import '../../utils/hls_parser/hls_constants.dart';
import 'hls_segment.dart';

class SegmentPlaylistParsedModel {
  SegmentPlaylistParsedModel({
    required this.segments,
    required this.playlistData,
    required this.totalDuration,
  });

  final Set<HlsSegment> segments;
  final HlsPlaylistData playlistData;
  final double totalDuration;

  factory SegmentPlaylistParsedModel.fromParsedPlaylist({
    required HlsPlaylistData playlistData,
    required bool isVideo,
  }) {
    final segments = <HlsSegment>{};
    var totalDuration = 0.0;
    for (final item in playlistData.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        final duration = double.parse(
          item.hlsValueParameters[HlsParamConstants.empty]!.value,
        );
        totalDuration += duration;
        segments.add(
          HlsSegment(
            link: item.url!,
            isVideo: isVideo,
            duration: duration,
          ),
        );
      }
    }

    return SegmentPlaylistParsedModel(
      segments: segments,
      playlistData: playlistData,
      totalDuration: totalDuration,
    );
  }
}
