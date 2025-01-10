import '../../models/isar_models/local_hls_stat_models/hls_deleted_stat_model/hls_deleted_stat_model.dart';
import '../../models/isar_models/local_hls_stat_models/hls_downloaded_stat_model/hls_downloaded_stat_model.dart';

abstract class LocalStatRepository {
  Future<void> addDeletedHlsStat(HlsDeletedStatModel deletedHls);

  Future<void> removeDeletedHlsStat(HlsDeletedStatModel deletedHls);

  Future<void> addDownloadedHlsStat(HlsDownloadedStatModel downloadedHls);

  Future<void> removeDownloadedHlsStat(HlsDownloadedStatModel downloadedHls);

  Future<List<HlsDownloadedStatModel>> getAllDownloadedHls();

  Future<List<HlsDeletedStatModel>> getAllDeletedHls();
}
