import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

import '../models/download_task_model/download_item_model.dart';
import '../models/download_task_model/download_task_model.dart';
import '../models/local_hls_model/local_hls_details_model.dart';
import '../models/local_hls_model/local_hls_model.dart';
import '../models/local_hls_model/local_hls_status.dart';
import '../models/master_playlist_model/hls_resolution.dart';
import '../models/master_playlist_model/master_playlist_model.dart';
import '../models/segment_playlist_model/hls_segment_playlist_key.dart';
import '../models/segment_playlist_model/segment_playlist_parsed_model.dart';
import '../providers/client_provider.dart';
import '../utils/hls_parser/hls_parser.dart';
import '../utils/hls_parser/hls_path_constants.dart';
import '../utils/hls_parser/hls_path_manager.dart';

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

  Future<MasterPlaylistModel> fetchDataFromMasterPlaylist(
    String masterPlaylistUrl,
  ) async {
    try {
      HlsSegmentsPlaylistKey? segmentPlaylistKey;
      final response = await dio.get<String>(masterPlaylistUrl);
      final parser = HlsParser(
        playlist: response.data!,
        playlistUrl: masterPlaylistUrl,
      );
      return MasterPlaylistModel.fromParsedPlaylist(
        parser.parseData(HlsPlaylistType.masterPlaylist),
        segmentPlaylistKey,
      );
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
        playlistUrl: resolution.videoPlaylistUrl,
        key: masterPlaylist.segmentPlaylistKey,
      );
      final parsed = parser.parseData(HlsPlaylistType.videoSegmentPlaylist);
      return SegmentPlaylistParsedModel.fromParsedPlaylist(
        parsed,
        true,
        masterPlaylist.segmentPlaylistKey,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchAudioPlaylist(
    MasterPlaylistModel masterPlaylist,
  ) async {
    try {
      final response = await dio.get<String>(masterPlaylist.audioPlaylistUrl);
      final parser = HlsParser(
        playlist: response.data!,
        playlistUrl: masterPlaylist.audioPlaylistUrl,
        key: masterPlaylist.segmentPlaylistKey,
      );
      final parsed = parser.parseData(HlsPlaylistType.audioSegmentPlaylist);
      return SegmentPlaylistParsedModel.fromParsedPlaylist(
        parsed,
        false,
        masterPlaylist.segmentPlaylistKey,
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
    final segments = [...audioPlaylist.segments, ...videoPlaylist.segments];
    final downloadItems = <DownloadItem>[];
    for (final segment in segments) {
      downloadItems.add(
        DownloadItem(
          url: segment.downloadLink,
          saveDir:
              segment.isVideo ? pathManager.videoDir : pathManager.audioDir,
          fileName: segment.isVideo
              ? pathManager.videoFileFrom(segment.downloadLink).fileName
              : pathManager.audioFileFrom(segment.downloadLink).fileName,
        ),
      );
    }
    return DownloadTask(
      items: downloadItems,
    );
  }

  Future<DownloadTask?> prepareDataForDownload({
    required LocalHlsDetailsModel hlsDetails,
    required MasterPlaylistModel masterPlaylist,
    HlsSegmentsPlaylistKey? key,
    bool isDownloading = false,
    String? posterLink,
  }) async {
    try {
      final baseDir = await HlsPathConstants.baseDir;
      final hlsPathManager = HlsPathManager(
        baseDir: baseDir,
        localHlsId: hlsDetails.id,
        resolutionType: hlsDetails.videoResolution.resolution,
      );

      final masterDir = hlsPathManager.masterDir..createIfNotExist();

      final audioDir = hlsPathManager.audioDir..createIfNotExist();

      final videoDir = hlsPathManager.videoDir..createIfNotExist();

      unawaited(
        downloadMustHaveData(
          [
            if (key != null &&
                !hlsPathManager.masterFileFrom(key.encKeyUrl).existsSync())
              DownloadItem(
                groupId: hlsDetails.id.toStringId(),
                url: key.encKeyUrl,
                saveDir: hlsPathManager.masterDir,
                fileName: hlsPathManager.masterFileFrom(key.encKeyUrl).fileName,
              ),
            if (posterLink != null && !hlsPathManager.posterFile.existsSync())
              DownloadItem(
                groupId: hlsDetails.id.toStringId(),
                url: posterLink,
                saveDir: hlsPathManager.masterDir,
                fileName: hlsPathManager.posterFile.fileName,
              ),
          ],
        ),
      );

      final videoPlaylist = await fetchDataFromResolutionPlaylist(
        masterPlaylist,
        hlsDetails.videoResolution,
      );

      final audioPlaylist = await fetchAudioPlaylist(
        masterPlaylist,
      );

      final masterFile = await hlsPathManager
          .masterFileFrom(masterPlaylist.masterPlaylistData.playlistUrl)
          .writeAsString(
            await masterPlaylist.masterPlaylistData.toLocalPlaylist(
              pathManager: hlsPathManager,
            ),
          );

      final videoMasterFile = await hlsPathManager
          .videoFileFrom(videoPlaylist.playlistData.playlistUrl)
          .writeAsString(
            await videoPlaylist.playlistData.toLocalPlaylist(
              pathManager: hlsPathManager,
            ),
          );

      final audioMasterFile = await hlsPathManager
          .audioFileFrom(audioPlaylist.playlistData.playlistUrl)
          .writeAsString(
            await audioPlaylist.playlistData.toLocalPlaylist(
              pathManager: hlsPathManager,
            ),
          );

      final localHls = LocalHlsModel(
        hlsDetails: hlsDetails,
        downloadStatus: LocalHlsStatus(
          statusType: isDownloading
              ? LocalHlsStatusType.inQueue
              : LocalHlsStatusType.downloading,
          creationDate: DateTime.now(),
        ),
        posterFile: hlsPathManager.posterFile,
        masterFile: masterFile,
        masterDir: masterDir,
        audioDir: audioDir,
        videoDir: videoDir,
        audioMasterFile: audioMasterFile,
        videoMasterFile: videoMasterFile,
        downloadTasksFile: hlsPathManager.downloadTaskFile,
        localHlsFile: hlsPathManager.localHlsFile,
        videoSegmentsLength: videoPlaylist.segments.length,
        audioSegmentsLength: audioPlaylist.segments.length,
      );

      final downloadTask = _prepareDownloadTaskItems(
        audioPlaylist: audioPlaylist,
        videoPlaylist: videoPlaylist,
        pathManager: hlsPathManager,
      );

      await hlsPathManager.downloadTaskFile
          .writeAsString(downloadTask.toJson());

      await hlsPathManager.localHlsFile.writeAsString(
        localHls.toJson(),
      );

      return downloadTask;
    } catch (e) {
      return null;
    }
  }
}
