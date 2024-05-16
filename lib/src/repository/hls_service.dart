import 'package:download_manager/src/models/hls_full_playlist_model/hls_full_playlist_model.dart';
import 'package:download_manager/src/models/segment_playlist_model/audio_segment_playlist_model/audio_segment_playlist_model.dart';
import 'package:download_manager/src/models/segment_playlist_model/video_segment_playlist_model/video_segment_playlist_model.dart';
import 'package:download_manager/src/utils/hls_link_exlcluder/hls_link_excluder.dart';
import 'package:riverpod/riverpod.dart';

import '../../download_manager.dart';
import '../models/hls_data_model/hls_data_model.dart';
import '../utils/security/security.dart';

final hlsServiceProvider = Provider(
  (ref) => HlsService(),
);

class HlsService {
  Future<HlsFullPlaylistModel> saveSegmentPlaylists({
    required HlsPathManager pathManager,
    required MasterPlaylistModel master,
    required bool isForWatching,
    Set<HlsAudioTrack>? selectedTracks,
    Set<HlsResolution>? selectedResolutions,
  }) async {
    final masterLinkExcluder = HlsLinkExcluder();
    final audioPlaylists = <AudioSegmentPlaylistModel>[];
    final videoPlaylists = <VideoSegmentPlaylistModel>[];

    for (final trackGroup in master.audioTrackGroups) {
      for (final audioTrack in trackGroup.tracks) {
        if (selectedTracks != null && !selectedTracks.contains(audioTrack)) {
          masterLinkExcluder.addLink(audioTrack.trackUrl);
          continue;
        }
        final parsedPlaylist = parseAudioTrackPlaylist(
          track: audioTrack,
          hlsData: master.hlsData,
          pathManager: pathManager,
        );

        audioPlaylists.add(parsedPlaylist);

        pathManager.audioDir(audioTrack: audioTrack).createIfNotExist();

        final audioMaster = pathManager.audioMasterFile(
          audioTrack: audioTrack,
        )..createIfNotExist();

        await audioMaster.writeAsString(
          parsedPlaylist.toLocalPlaylist(
            isForWatching: isForWatching,
          ),
        );
      }
    }

    for (final resolution in master.resolutions) {
      if (selectedResolutions != null &&
          !selectedResolutions.contains(resolution)) {
        masterLinkExcluder.addLink(resolution.videoPlaylistUrl);
        continue;
      }

      final parsedPlaylist = parseResolutionPlaylist(
        resolution: resolution,
        hlsData: master.hlsData,
        pathManager: pathManager,
      );

      videoPlaylists.add(parsedPlaylist);

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

    return HlsFullPlaylistModel(
      master: master,
      videoPlaylists: videoPlaylists,
      audioPlaylists: audioPlaylists,
      masterLinkExcluder: masterLinkExcluder,
    );
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

  DownloadTask prepareDownloadTask({
    required List<AudioSegmentPlaylistModel> audioPlaylists,
    required VideoSegmentPlaylistModel videoPlaylist,
    required HlsPathManager pathManager,
  }) {
    final downloadItems = <DownloadItem>[];
    for (final audioPlaylist in audioPlaylists) {
      for (final segment in audioPlaylist.segments) {
        downloadItems.add(
          DownloadItem(
            url: segment.downloadLink,
            saveDir: pathManager.audioDir(audioTrack: audioPlaylist.audioTrack),
            fileName: pathManager
                .fileFromAudio(
                  url: segment.downloadLink,
                  audioTrack: audioPlaylist.audioTrack,
                )
                .fileName,
          ),
        );
      }
    }

    for (final segment in videoPlaylist.segments) {
      final resolutionType = videoPlaylist.resolution.resolution;
      downloadItems.add(
        DownloadItem(
          url: segment.downloadLink,
          saveDir: pathManager.videoDir(
            resolutionType: resolutionType,
          ),
          fileName: pathManager
              .fileFromVideo(
                url: segment.downloadLink,
                resolutionType: resolutionType,
              )
              .fileName,
        ),
      );
    }

    return DownloadTask(
      items: downloadItems,
    );
  }
}
