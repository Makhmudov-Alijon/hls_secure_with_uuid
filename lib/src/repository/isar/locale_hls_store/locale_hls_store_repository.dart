import 'package:download_manager/download_manager.dart';

abstract class LocaleHlsStoreRepository {
  Future<Id> add(LocalHlsModelIsar hls);

  Future<LocalHlsModelIsar?> updateDownloadStatus({
    required Id hlsId,
    required LocalHlsStatus status,
    required String where,
  });

  Future<LocalHlsModelIsar?> getByLocaleHlsId({
    required LocalHlsId id,
  });
  Future<List<LocalHlsModelIsar>> getAll( );
  Future<void> delete(LocalHlsModelIsar hls);

  Future<void> clear();

  LocalHlsState getHlsDownloadStatusType({
    required Id hlsId,
  });
}
