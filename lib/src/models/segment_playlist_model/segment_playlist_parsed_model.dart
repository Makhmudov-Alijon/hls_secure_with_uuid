// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../utils/hls_parser/hls_constants.dart';
import '../../utils/hls_parser/hls_parser.dart';
import 'hls_segment.dart';
import 'hls_segment_playlist_key.dart';

class SegmentPlaylistParsedModel {
  SegmentPlaylistParsedModel({
    required this.segments,
    required this.playlistData,
    this.playlistKey,
    required this.totalDuration,
  });

  final Set<HlsSegment> segments;
  final HlsPlaylistData playlistData;
  final HlsSegmentsPlaylistKey? playlistKey;
  final double totalDuration;

  factory SegmentPlaylistParsedModel.fromParsedPlaylist(
    HlsPlaylistData playlistData,
    bool isVideo, [
    HlsSegmentsPlaylistKey? playlistKey,
  ]) {
    final segments = <HlsSegment>{};
    var totalDuration = 0.0;
    for (var item in playlistData.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        final duration = double.parse(
            item.hlsValueParameters[HlsParamConstants.empty]!.value);
        totalDuration += duration;
        segments.add(
            HlsSegment(link: item.url!, isVideo: isVideo, duration: duration));
      }
    }

    return SegmentPlaylistParsedModel(
      segments: segments,
      playlistData: playlistData,
      playlistKey: playlistKey,
      totalDuration: totalDuration,
    );
  }
}
