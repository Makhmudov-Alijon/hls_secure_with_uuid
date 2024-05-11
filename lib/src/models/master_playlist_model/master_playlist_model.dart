import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

import '../../utils/hls_parser/entities/hls_playlist_data.dart';
import 'hls_audio.dart';

class MasterPlaylistModel extends Equatable {
  const MasterPlaylistModel({
    required this.resolutions,
    required this.audioTrackGroups,
    required this.masterPlaylistData,
    this.segmentPlaylistKey,
  });

  factory MasterPlaylistModel.fromParsedPlaylist(
    HlsPlaylistData parsedMasterPlaylist, [
    HlsSegmentsPlaylistKey? segmentPlaylistKey,
  ]) {
    final resolutions = <HlsResolution>{};
    final trackMap = <String, Set<HlsAudioTrack>>{};

    // Fetching hls resolutions
    for (var i = 0; i < parsedMasterPlaylist.playlistItems.length; i++) {
      final item = parsedMasterPlaylist.playlistItems[i];
      final itemUrl = item.url;
      if (itemUrl != null) {
        for (final resolution in HlsResolutionType.values) {
          if (itemUrl.contains(resolution.title)) {
            final trackType = item.hlsValueParameters[HlsParamConstants.audio]
                ?.value.escapeQuotes;
            if (trackType != null) {
              resolutions.add(
                HlsResolution(
                  resolution: resolution,
                  videoPlaylistUrl: itemUrl,
                  trackType:
                      HlsAudioTrackType.values.first.fromString(trackType),
                ),
              );
            }
          }
        }
      }

      // Fetching hls audio tracks
      final typeParam = item.hlsValueParameters[HlsParamConstants.type];
      if (item.hlsKey == HlsKeyConstants.extXMedia &&
          typeParam != null &&
          typeParam == HlsParamValueConstants.audio) {
        final trackType = item
            .hlsValueParameters[HlsParamConstants.groupId]?.value.escapeQuotes;
        final trackUrl =
            item.hlsValueParameters[HlsParamConstants.uri]?.value.escapeQuotes;
        final trackName =
            item.hlsValueParameters[HlsParamConstants.name]?.value.escapeQuotes;
        if (trackType != null && trackUrl != null && trackName != null) {
          final track = HlsAudioTrack(
            trackType: HlsAudioTrackType.values.first.fromString(trackType),
            trackUrl: trackUrl,
            trackName: trackName,
          );
          if (trackMap[trackName] != null) {
            trackMap[trackName] = {
              ...trackMap[trackName]!,
              track,
            };
          } else {
            trackMap[trackName] = {track};
          }
        }
      }
    }

    final audioTrackGroups = <HlsAudioTrackGroup>{};

    for (final entry in trackMap.entries) {
      audioTrackGroups.add(
        HlsAudioTrackGroup(
          language: entry.key,
          tracks: entry.value,
        ),
      );
    }

    return MasterPlaylistModel(
      audioTrackGroups: audioTrackGroups,
      resolutions: resolutions,
      masterPlaylistData: parsedMasterPlaylist,
      segmentPlaylistKey: segmentPlaylistKey,
    );
  }

  final Set<HlsResolution> resolutions;
  final Set<HlsAudioTrackGroup> audioTrackGroups;
  final HlsPlaylistData masterPlaylistData;
  final HlsSegmentsPlaylistKey? segmentPlaylistKey;

  @override
  List<Object?> get props => [
        resolutions,
        audioTrackGroups,
        masterPlaylistData,
        segmentPlaylistKey,
      ];
}
