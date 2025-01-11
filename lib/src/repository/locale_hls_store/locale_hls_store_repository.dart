import 'package:download_manager/download_manager.dart';

abstract class LocaleHlsStoreRepository {
  Future<void> add(LocalHlsModelIsar hls);

  Future<LocalHlsModelIsar?> updateDownloadStatuss({
    required Id hls,
    required LocalHlsStatus status,
  });

  Future<LocalHlsModelIsar?> getByLocaleHlsId({
    required LocalHlsId id,
  });
  Future<void> delete(LocalHlsModelIsar hls);

  Future<void> clear();
}
