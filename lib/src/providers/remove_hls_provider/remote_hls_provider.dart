import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'models/remote_hls_data_model.dart';

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

  Future<void> fetchVideoData() async {
    final data = await rootBundle.loadString('assets/hls/master.json');

    final json = jsonDecode(data) as Map<String, dynamic>;

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

    final masterFile =
        await File('${hlsPathManager.masterDir.path}master.m3u8').writeAsString(
      toLocalData,
    );

    log(masterFile.path);

    await parseVideo(res.videoPlaylists);
    await parseAudio(res.audioPlaylists.first);
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

      final videoMasterFile =
          await File('${hlsPathManager.videoDir.path}playlist.m3u8')
              .writeAsString(
        toLocalDataVideo,
      );

      log(videoMasterFile.path);
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
