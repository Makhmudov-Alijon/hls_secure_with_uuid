import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';

abstract class DownloadTaskIsarRepository {
  Future<Id> create(DownloadTask v);

  
  Future<DownloadTask?> updateDownloadedSize(Id hlsId, {required int downloadedSize});

  Future<List<DownloadTask>> getAll();

  Future<DownloadTask?> getById(Id v);
}
