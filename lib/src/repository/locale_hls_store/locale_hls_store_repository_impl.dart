import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'locale_hls_store_repository.dart';

final localeHlsIsarProvider = Provider<LocaleHlsStoreRepository>(
  (ref) => LocalHlsStoreRepositoryImpl(
    isar: ref.read(isarProvider),
  ),
);

class LocalHlsStoreRepositoryImpl implements LocaleHlsStoreRepository {
  LocalHlsStoreRepositoryImpl({required this.isar});

  final Isar isar;

  @override
  Future<Id> add(LocalHlsModelIsar hls) {
    return isar.writeTxn(
      () async {
        final v = await isar.localHlsModelIsars.put(hls);
        final theItem = await isar.localHlsModelIsars.get(v);

        final vv = 0;
        return v;
      },
    );
  }

  @override
  Future<LocalHlsModelIsar?> updateDownloadStatus({
    required LocalHlsModelIsar hls,
    required LocalHlsStatus status,
    required String where,
  }) {
    return isar.writeTxn(
      () async {
        try {
          final target = await isar.localHlsModelIsars.get(hls.id);
          target!.downloadStatus = status;
          await Prefs.putLocalHlsStatusIndex(hls.id, status.statusType.index);
          await isar.localHlsModelIsars.put(target);

          return target;
        } catch (e) {
          return null;
        }
      },
    );
  }

  @override
  Future<void> delete(LocalHlsModelIsar hls) {
    return isar.writeTxn(
      () async {
        await isar.localHlsModelIsars.delete(hls.id);
      },
    );
  }

  @override
  Future<LocalHlsModelIsar?> getByLocaleHlsId({required LocalHlsId id}) {
    return isar.writeTxn(
      () async {
        try {
          final all = await isar.localHlsModelIsars.where().findAll();
          final result = all.firstWhere((e) => e.hlsDetails.localHlsId == id);
          return result;
        } catch (e) {
          return null;
        }
      },
    );
  }

  @override
  Future<void> clear() {
    return isar.writeTxn(
      () async {
        return isar.localHlsModelIsars.clear();
      },
    );
  }

  @override
  LocalHlsState getHlsDownloadStatusType({
    required Id hlsId,
  }) {
    final index = Prefs.getLocalHlsStatusIndex(hlsId);
    if (index != null) {
      final type = LocalHlsStatusType.values[index];
      final result = _getHlsDownloadStatusType(
        statusType: type,
        progress: 0,
      );
      if (result is LocalHlsDeletedState) {
        final v = 0;
      }

      return result;
    } else {
      return LocalHlsNotExistState(
        progress: 0,
      );
    }
  }
}

LocalHlsState _getHlsDownloadStatusType({
  required LocalHlsStatusType statusType,
    required double progress,
}) {
  switch (statusType) {
      case LocalHlsStatusType.error:
        return LocalHlsErrorState(
          progress: progress,
        );
      case LocalHlsStatusType.inQueue:
        return LocalHlsInQueueState(
          progress: progress,
        );
      case LocalHlsStatusType.paused:
        return LocalHlsPauseState(
          progress: progress,
        );
      case LocalHlsStatusType.complete:
        return LocalHlsCompleteState(
          progress: progress,
        );
      case LocalHlsStatusType.notExist:
        return LocalHlsNotExistState(
          progress: progress,
        );
      case LocalHlsStatusType.downloading:
        return LocalHlsDownloadingState(
          progress: progress,
        );
      case LocalHlsStatusType.deleted:
        return LocalHlsDeletedState(
          progress: progress,
        );
      case LocalHlsStatusType.prepared:
        return LocalHlsPreparedState(
          progress: progress,
        );
  }
  }
