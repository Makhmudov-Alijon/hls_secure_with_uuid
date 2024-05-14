import 'dart:async';

import 'package:dio/dio.dart';
import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/repository/hls_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../utils/hls_parser/entities/hls_playlist_type.dart';

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
  }) async {
    try {
      final response = await dio.get<dynamic>(
        url,
        options: Options(
          headers: {
            'Bearer': token,
          },
        ),
      );

      final hlsData = await hlsService.decryptPlaylistData(
        token: token,
        url: url,
        key: key,
        data: response.data,
      );

      final hlsParser = HlsParser(
        playlist: hlsData.master,
      );

      final playlistData = hlsParser.parseData(HlsPlaylistType.masterPlaylist);

      return MasterPlaylistModel.fromParsedPlaylist(
        parsedMasterPlaylist: playlistData,
        hlsData: hlsData,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> prepareForWatching({
    required String url,
    required String token,
    required String key,
    required LocalHlsId hlsId,
  }) async {
    try {
      final baseDir = await getApplicationDocumentsDirectory();

      final pathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsId,
        isRemote: true,
      );

      final master = await fetchMasterPlaylist(
        url: url,
        token: token,
        key: key,
        hlsId: hlsId,
      );

      final masterLinkSwapper = hlsService.getMasterLinkSwapper(
        pathManager: pathManager,
        master: master,
      );

      pathManager.masterDir.createIfNotExist();

      pathManager.masterFile()
        ..createIfNotExist()
        ..writeAsStringSync(
          master.masterPlaylistData.toLocalPlaylist(
            linkSwapper: masterLinkSwapper,
          ),
        );

      await hlsService.writeVideoResolutions(
        pathManager: pathManager,
        master: master,
      );

      await hlsService.writeAudioTracks(
        pathManager: pathManager,
        master: master,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadMustHaveData(List<DownloadItem> downloadTasks) async {
    for (final task in downloadTasks) {
      await dio.download(
        task.url,
        task.absolutePath,
      );
    }
  }

  DownloadTask _prepareDownloadTaskItems({
    required SegmentPlaylistParsedModel audioPlaylist,
    required SegmentPlaylistParsedModel videoPlaylist,
    required HlsPathManager pathManager,
  }) {
    // final segments = [...audioPlaylist.segments, ...videoPlaylist.segments];
    // final downloadItems = <DownloadItem>[];
    // for (final segment in segments) {
    //   downloadItems.add(
    //     DownloadItem(
    //       url: segment.downloadLink,
    //       saveDir:
    //           segment.isVideo ? pathManager.videoDir : pathManager.audioDir,
    //       fileName: segment.isVideo
    //           ? pathManager.videoFileFrom(segment.downloadLink).fileName
    //           : pathManager.audioFileFrom(segment.downloadLink).fileName,
    //     ),
    //   );
    // }
    // return DownloadTask(
    //   items: downloadItems,
    // );
    throw UnimplementedError();
  }

  Future<DownloadTask?> prepareDataForDownload({
    required LocalHlsDetailsModel hlsDetails,
    required MasterPlaylistModel masterPlaylist,
    bool isDownloading = false,
    String? posterLink,
  }) async {
    // try {
    //   final baseDir = await HlsPathConstants.baseDir;
    //   final hlsPathManager = HlsPathManager(
    //     audioTrack: hlsDetails.audioTrack,
    //     baseDir: baseDir,
    //     localHlsId: hlsDetails.id,
    //     resolutionType: hlsDetails.videoResolution.resolution,
    //   );

    //   final masterDir = hlsPathManager.masterDir..createIfNotExist();

    //   final audioDir = hlsPathManager.audioDir..createIfNotExist();

    //   final videoDir = hlsPathManager.videoDir..createIfNotExist();

    //   await downloadMustHaveData(
    //     [
    //       if (key != null &&
    //           !hlsPathManager.masterFileFrom(key.encKeyUrl).existsSync())
    //         DownloadItem(
    //           groupId: hlsDetails.id.toStringId(),
    //           url: key.encKeyUrl,
    //           saveDir: hlsPathManager.masterDir,
    //           fileName: hlsPathManager.masterFileFrom(key.encKeyUrl).fileName,
    //         ),
    //       if (posterLink != null && !hlsPathManager.posterFile.existsSync())
    //         DownloadItem(
    //           groupId: hlsDetails.id.toStringId(),
    //           url: posterLink,
    //           saveDir: hlsPathManager.masterDir,
    //           fileName: hlsPathManager.posterFile.fileName,
    //         ),
    //     ],
    //   );

    //   final videoPlaylist = await fetchDataFromResolutionPlaylist(
    //     masterPlaylist,
    //     hlsDetails.videoResolution,
    //   );

    //   final audioPlaylist = await fetchAudioPlaylist(
    //     masterPlaylist,
    //   );

    //   final masterFile = await hlsPathManager.masterFile().writeAsString(
    //         await masterPlaylist.masterPlaylistData.toLocalPlaylist(
    //           pathManager: hlsPathManager,
    //         ),
    //       );

    //   final videoMasterFile =
    //       await hlsPathManager.videoMasterFile().writeAsString(
    //             await videoPlaylist.playlistData.toLocalPlaylist(
    //               pathManager: hlsPathManager,
    //             ),
    //           );

    //   final audioMasterFile =
    //       await hlsPathManager.audioMasterFile().writeAsString(
    //             await audioPlaylist.playlistData.toLocalPlaylist(
    //               pathManager: hlsPathManager,
    //             ),
    //           );

    //   final localHls = LocalHlsModel(
    //     hlsDetails: hlsDetails,
    //     downloadStatus: LocalHlsStatus(
    //       statusType: isDownloading
    //           ? LocalHlsStatusType.inQueue
    //           : LocalHlsStatusType.downloading,
    //       creationDate: DateTime.now(),
    //     ),
    //     posterFile: hlsPathManager.posterFile,
    //     masterFile: masterFile,
    //     masterDir: masterDir,
    //     audioDir: audioDir,
    //     videoDir: videoDir,
    //     audioMasterFile: audioMasterFile,
    //     videoMasterFile: videoMasterFile,
    //     downloadTasksFile: hlsPathManager.downloadTaskFile,
    //     localHlsFile: hlsPathManager.localHlsFile,
    //     videoSegmentsLength: videoPlaylist.segments.length,
    //     audioSegmentsLength: audioPlaylist.segments.length,
    //   );

    //   final downloadTask = _prepareDownloadTaskItems(
    //     audioPlaylist: audioPlaylist,
    //     videoPlaylist: videoPlaylist,
    //     pathManager: hlsPathManager,
    //   );

    //   await hlsPathManager.downloadTaskFile
    //       .writeAsString(downloadTask.toJson());

    //   await hlsPathManager.localHlsFile.writeAsString(
    //     localHls.toJson(),
    //   );

    //   return downloadTask;
    // } catch (e) {
    //   return null;
    // }
    throw UnimplementedError();
  }
}
