import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:download_manager/src/repository/stat_repository_api/the_endpoints/the_end_point_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../download_manager.dart';
import '../../models/isar_models/local_hls_stat_models/hls_deleted_stat_model/hls_deleted_stat_model.dart';
import '../../models/isar_models/local_hls_stat_models/hls_downloaded_stat_model/hls_downloaded_stat_model.dart';
import '../stat_repository/local_stat_repository.dart';
import '../stat_repository/remote_stat_repository.dart';
import 'local_stat_repository_api.dart';

final remoteStatRepositoryProvider = Provider<RemoteStatRepository>(
  (ref) {
    return RemoteStatRepositoryApi(
      endPoints: ref.read(theEndPointsProvider),
      client: ref.read(managerClientProvider),
      localRepository: ref.read(localStatRepositoryProvider),
    );
  },
);

class RemoteStatRepositoryApi implements RemoteStatRepository {
  RemoteStatRepositoryApi({
    required this.client,
    required this.localRepository,
    required this.endPoints,
  });

  final Dio client;
  final TheEndPoints endPoints;

  final LocalStatRepository localRepository;

  @override
  Future<void> sendDeletedHlsStat({
    required HlsDeletedStatModel deletedHlsStat,
  }) async {
    final endPoint = endPoints.removeDownloadedHlsState;

    try {
      await client.post<dynamic>(
        endPoints.removeDownloadedHlsState,
        data: FormData.fromMap(
          deletedHlsStat.toJson(),
        ),
      );
      await localRepository.removeDeletedHlsStat(deletedHlsStat);
    } catch (e) {
      await localRepository.addDeletedHlsStat(deletedHlsStat);
    }
  }

  @override
  Future<void> sendDownloadedHlsStat(
      {required HlsDownloadedStatModel downloadedHlsStat}) async {
    try {
      await client.post<dynamic>(
        endPoints.addDownloadedStat,
        data: FormData.fromMap(
          downloadedHlsStat.toJson(),
        ),
      );
      await localRepository.removeDownloadedHlsStat(downloadedHlsStat);
    } catch (e) {
      await localRepository.addDownloadedHlsStat(downloadedHlsStat);
    }
  }

  @override
  Future<void> checkHlsStats() async {
    log("checking hls stats");
    final downloaded = await localRepository.getAllDownloadedHls();
    log("downloaded: $downloaded");
    final deleted = await localRepository.getAllDeletedHls();
    log("deleted: $deleted");

    for (var item in downloaded) {
      await sendDownloadedHlsStat(downloadedHlsStat: item);
    }

    for (var item in deleted) {
      await sendDeletedHlsStat(deletedHlsStat: item);
    }
  }
}
