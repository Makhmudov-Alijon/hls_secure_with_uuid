import 'package:hls_secure_with_uuid/src/repository/isar/download_task/download_task_repository.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../hls_secure_with_uuid.dart';

final downloadTaskIsarProvider = Provider<DownloadTaskIsarRepository>(
  (ref) => DownloadTaskIsarRepositoryImpl(
    isar: ref.read(isarProviderr),
  ),
);

class DownloadTaskIsarRepositoryImpl extends DownloadTaskIsarRepository {
  DownloadTaskIsarRepositoryImpl({required this.isar});

  final Isar isar;

  @override
  Future<Id> create(DownloadTask v) {
    return isar.writeTxn(
      () async {
        final id = await isar.downloadTasks.put(v);

        return id;
      },
    );
  }

  @override
  Future<DownloadTask?> getById(Id v) {
    return isar.writeTxn(
      () async {
        final result = await isar.downloadTasks.get(v);

        return result;
      },
    );
  }

  @override
  Future<List<DownloadTask>> getAll() {
    return isar.writeTxn(
      () async {
        final result = await isar.downloadTasks.where().findAll();

        return result;
      },
    );
  }

  @override
  Future<DownloadTask?> updateDownloadedSize(Id hlsId, {required int downloadedSize}) {
    return isar.writeTxn(
      () async {
        final result = await isar.downloadTasks.get(hlsId);
        if (result != null) {
          result.downloadedBytes = downloadedSize;
          await isar.downloadTasks.put(result);
        }

        return result;
      },
    );
  }
}
