import 'package:download_manager/download_manager.dart';

abstract class DownloadTaskIsarRepository {
  Future<Id> create(DownloadTask v);

  
  Future<DownloadTask?> updateDownloadedSize(Id hlsId, {required int downloadedSize});

  Future<List<DownloadTask>> getAll();

  Future<DownloadTask?> getById(Id v);
}
