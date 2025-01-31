import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';
@Embedded(inheritance: false)
class MasterPlaylistModel extends Equatable {
  const MasterPlaylistModel({
    required this.resolutions,
    required this.audioTrackGroups,
    required HlsPlaylistData playlistData,
    required this.hlsData,
    required HlsLinkSwapper linkSwapper,
  })  : _masterPlaylistData = playlistData,
        _linkSwapper = linkSwapper;

  factory MasterPlaylistModel.parse({
    required String playlist,
    required HlsFullNonParsedModel hlsData,
    required HlsPathManager pathManager,
  }) {
    final resolutions = <HlsResolution>{};
    final trackMap = <String, Set<HlsAudioTrack>>{};
    final parsedPlaylist = HlsParser(playlist: playlist).parseData();
    // Fetching hls resolutions
    for (var i = 0; i < parsedPlaylist.playlistItems.length; i++) {
      final item = parsedPlaylist.playlistItems[i];
      final itemUrl = item.url;
      if (itemUrl != null) {
        for (final resolution in HlsResolutionType.values) {
          if (itemUrl.contains(resolution.title)) {
            final trackType = item.hlsValueParameters[HlsParamConstants.audio]
                ?.value.escapeQuotes;
            if (trackType != null) {
              final resolutionDetailsIndex =
                  hlsData.videoPlaylists.indexWhere((element) {
                return element.path == itemUrl;
              });

              if (resolutionDetailsIndex >= 0) {
                final resolutionDetails =
                    hlsData.videoPlaylists[resolutionDetailsIndex];
                resolutions.add(
                  HlsResolution(
                    resolution: resolution,
                    videoPlaylistUrl: itemUrl,
                    filesCount: resolutionDetails.filesCount,
                    size: resolutionDetails.size,
                    trackType:
                        HlsAudioTrackType.values.first.fromString(trackType),
                  ),
                );
              }
            }
            break;
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
          final trackDetailsIndex = hlsData.audioPlaylists.indexWhere(
            (element) => element.path == trackUrl,
          );

          if (trackDetailsIndex >= 0) {
            final trackDetails = hlsData.audioPlaylists[trackDetailsIndex];
            final track = HlsAudioTrack(
              filesCount: trackDetails.filesCount,
              size: trackDetails.size,
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
      playlistData: parsedPlaylist,
      hlsData: hlsData,
      linkSwapper: _getMasterLinkSwapper(
        pathManager: pathManager,
        trackGroups: audioTrackGroups,
        resolutions: resolutions,
      ),
    );
  }

  String toLocalPlaylist({HlsLinkExcluder? linkExcluder}) {
    return _masterPlaylistData.toLocalPlaylist(
      linkExcluder: linkExcluder,
      linkSwapperGroup: HlsLinkSwapperGroup(
        swappers: [_linkSwapper],
      ),
    );
  }

  static HlsLinkSwapper _getMasterLinkSwapper({
    required HlsPathManager pathManager,
    required Set<HlsAudioTrackGroup> trackGroups,
    required Set<HlsResolution> resolutions,
  }) {
    final masterSwapper = HlsLinkSwapper(useAbsolute: false);

    for (final resolution in resolutions) {
      final videoMasterFile = pathManager.videoMasterFile(
        resolutionType: resolution.resolution,
      );
      masterSwapper.addLinkFromFile(
        originalLink: resolution.videoPlaylistUrl,
        file: videoMasterFile,
        baseDir: pathManager.masterDir,
      );
    }

    for (final audioGroup in trackGroups) {
      for (final audioTrack in audioGroup.tracks) {
        final audioMasterFile =
            pathManager.audioMasterFile(audioTrack: audioTrack);
        masterSwapper.addLinkFromFile(
          originalLink: audioTrack.trackUrl,
          baseDir: pathManager.masterDir,
          file: audioMasterFile,
        );
      }
    }

    return masterSwapper;
  }

  final Set<HlsResolution> resolutions;
  final Set<HlsAudioTrackGroup> audioTrackGroups;
  final HlsPlaylistData _masterPlaylistData;
  final HlsFullNonParsedModel hlsData;
  final HlsLinkSwapper _linkSwapper;

  @override
  List<Object?> get props => [
        resolutions,
        audioTrackGroups,
        _masterPlaylistData,
        hlsData,
      ];
}
