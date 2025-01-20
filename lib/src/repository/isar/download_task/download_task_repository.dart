import 'package:download_manager/download_manager.dart';

abstract class DownloadTaskIsarRepository {
  Future<Id> create(DownloadTask v);

  Future<DownloadTask> delete(DownloadTask v);

  Future<DownloadTask> update(DownloadTask v);

  Future<DownloadTask?> getById(Id v);
}
