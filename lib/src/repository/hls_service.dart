import 'package:riverpod/riverpod.dart';

import '../../download_manager.dart';
import '../models/hls_data_model/hls_data_model.dart';
import '../utils/hls_parser/entities/hls_link_swapper.dart';
import '../utils/hls_parser/entities/hls_playlist_type.dart';
import '../utils/security/security.dart';

final hlsServiceProvider = Provider(
  (ref) => HlsService(),
);

class HlsService {
  Future<void> writeAudioTracks({
    required HlsPathManager pathManager,
    required MasterPlaylistModel master,
  }) async {
    for (final trackGroup in master.audioTrackGroups) {
      for (final audioTrack in trackGroup.tracks) {
        final parsedPlaylist = parseAudioTrackPlaylist(
          track: audioTrack,
          hlsData: master.hlsData,
        );

        final encKey = parsedPlaylist.playlistData.encKey;

        final playlistLinkSwapper = HlsLinkSwapper(useAbsolute: false);

        if (encKey != null) {
          playlistLinkSwapper.addLinkFromFile(
            originalLink: encKey.url,
            file: pathManager.encKeyFile,
            baseDir: pathManager.audioDir(
              audioTrack: audioTrack,
            ),
          );
        }

        pathManager.audioDir(audioTrack: audioTrack).createIfNotExist();

        final audioMaster = pathManager.audioMasterFile(
          audioTrack: audioTrack,
        )..createIfNotExist();

        await audioMaster.writeAsString(
          parsedPlaylist.playlistData.toLocalPlaylist(
            linkSwapper: playlistLinkSwapper,
          ),
        );
      }
    }
  }

  Future<void> writeVideoResolutions({
    required HlsPathManager pathManager,
    required MasterPlaylistModel master,
  }) async {
    for (final resolution in master.resolutions) {
      final parsedPlaylist = parseResolutionPlaylist(
        resolution: resolution,
        hlsData: master.hlsData,
      );

      final encKey = parsedPlaylist.playlistData.encKey;

      final playlistLinkSwapper = HlsLinkSwapper(useAbsolute: false);

      if (encKey != null) {
        playlistLinkSwapper.addLinkFromFile(
          originalLink: encKey.url,
          file: pathManager.encKeyFile,
          baseDir: pathManager.videoDir(
            resolutionType: resolution.resolution,
          ),
        );
      }

      pathManager
          .videoDir(
            resolutionType: resolution.resolution,
          )
          .createIfNotExist();

      final videoMaster = pathManager.videoMasterFile(
        resolutionType: resolution.resolution,
      )..createIfNotExist();

      await videoMaster.writeAsString(
        parsedPlaylist.playlistData.toLocalPlaylist(
          linkSwapper: playlistLinkSwapper,
        ),
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

  SegmentPlaylistParsedModel parseAudioTrackPlaylist({
    required HlsAudioTrack track,
    required HlsDataModel hlsData,
  }) {
    final playlist = hlsData.audioPlaylists
        .firstWhere(
          (element) => element.path == track.trackUrl,
        )
        .data;
    final hlsParser = HlsParser(playlist: playlist);
    return SegmentPlaylistParsedModel.fromParsedPlaylist(
      playlistData: hlsParser.parseData(HlsPlaylistType.audioSegmentPlaylist),
      isVideo: false,
    );
  }

  SegmentPlaylistParsedModel parseResolutionPlaylist({
    required HlsResolution resolution,
    required HlsDataModel hlsData,
  }) {
    final playlist = hlsData.videoPlaylists.firstWhere(
      (element) {
        return element.path == resolution.videoPlaylistUrl;
      },
    ).data;
    final hlsParser = HlsParser(playlist: playlist);
    return SegmentPlaylistParsedModel.fromParsedPlaylist(
      playlistData: hlsParser.parseData(HlsPlaylistType.videoSegmentPlaylist),
      isVideo: true,
    );
  }

  HlsLinkSwapper getMasterLinkSwapper({
    required HlsPathManager pathManager,
    required MasterPlaylistModel master,
  }) {
    final masterSwapper = HlsLinkSwapper(useAbsolute: false);

    for (final resolution in master.resolutions) {
      final videoMasterFile = pathManager.videoMasterFile(
        resolutionType: resolution.resolution,
      );
      masterSwapper.addLinkFromFile(
        originalLink: resolution.videoPlaylistUrl,
        file: videoMasterFile,
        baseDir: pathManager.masterDir,
      );
    }

    for (final audioGroup in master.audioTrackGroups) {
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
}
