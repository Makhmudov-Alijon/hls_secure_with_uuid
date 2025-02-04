import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/repository/isar/download_task/download_task_repository_impl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'isar/locale_hls_store/locale_hls_store_repository_impl.dart';

final hlsRepositoryProvider = Provider(
  (ref) => HlsRepository(
    dio: ref.read(managerClientProvider),
    ref: ref,
    hlsService: ref.read(hlsServiceProvider),
  ),
);

class HlsRepository {
  const HlsRepository({
    required this.dio,
    required this.ref,
    required this.hlsService,
  });

  final Dio dio;
  final Ref ref;
  final HlsService hlsService;

  Future<MasterPlaylistModel> fetchMasterPlaylist({
    required String url,
    required String token,
    required String key,
    required LocalHlsId hlsId,
    required bool forWatching,
    required bool isAes,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.post<dynamic>(
        url,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            if (headers != null) ...headers,
          },
        ),
      );

      final hlsData = await hlsService.decryptPlaylistData(
        token: token,
        url: url,
        key: key,
        isAes: isAes,
        data: response.data,
      );

      final baseDir = await getApplicationDocumentsDirectory();

      final pathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsId,
        isRemote: forWatching,
      );

      final result = MasterPlaylistModel.parse(
        playlist: hlsData.master,
        hlsData: hlsData,
        pathManager: pathManager,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// prepare playlists
  Future<DownloadTask?> preparePlaylists({
    required MasterPlaylistModel master,
    required LocalHlsDetailsModel hlsDetails,
    required String? posterLink,
  }) async {
    try {
      final baseDir = await getApplicationDocumentsDirectory();

      const isForWatching = false;

      final pathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsDetails.localHlsId,
        isRemote: isForWatching,
      );

      final hlsFullPlaylist = await hlsService.fetchFullPlaylist(
        pathManager: pathManager,
        master: master,
        isForWatching: isForWatching,
        selectedResolutions: {hlsDetails.resolution},
        selectedTracks: hlsDetails.audioTracks.toSet(),
      );

      await saveAndEncryptMaster(
        pathManager: pathManager,
        fullPlaylist: hlsFullPlaylist,
        masterPlaylist: master,
      );

      await saveEncriptedEncKey(
        iv: hlsFullPlaylist.iv,
        enc: master.hlsData.enc,
        pathManager: pathManager,
      );

      await saveAndEncryptPlaylists(
        isForWatching: isForWatching,
        pathManager: pathManager,
        fullPlaylist: hlsFullPlaylist,
      );

      // await hlsService.saveThumbnailPlaylists(
      //   thumbsPlaylists: master.hlsData.thumbsPlaylists,
      //   pathManager: pathManager,
      // );

      if (posterLink != null && !pathManager.posterFile.existsSync()) {
        /// the download item created
        await downloadItemm(
          DownloadItem(
            groupId: hlsDetails.localHlsId.toStringId(),
            url: posterLink,
            saveDirPath: pathManager.masterDir.path,
            fileName: pathManager.posterFile.fileName,
          ),
        );
      }

      final downloadTask = hlsService.prepareDownloadTask(
        audioPlaylists: hlsFullPlaylist.audioPlaylists,
        videoPlaylist: hlsFullPlaylist.videoPlaylists.first,
        pathManager: pathManager,
      );

      final localHls = LocalHlsModelIsar(
        iv: hlsFullPlaylist.iv,
        baseDirPath: baseDir.path,
        posterFilePath: pathManager.posterFile.path,
        masterFilePath: pathManager.masterFile.path,
        masterDirPath: pathManager.masterDir.path,
        totalSegments: downloadTask.items.length,
        hlsDetails: hlsDetails,
        downloadStatus: LocalHlsStatus(
          statusType: LocalHlsStatusType.prepared,
          // creationDate: DateTime.now(),
        ),
      );

      final id = await ref.read(localeHlsIsarProvider).add(localHls);

      downloadTask.id = id;
      await ref.read(downloadTaskIsarProvider).create(downloadTask);

      return downloadTask;
    } catch (e) {
      return null;
    }
  }

  Future<HlsWatchLink> prepareDataForWatching({
    required String url,
    required String token,
    required String key,
    required LocalHlsId hlsId,
    Map<String, dynamic>? headers,
    bool isAes = false,
  }) async {
    try {
      final baseDir = await getApplicationDocumentsDirectory();

      const isForWatching = true;

      final pathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsId,
        isRemote: isForWatching,
      );

      final master = await fetchMasterPlaylist(
        url: url,
        token: token,
        key: key,
        hlsId: hlsId,
        isAes: isAes,
        headers: headers,
        forWatching: isForWatching,
      );

      final hlsFullPlaylist = await hlsService.fetchFullPlaylist(
        pathManager: pathManager,
        master: master,
        isForWatching: isForWatching,
      );

      await saveAndEncryptMaster(
        pathManager: pathManager,
        fullPlaylist: hlsFullPlaylist,
        masterPlaylist: master,
      );

      await saveEncriptedEncKey(
        iv: hlsFullPlaylist.iv,
        enc: hlsFullPlaylist.enc,
        pathManager: pathManager,
      );

      await saveAndEncryptPlaylists(
        isForWatching: isForWatching,
        pathManager: pathManager,
        fullPlaylist: hlsFullPlaylist,
      );

      await hlsService.saveThumbnailPlaylists(
        thumbsPlaylists: master.hlsData.thumbsPlaylists,
        pathManager: pathManager,
        baseUrl: master.hlsData.baseUrl,
      );

      return HlsWatchLink.fromPathManager(
        pathManager: pathManager,
        fullPlaylist: hlsFullPlaylist,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveAndEncryptMaster({
    required HlsPathManager pathManager,
    required HlsFullPlaylistModel fullPlaylist,
    required MasterPlaylistModel masterPlaylist,
  }) async {
    final playlistStr = masterPlaylist.toLocalPlaylist(
      linkExcluder: fullPlaylist.masterLinkExcluder,
    );
    final encryptedPlaylist = HlsEncrypter.encryptData(
      id: pathManager.localHlsId,
      data: playlistStr,
    );
    final masterFile = pathManager.masterFile..createIfNotExist();
    await masterFile.writeAsString(
      encryptedPlaylist,
    );
  }

  Future<void> saveAndEncryptPlaylists({
    required HlsFullPlaylistModel fullPlaylist,
    required HlsPathManager pathManager,
    required bool isForWatching,
  }) async {
    for (final audioPlaylist in fullPlaylist.audioPlaylists) {
      final audioTrack = audioPlaylist.audioTrack;
      pathManager.audioDir(audioTrack: audioTrack).createIfNotExist();

      final audioMaster = pathManager.audioMasterFile(
        audioTrack: audioTrack,
      )..createIfNotExist();

      final playlistStr = audioPlaylist.toLocalPlaylist(
        isForWatching: isForWatching,
      );

      final encryptedPlaylistStr = HlsEncrypter.encryptData(
        id: pathManager.localHlsId,
        data: playlistStr,
      );

      await audioMaster.writeAsString(encryptedPlaylistStr);
    }

    for (final videoPlaylist in fullPlaylist.videoPlaylists) {
      final resolution = videoPlaylist.resolution;
      pathManager
          .videoDir(resolutionType: resolution.resolution)
          .createIfNotExist();

      final videoMaster = pathManager.videoMasterFile(
        resolutionType: resolution.resolution,
      )..createIfNotExist();

      final playlistStr = videoPlaylist.toLocalPlaylist(
        isForWatching: isForWatching,
      );

      final encryptedPlaylist = HlsEncrypter.encryptData(
        id: pathManager.localHlsId,
        data: playlistStr,
      );

      await videoMaster.writeAsString(
        encryptedPlaylist,
      );
    }
  }

  Future<void> saveEncriptedEncKey({
    required String enc,
    required String iv,
    required HlsPathManager pathManager,
  }) async {
    final encrypted = HlsEncrypter.encryptEncKey(
      id: pathManager.localHlsId,
      iv: iv,
      enc: enc,
    );
    pathManager.encKeyFile
      ..createIfNotExist()
      ..writeAsStringSync(encrypted);
  }

  Future<void> downloadItemm(DownloadItem downloadItem) async {
    await dio.download(
      downloadItem.url,
      downloadItem.absolutePath,
    );
  }
}
