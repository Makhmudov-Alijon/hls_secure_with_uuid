import 'package:download_manager/download_manager.dart';

abstract class LocaleHlsStoreRepository {
  Future<void> add(LocalHlsModelIsar hls);

  Future<LocalHlsModelIsar?> updateDownloadStatus({
    required LocalHlsModelIsar hls,
    required LocalHlsStatus status,
    required String where,
  });

  Future<LocalHlsModelIsar?> getByLocaleHlsId({
    required LocalHlsId id,
  });
  Future<void> delete(LocalHlsModelIsar hls);

  Future<void> clear();

  LocalHlsState getHlsDownloadStatusType({
    required Id hlsId,
  });
}
