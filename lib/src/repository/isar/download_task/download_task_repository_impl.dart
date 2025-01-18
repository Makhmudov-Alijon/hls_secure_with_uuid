import 'package:download_manager/src/repository/isar/download_task/download_task_repository.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../download_manager.dart';

final downloadTaskIsarProvider = Provider<DownloadTaskIsarRepository>(
  (ref) => DownloadTaskIsarRepositoryImpl(
    isar: ref.read(isarProvider),
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
  Future<DownloadTask> delete(DownloadTask v) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<DownloadTask> update(DownloadTask v) {
    // TODO: implement update
    throw UnimplementedError();
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
}
