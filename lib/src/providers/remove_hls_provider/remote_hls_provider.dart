import 'dart:developer';
import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/utils/security/security.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class RemoteHlsState extends Equatable {
  const RemoteHlsState();

  @override
  List<Object?> get props => [];
}

class RemoteHlsInitialState extends RemoteHlsState {
  const RemoteHlsInitialState();

  @override
  List<Object?> get props => [];
}

class RemoteHlsProvider extends Notifier<RemoteHlsState> {
  @override
  RemoteHlsState build() {
    return const RemoteHlsInitialState();
  }

  Future<void> fetchVideoData({
    required String url,
    required String key,
  }) async {
    final client = ref.read(managerClientProvider);

    try {
      final response = await client.get<String>(
        url,
      );

      if (response.data == null) {
        throw PlatformException(
          code: '404',
          message: 'Data not found',
        );
      }

      final token =
          response.requestOptions.headers[HttpHeaders.authorizationHeader];

      final json = await SecurityService().getDTD(
        data: response.data!,
        token: kDebugMode
            ? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MTM1MjM4OTUsInNpZCI6bnVsbCwidXNlcl9pZCI6bnVsbCwicHJvZmlsZV9pZCI6bnVsbCwiYXBwX3R5cGUiOm51bGwsImRsIjpmYWxzZSwic2ltcGxlIjpmYWxzZX0.IwtFBqgsxsRg_qDc8hR8MtvRc0FwqToHz1kHrCCc2fk"
            : token as String,
        key: key,
      );

      final res = RemoteHlsDataModel.fromJson(json);

      final hlsMaster = HlsParser(
        playlist: res.master,
        playlistUrl: 'playlist',
      ).parseData(HlsPlaylistType.masterPlaylist);

      final hlsPathManager = HlsPathManager(
        resolutionType: HlsResolutionType.v1080p,
        baseDir: await getApplicationDocumentsDirectory(),
        localHlsId: const LocalHlsId(movieId: 1),
      );

      hlsPathManager.masterDir.createIfNotExist();

      final toLocalData = await hlsMaster.toLocalPlaylist(
        pathManager: hlsPathManager,
        ignoreOtherResolutions: false,
      );

      await File('${hlsPathManager.masterDir.path}master.m3u8').writeAsString(
        toLocalData,
      );

      await parseVideo(res.videoPlaylists);
      await parseAudio(res.audioPlaylists.first);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> parseVideo(List<String> videoPlaylists) async {
    for (final item in videoPlaylists) {
      final hlsVideo = HlsParser(
        playlist: item,
        playlistUrl: 'playlist',
      ).parseData(HlsPlaylistType.videoSegmentPlaylist);

      final hlsPathManager = HlsPathManager(
        resolutionType: HlsResolutionType.values.firstWhere(
          (element) => item.contains(
            element.title,
          ),
        ),
        baseDir: await getApplicationDocumentsDirectory(),
        localHlsId: const LocalHlsId(movieId: 1),
      );

      hlsPathManager.videoDir.createIfNotExist();

      final toLocalDataVideo = await hlsVideo.toLocalPlaylist(
        pathManager: hlsPathManager,
        ignoreSegments: true,
      );

      await File('${hlsPathManager.videoDir.path}playlist.m3u8').writeAsString(
        toLocalDataVideo,
      );
    }
  }

  Future<void> parseAudio(String audioPlaylist) async {
    final hlsAudio = HlsParser(
      playlist: audioPlaylist,
      playlistUrl: 'playlist',
    ).parseData(HlsPlaylistType.audioSegmentPlaylist);

    final hlsPathManager = HlsPathManager(
      resolutionType: HlsResolutionType.v1080p,
      baseDir: await getApplicationDocumentsDirectory(),
      localHlsId: const LocalHlsId(movieId: 1),
    );

    hlsPathManager.audioDir.createIfNotExist();

    final toLocalDataAudio = await hlsAudio.toLocalPlaylist(
      pathManager: hlsPathManager,
      ignoreSegments: true,
    );

    final audioMasterFile =
        await File('${hlsPathManager.audioDir.path}playlist.m3u8')
            .writeAsString(
      toLocalDataAudio,
    );

    log(audioMasterFile.path);
  }
}

final remoteHlsProvider =
    NotifierProvider<RemoteHlsProvider, RemoteHlsState>(RemoteHlsProvider.new);
