import 'dart:async';

import 'package:dio/dio.dart';
import 'package:download_manager/src/models/hls_data_model/hls_data_model.dart';
import 'package:download_manager/src/models/local_hls_model/local_hls_id.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../models/download_task_model/download_item_model.dart';
import '../models/download_task_model/download_task_model.dart';
import '../models/local_hls_model/local_hls_details_model.dart';
import '../models/master_playlist_model/hls_resolution.dart';
import '../models/master_playlist_model/master_playlist_model.dart';
import '../models/segment_playlist_model/segment_playlist_parsed_model.dart';
import '../providers/client_provider.dart';
import '../utils/hls_parser/entities/hls_playlist_type.dart';
import '../utils/hls_parser/hls_parser.dart';
import '../utils/hls_parser/hls_path_manager.dart';
import '../utils/security/security.dart';

final hlsRepositoryProvider = Provider(
  (ref) => HlsRepository(
    dio: ref.read(managerClientProvider),
    ref: ref,
  ),
);

class HlsRepository {
  const HlsRepository({
    required this.dio,
    required this.ref,
  });

  final Dio dio;
  final Ref ref;

  Future<HlsDataModel> decryptPlaylistData({
    required String token,
    required String url,
    required String key,
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

      final data = response.data;

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
    } catch (e) {
      rethrow;
    }
  }

  Future<MasterPlaylistModel> fetchMasterPlaylist({
    required String url,
    required String token,
    required String key,
    required LocalHlsId hlsId,
  }) async {
    try {
      final hlsData =
          await decryptPlaylistData(token: token, url: url, key: key);

      final baseDir = await getApplicationDocumentsDirectory();

      final hlsPathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsId,
        isRemote: false,
      );

      final hlsParser = HlsParser(
        playlist: hlsData.master,
        encKeyPath: hlsPathManager.encKeyFile.path,
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

      final master = await fetchMasterPlaylist(
        url: url,
        token: token,
        key: key,
        hlsId: hlsId,
      );

      final hlsPathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsId,
        isRemote: true,
      );

      hlsPathManager.masterDir.createIfNotExist();

      hlsPathManager.masterFile().createIfNotExist();

      hlsPathManager.masterFile().writeAsStringSync(
            master.masterPlaylistData.toString(),
          );

      for (final resolution in master.resolutions) {
        hlsPathManager
            .videoDir(resolutionType: resolution.resolution)
            .createIfNotExist();
      }

      for (final audioGroup in master.audioTrackGroups) {
        for (final audioTrack in audioGroup.tracks) {
          hlsPathManager.audioDir(audioTrack: audioTrack).createIfNotExist();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchDataFromResolutionPlaylist(
    MasterPlaylistModel masterPlaylist,
    HlsResolution resolution,
  ) async {
    try {
      final response = await dio.get<String>(resolution.videoPlaylistUrl);
      final parser = HlsParser(
        playlist: response.data!,
      );
      final parsed = parser.parseData(HlsPlaylistType.videoSegmentPlaylist);
      return SegmentPlaylistParsedModel.fromParsedPlaylist(
        playlistData: parsed,
        isVideo: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchAudioPlaylist(
    MasterPlaylistModel masterPlaylist,
  ) async {
    // try {
    //   final response = await dio.get<String>(masterPlaylist.audioPlaylistUrl);
    //   final parser = HlsParser(
    //     playlist: response.data!,
    //     playlistUrl: masterPlaylist.audioPlaylistUrl,
    //     key: masterPlaylist.segmentPlaylistKey,
    //   );
    //   final parsed = parser.parseData(HlsPlaylistType.audioSegmentPlaylist);
    //   return SegmentPlaylistParsedModel.fromParsedPlaylist(
    //     playlistData: parsed,
    //     isVideo: false,
    //     playlistKey: masterPlaylist.segmentPlaylistKey,
    //   );
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
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
