import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'locale_hls_store_repository.dart';

final localeHlsStoreRepositoryProvider = Provider<LocaleHlsStoreRepository>(
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
  Future<LocalHlsModelIsar?> updateDownloadStatuss({
    required Id hls,
    required LocalHlsStatus status,
  }) {
    return isar.writeTxn(
      () async {
        try {
          final target = await isar.localHlsModelIsars.get(hls);
          target!.downloadStatus = status;
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
}
