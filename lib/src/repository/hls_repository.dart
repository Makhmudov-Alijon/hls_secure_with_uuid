import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/repository/isar/download_task/download_task_repository_impl.dart';
import 'package:riverpod/riverpod.dart';

import 'isar/locale_hls_store/locale_hls_store_repository_impl.dart';

final hlsRepositoryProvider = Provider(
  (ref) => HlsRepository(
    dio: ref.read(DownloadManagerProviders.clientProvider),
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
    required LocalHlsId hlsId,
    required bool forWatching,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.post<String>(
        url,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            if (headers != null) ...headers,
          },
        ),
      );

      final decryptedHlsData = response.data;
      if (decryptedHlsData == null) {
        throw const FormatException(
          'decrypted data cant be null',
        );
      }

      final hlsData = await hlsService.decryptPlaylistData(
        token: token,
        data: response.data!,
      );

      final baseDir = HlsDirectoryHelper.instance.appDir;

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
    } catch (e, stk) {
      throw DownloadManager.exceptionHandler(e, stk);
    }
  }

  /// prepare playlists
  Future<DownloadTask> preparePlaylists({
    required MasterPlaylistModel master,
    required LocalHlsDetailsModel hlsDetails,
    required String? posterLink,
  }) async {
    try {
      final baseDir = HlsDirectoryHelper.instance.appDir;

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

      if (posterLink != null && !pathManager.posterFile.existsSync()) {
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
        totalSegments: downloadTask.items.length,
        hlsDetails: hlsDetails,
        downloadStatus: LocalHlsStatus(
          statusType: LocalHlsStatusType.prepared,
        ),
      );

      final id = await ref.read(localeHlsIsarProvider).add(localHls);

      downloadTask.id = id;
      await ref.read(downloadTaskIsarProvider).create(downloadTask);

      return downloadTask;
    } catch (e, stk) {
      throw DownloadManager.exceptionHandler(e, stk);
    }
  }

  Future<HlsWatchLink> prepareDataForWatching({
    required String url,
    required String token,
    required LocalHlsId hlsId,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final baseDir = HlsDirectoryHelper.instance.appDir;

      const isForWatching = true;

      final pathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsId,
        isRemote: isForWatching,
      );

      final master = await fetchMasterPlaylist(
        url: url,
        token: token,
        hlsId: hlsId,
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
    } catch (e, stk) {
      throw DownloadManager.exceptionHandler(e, stk);
    }
  }

  Future<void> saveAndEncryptMaster({
    required HlsPathManager pathManager,
    required HlsFullPlaylistModel fullPlaylist,
    required MasterPlaylistModel masterPlaylist,
  }) async {
    try {
      final playlistStr = masterPlaylist.toLocalPlaylist(
        linkExcluder: fullPlaylist.masterLinkExcluder,
      );
      final encryptedPlaylist = HlsEncrypter.encryptData(
        id: pathManager.localHlsId,
        data: playlistStr,
      );
      final masterFile = pathManager.masterFile..createIfNotExist();
      await masterFile.writeAsString(encryptedPlaylist);
    } catch (e, stk) {
      throw DownloadManager.exceptionHandler(e, stk);
    }
  }

  Future<void> saveAndEncryptPlaylists({
    required HlsFullPlaylistModel fullPlaylist,
    required HlsPathManager pathManager,
    required bool isForWatching,
  }) async {
    try {
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
    } catch (e, stk) {
      throw DownloadManager.exceptionHandler(e, stk);
    }
  }

  Future<void> saveEncriptedEncKey({
    required String enc,
    required String iv,
    required HlsPathManager pathManager,
  }) async {
    try {
      final encrypted = HlsEncrypter.encryptEncKey(
        id: pathManager.localHlsId,
        iv: iv,
        enc: enc,
      );
      pathManager.encKeyFile
        ..createIfNotExist()
        ..writeAsStringSync(encrypted);
    } catch (e, stk) {
      throw DownloadManager.exceptionHandler(e, stk);
    }
  }

  Future<void> downloadItemm(DownloadItem downloadItem) async {
    await dio.download(
      downloadItem.url,
      downloadItem.absolutePath,
    );
  }
}
