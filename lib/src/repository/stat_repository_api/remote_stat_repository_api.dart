import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../download_manager.dart';
import '../stat_repository/local_stat_repository.dart';
import '../stat_repository/remote_stat_repository.dart';
import 'local_stat_repository_api.dart';

final remoteStatRepositoryProvider = Provider<RemoteStatRepository>(
  (ref) {
    return RemoteStatRepositoryApi(
      endPoints: ref.read(DownloadManagerProviders.endpoints),
      client: ref.read(DownloadManagerProviders.client),
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
  final DownloadManagerEndPoints endPoints;

  final LocalStatRepository localRepository;

  @override
  Future<void> sendDeletedHlsStat({
    required HlsDeletedStatModel deletedHlsStat,
  }) async {
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
  Future<void> sendDownloadedHlsStat({
    required HlsDownloadedStatModel downloadedHlsStat,
  }) async {
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
    final downloaded = await localRepository.getAllDownloadedHls();
    final deleted = await localRepository.getAllDeletedHls();

    for (final item in downloaded) {
      await sendDownloadedHlsStat(downloadedHlsStat: item);
    }

    for (final item in deleted) {
      await sendDeletedHlsStat(deletedHlsStat: item);
    }
  }
}
