import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:download_manager/download_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

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
    Map<String, dynamic>? headers,
    bool isAes = false,
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

      return MasterPlaylistModel.parse(
        playlist: hlsData.master,
        hlsData: hlsData,
        pathManager: pathManager,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<DownloadTask?> preparePlaylists({
    required MasterPlaylistModel master,
    required LocalHlsDetailsModel hlsDetails,
    required String? posterLink,
  }) async {
    try {
      final baseDir = await getApplicationDocumentsDirectory();

      final pathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsDetails.id,
        isRemote: false,
      );

      final masterDir = pathManager.masterDir..createIfNotExist();

      final encKey = master.hlsData.enc;

      if (encKey != null) {
        pathManager.encKeyFile
          ..createIfNotExist()
          ..writeAsStringSync(encKey);
      }

      final hlsFullPlaylist = await hlsService.saveSegmentPlaylists(
        pathManager: pathManager,
        master: master,
        isForWatching: false,
        selectedResolutions: {hlsDetails.resolution},
        selectedTracks: hlsDetails.audioTracks,
      );

      final masterFile = pathManager.masterFile
        ..createIfNotExist()
        ..writeAsStringSync(
          master.toLocalPlaylist(
            linkExcluder: hlsFullPlaylist.masterLinkExcluder,
          ),
        );

      if (posterLink != null && !pathManager.posterFile.existsSync()) {
        await downloadItem(
          DownloadItem(
            groupId: hlsDetails.id.toStringId(),
            url: posterLink,
            saveDir: pathManager.masterDir,
            fileName: pathManager.posterFile.fileName,
          ),
        );
      }

      final downloadTask = hlsService.prepareDownloadTask(
        audioPlaylists: hlsFullPlaylist.audioPlaylists,
        videoPlaylist: hlsFullPlaylist.videoPlaylists.first,
        pathManager: pathManager,
      );

      pathManager.downloadTaskFile
        ..createIfNotExist()
        ..writeAsStringSync(
          downloadTask.toJson(),
        );

      final localHls = LocalHlsModel(
        baseDir: baseDir,
        totalSegments: downloadTask.items.length,
        hlsDetails: hlsDetails,
        downloadStatus: LocalHlsStatus(
          statusType: LocalHlsStatusType.prepared,
          creationDate: DateTime.now(),
        ),
        posterFile: pathManager.posterFile,
        masterFile: masterFile,
        masterDir: masterDir,
        downloadTasksFile: pathManager.downloadTaskFile,
        localHlsFile: pathManager.localHlsFile,
      );

      pathManager.localHlsFile
        ..createIfNotExist()
        ..writeAsStringSync(
          localHls.toJson(),
        );

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

      pathManager.masterDir.createIfNotExist();

      final encKey = master.hlsData.enc;

      if (encKey != null) {
        pathManager.encKeyFile
          ..createIfNotExist()
          ..writeAsStringSync(encKey);
      }

      await hlsService.saveThumbnailPlaylists(
        thumbsPlaylists: master.hlsData.thumbsPlaylists,
        pathManager: pathManager,
      );

      final hlsFullPlaylist = await hlsService.saveSegmentPlaylists(
        pathManager: pathManager,
        master: master,
        isForWatching: isForWatching,
      );

      pathManager.masterFile
        ..createIfNotExist()
        ..writeAsStringSync(
          master.toLocalPlaylist(
            linkExcluder: hlsFullPlaylist.masterLinkExcluder,
          ),
        );
      return HlsWatchLink.fromPathManager(pathManager);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadItem(DownloadItem downloadItem) async {
    await dio.download(
      downloadItem.url,
      downloadItem.absolutePath,
    );
  }
}
