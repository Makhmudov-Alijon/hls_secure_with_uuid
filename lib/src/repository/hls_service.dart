import 'package:download_manager/src/models/segment_playlist_model/audio_segment_playlist_model/audio_segment_playlist_model.dart';
import 'package:download_manager/src/models/segment_playlist_model/video_segment_playlist_model/video_segment_playlist_model.dart';
import 'package:riverpod/riverpod.dart';

import '../../download_manager.dart';
import '../models/hls_data_model/hls_data_model.dart';
import '../utils/security/security.dart';

final hlsServiceProvider = Provider(
  (ref) => HlsService(),
);

class HlsService {
  Future<void> saveAudioMasterPlaylists({
    required HlsPathManager pathManager,
    required MasterPlaylistModel master,
    required bool isForWatching,
  }) async {
    for (final trackGroup in master.audioTrackGroups) {
      for (final audioTrack in trackGroup.tracks) {
        final parsedPlaylist = parseAudioTrackPlaylist(
          track: audioTrack,
          hlsData: master.hlsData,
          pathManager: pathManager,
        );

        pathManager.audioDir(audioTrack: audioTrack).createIfNotExist();

        final audioMaster = pathManager.audioMasterFile(
          audioTrack: audioTrack,
        )..createIfNotExist();

        await audioMaster.writeAsString(parsedPlaylist.toLocalPlaylist(
          isForWatching: isForWatching,
        ));
      }
    }
  }

  Future<void> saveVideoMasterPlaylists({
    required HlsPathManager pathManager,
    required MasterPlaylistModel master,
    required bool isForWatching,
  }) async {
    for (final resolution in master.resolutions) {
      final parsedPlaylist = parseResolutionPlaylist(
        resolution: resolution,
        hlsData: master.hlsData,
        pathManager: pathManager,
      );

      pathManager
          .videoDir(
            resolutionType: resolution.resolution,
          )
          .createIfNotExist();

      final videoMaster = pathManager.videoMasterFile(
        resolutionType: resolution.resolution,
      )..createIfNotExist();

      await videoMaster.writeAsString(
        parsedPlaylist.toLocalPlaylist(isForWatching: isForWatching),
      );
    }
  }

  Future<HlsDataModel> decryptPlaylistData({
    required String token,
    required String url,
    required String key,
    dynamic data,
  }) async {
    if (data is String) {
      final decrypted = await SecurityService().getDTD(
        data: data,
        token: token,
        key: key,
      );

      return HlsDataModel.fromJson(decrypted);
    } else if (data is Map<String, dynamic>) {
      return HlsDataModel.fromJson(data);
    } else {
      throw const FormatException('Playlist data type is not correct');
    }
  }

  AudioSegmentPlaylistModel parseAudioTrackPlaylist({
    required HlsAudioTrack track,
    required HlsDataModel hlsData,
    required HlsPathManager pathManager,
  }) {
    final playlist = hlsData.audioPlaylists
        .firstWhere(
          (element) => element.path == track.trackUrl,
        )
        .data;
    return AudioSegmentPlaylistModel.parse(
      playlist: playlist,
      audioTrack: track,
      pathManager: pathManager,
    );
  }

  VideoSegmentPlaylistModel parseResolutionPlaylist({
    required HlsResolution resolution,
    required HlsDataModel hlsData,
    required HlsPathManager pathManager,
  }) {
    final playlist = hlsData.videoPlaylists.firstWhere(
      (element) {
        return element.path == resolution.videoPlaylistUrl;
      },
    ).data;
    return VideoSegmentPlaylistModel.parse(
      playlist: playlist,
      pathManager: pathManager,
      resolution: resolution,
    );
  }
}
