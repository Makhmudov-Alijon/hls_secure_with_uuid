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
  Future<void> add(LocalHlsModelIsar hls) {
    return isar.writeTxn(
      () async {
        await isar.localHlsModelIsars.put(hls);
      },
    );
  }

  @override
  Future<void> update(LocalHlsModelIsar hls) {
    return isar.writeTxn(
      () async {
        await isar.localHlsModelIsars.put(hls);
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
}
