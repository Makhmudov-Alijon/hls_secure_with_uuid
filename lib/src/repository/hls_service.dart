import 'package:download_manager/download_manager.dart';
import 'package:riverpod/riverpod.dart';

import '../models/thumbs_non_parsed_playlist/thumbs_non_parsed_playlist.dart';
import '../utils/security/security.dart';

final hlsServiceProvider = Provider(
  (ref) => HlsService(),
);

class HlsService {
  Future<HlsFullPlaylistModel> fetchFullPlaylist({
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
    }

    return HlsFullPlaylistModel(
      master: master,
      videoPlaylists: videoPlaylists,
      audioPlaylists: audioPlaylists,
      masterLinkExcluder: masterLinkExcluder,
    );
  }

  Future<HlsFullNonParsedModel> decryptPlaylistData({
    required String token,
    required String url,
    required String key,
    bool isAes = false,
    dynamic data,
  }) async {
    if (data is String) {
      Map<String, dynamic> decrypted;
      if (isAes) {
        decrypted = await SecurityService().getDTDs(
          data: data,
          token: token,
          key: key,
        );
      } else {
        decrypted = await SecurityService().getDTD(
          data: data,
          token: token,
          key: key,
        );
      }

      return HlsFullNonParsedModel.fromJson(decrypted);
    } else if (data is Map<String, dynamic>) {
      return HlsFullNonParsedModel.fromJson(data);
    } else {
      throw const FormatException('Playlist data type is not correct');
    }
  }

  Future<void> saveThumbnailPlaylists({
    required List<ThumbsPlaylist> thumbsPlaylists,
    required HlsPathManager pathManager,
  }) async {
    for (final playlist in thumbsPlaylists) {
      final file = pathManager.thumbnailFile(
        playlistType: playlist.playlistType,
      )..createIfNotExist();

      await file.writeAsString(playlist.content);
    }
  }

  AudioSegmentPlaylistModel parseAudioTrackPlaylist({
    required HlsAudioTrack track,
    required HlsFullNonParsedModel hlsData,
    required HlsPathManager pathManager,
  }) {
    final playlist = hlsData.audioPlaylists
        .firstWhere(
          (element) => element.path == track.trackUrl,
        )
        .data;
    return AudioSegmentPlaylistModel.parse(
      encKey: hlsData.enc,
      playlist: playlist,
      audioTrack: track,
      pathManager: pathManager,
    );
  }

  VideoSegmentPlaylistModel parseResolutionPlaylist({
    required HlsResolution resolution,
    required HlsFullNonParsedModel hlsData,
    required HlsPathManager pathManager,
  }) {
    final playlist = hlsData.videoPlaylists.firstWhere(
      (element) {
        return element.path == resolution.videoPlaylistUrl;
      },
    ).data;
    return VideoSegmentPlaylistModel.parse(
      encKey: hlsData.enc,
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
    /// total size
    var size = 0;

    final downloadItems = <DownloadItem>[];
    for (final audioPlaylist in audioPlaylists) {
      size += audioPlaylist.audioTrack.size;
      for (final segment in audioPlaylist.segments) {
        downloadItems.add(
          DownloadItem(
            url: segment.downloadLink,
            saveDirPath:
                pathManager.audioDir(audioTrack: audioPlaylist.audioTrack).path,
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
          saveDirPath: pathManager
              .videoDir(
                resolutionType: resolutionType,
              )
              .path,
          fileName: pathManager
              .fileFromVideo(
                url: segment.downloadLink,
                resolutionType: resolutionType,
              )
              .fileName,
        ),
      );
    }

    final downloadTask = DownloadTask(
      items: downloadItems,
      totalBytes: size + videoPlaylist.resolution.size,
    );

    return downloadTask;
  }
}
