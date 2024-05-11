import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/utils/security/security.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/hls_parser/entities/hls_playlist_type.dart';

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

  Future<void> parse({required String url, required String token}) async {
    final client = ref.read(managerClientProvider);
    try {
      final response = await client.get<String>(url);

      if (response.data is String) {
        final parsedMaster = HlsParser(
          playlist: response.data!,
          playlistUrl: '/master',
        );

        debugPrint(parsedMaster.playlist);
      }
    } catch (e) {
      'Error $e'.log();
    }
  }

  Future<String> fetchVideoData({
    required String url,
    required String key,
    required String token,
    bool isEnc = true,
    int id = 345754,
  }) async {
    final client = ref.read(managerClientProvider);

    try {
      final response = await client.get<String>(
        url,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ),
      );

      if (response.data == null) {
        throw PlatformException(
          code: '404',
          message: 'Data not found',
        );
      }

      var json = <String, dynamic>{};

      if (isEnc) {
        json = await SecurityService().getDTD(
          data: response.data!,
          token: token,
          key: key,
        );
      } else {
        json = jsonDecode(response.data!) as Map<String, dynamic>;
      }

      final res = RemoteHlsDataModel.fromJson(json);

      final hlsMaster = HlsParser(
        playlist: res.master,
        playlistUrl: 'playlist',
      ).parseData(HlsPlaylistType.masterPlaylist);

      final hlsPathManager = HlsPathManager(
        resolutionType: HlsResolutionType.v1080p,
        baseDir: await getApplicationDocumentsDirectory(),
        localHlsId: LocalHlsId(movieId: id),
      );

      hlsPathManager.masterDir.createIfNotExist();

      final enc = json['enc'];
      File? encFile;

      if (enc != null && enc is String) {
        final baseDir = await getApplicationDocumentsDirectory();

        final file = File('${baseDir.path}/media/$id/enc.key');

        await file.writeAsString(enc);

        encFile = file;
      }

      final toLocalData = await hlsMaster.toLocalPlaylist(
        pathManager: hlsPathManager,
        ignoreOtherResolutions: false,
      );

      await File('${hlsPathManager.masterDir.path}master.m3u8').writeAsString(
        toLocalData,
      );

      await Future.wait(
        [
          parseVideo(
            res.videoPlaylists,
            encUrl: encFile?.path,
            id: id,
          ),
          parseAudio(
            res.audioPlaylists.first,
            encUrl: encFile?.path,
            id: id,
          ),
        ],
      );

      return 'file:///${hlsPathManager.masterDir.path}';
    } catch (err) {
      rethrow;
    }
  }

  Future<void> parseVideo(
    List<String> videoPlaylists, {
    required int id,
    String? encUrl,
  }) async {
    for (final item in videoPlaylists) {
      final hlsVideo = HlsParser(
        playlist: item,
        playlistUrl: 'playlist',
        key: encUrl != null
            ? HlsSegmentsPlaylistKey(
                encKeyUrl: 'file:///$encUrl',
                salt: '',
              )
            : null,
      ).parseData(HlsPlaylistType.videoSegmentPlaylist);

      final hlsPathManager = HlsPathManager(
        resolutionType: HlsResolutionType.values.firstWhere(
          (element) => item.contains(
            element.title,
          ),
        ),
        baseDir: await getApplicationDocumentsDirectory(),
        localHlsId: LocalHlsId(movieId: id),
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

  Future<void> parseAudio(
    String audioPlaylist, {
    required int id,
    String? encUrl,
  }) async {
    final hlsAudio = HlsParser(
      playlist: audioPlaylist,
      playlistUrl: 'playlist',
      key: encUrl != null
          ? HlsSegmentsPlaylistKey(
              encKeyUrl: 'file:///$encUrl',
              salt: '',
            )
          : null,
    ).parseData(HlsPlaylistType.audioSegmentPlaylist);

    final hlsPathManager = HlsPathManager(
      resolutionType: HlsResolutionType.v1080p,
      baseDir: await getApplicationDocumentsDirectory(),
      localHlsId: LocalHlsId(movieId: id),
    );

    hlsPathManager.audioDir.createIfNotExist();

    final toLocalDataAudio = await hlsAudio.toLocalPlaylist(
      pathManager: hlsPathManager,
      ignoreSegments: true,
    );

    await File('${hlsPathManager.audioDir.path}playlist.m3u8').writeAsString(
      toLocalDataAudio,
    );
  }
}

final remoteHlsProvider =
    NotifierProvider<RemoteHlsProvider, RemoteHlsState>(RemoteHlsProvider.new);
