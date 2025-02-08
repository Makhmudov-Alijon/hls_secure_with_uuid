import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/entities/thumbs_playlist_type.dart';
import 'package:download_manager/src/models/thumbs_parsed_playlist_model/thumbs_parsed_playlist_model.dart';
import 'package:download_manager/src/models/thumbs_playlist_details_model/thumbs_playlist_details_model.dart';
import 'package:riverpod/riverpod.dart';

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
    required String data,
  }) async {
    try {
      final decrypted = await HlsEncrypter.getDecryptedHlsData(
        data: data,
        access: token,
      );
      return HlsFullNonParsedModel.fromJson(decrypted);
    } catch (e) {
      throw const FormatException('Error while decrypting hlsData');
    }
  }

  Future<void> saveThumbnailPlaylists({
    required Map<ThumbsPlaylistType, ThumbsPlaylistDetailsModel>
        thumbsPlaylists,
    required String baseUrl,
    required HlsPathManager pathManager,
  }) async {
    for (final playlistEntry in thumbsPlaylists.entries) {
      final parsedPlaylist = ThumbsParsedPlaylistModel.fromPlaylistDetails(
        details: playlistEntry.value,
        baseUrl: baseUrl,
      );
      final playlistType = playlistEntry.key;
      final file = pathManager.thumbnailFile(
        playlistType: playlistType,
      )..createIfNotExist();

      await file.writeAsString(
        parsedPlaylist.toString(),
      );
    }
  }

  AudioSegmentPlaylistModel parseAudioTrackPlaylist({
    required HlsAudioTrack track,
    required HlsFullNonParsedModel hlsData,
    required HlsPathManager pathManager,
  }) {
    final playlist = hlsData.audioPlaylists
        .firstWhere(
          (element) => element.uri == track.trackUrl,
        )
        .data;
    return AudioSegmentPlaylistModel.parse(
      token: hlsData.token,
      baseUrl: hlsData.baseUrl,
      playlistBaseUrl: track.playlistBaseUrl,
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
        return element.uri == resolution.videoPlaylistUrl;
      },
    ).data;
    return VideoSegmentPlaylistModel.parse(
      token: hlsData.token,
      baseUrl: hlsData.baseUrl,
      playlistBaseUrl: resolution.playlistBaseUrl,
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
        final downloadLink = segment.link;
        downloadItems.add(
          DownloadItem(
            url: downloadLink,
            saveDirPath:
                pathManager.audioDir(audioTrack: audioPlaylist.audioTrack).path,
            fileName: pathManager
                .fileFromAudio(
                  url: downloadLink,
                  audioTrack: audioPlaylist.audioTrack,
                )
                .fileName,
          ),
        );
      }
    }

    for (final segment in videoPlaylist.segments) {
      final resolutionType = videoPlaylist.resolution.resolution;
      final downloadLink = segment.link;
      print(downloadLink);
      downloadItems.add(
        DownloadItem(
          url: downloadLink,
          saveDirPath: pathManager
              .videoDir(
                resolutionType: resolutionType,
              )
              .path,
          fileName: pathManager
              .fileFromVideo(
                url: segment.link,
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
