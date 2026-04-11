import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../stat_repository/local_stat_repository.dart';

final localStatRepositoryProvider = Provider<LocalStatRepository>(
  (ref) => LocalStatRepositoryApi(
    isar: ref.read(DownloadManagerProviders.isar),
  ),
);

class LocalStatRepositoryApi implements LocalStatRepository {
  LocalStatRepositoryApi({required this.isar});

  final Isar isar;

  @override
  Future<void> addDeletedHlsStat(HlsDeletedStatModel deletedHls) {
    return isar.writeTxn(
      () async {
        await isar.hlsDeletedStatModels.put(deletedHls);
      },
    );
  }

  @override
  Future<void> addDownloadedHlsStat(HlsDownloadedStatModel downloadedHls) {
    return isar.writeTxn(() async {
      await isar.hlsDownloadedStatModels.put(downloadedHls);
    });
  }

  @override
  Future<List<HlsDeletedStatModel>> getAllDeletedHls() {
    return isar.hlsDeletedStatModels.where().findAll();
  }

  @override
  Future<List<HlsDownloadedStatModel>> getAllDownloadedHls() {
    return isar.hlsDownloadedStatModels.where().findAll();
  }

  @override
  Future<void> removeDeletedHlsStat(HlsDeletedStatModel deletedHls) {
    return isar.writeTxn(() async {
      await isar.hlsDeletedStatModels.delete(deletedHls.isarId);
    });
  }

  @override
  Future<void> removeDownloadedHlsStat(HlsDownloadedStatModel downloadedHls) {
    return isar.writeTxn(
      () async {
        await isar.hlsDownloadedStatModels.delete(downloadedHls.isarId);
      },
    );
  }
}
