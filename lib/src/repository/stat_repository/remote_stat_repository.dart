import '../../models/isar_models/local_hls_stat_models/hls_deleted_stat_model/hls_deleted_stat_model.dart';
import '../../models/isar_models/local_hls_stat_models/hls_downloaded_stat_model/hls_downloaded_stat_model.dart';

abstract class RemoteStatRepository {
  Future<void> sendDownloadedHlsStat({
    required HlsDownloadedStatModel downloadedHlsStat,
  });

  Future<void> sendDeletedHlsStat({
    required HlsDeletedStatModel deletedHlsStat,
  });

  Future<void> checkHlsStats();
}
