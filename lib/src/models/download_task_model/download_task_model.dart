import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

part 'download_task_model.g.dart';

@Collection(inheritance: false)
class DownloadTask extends Equatable {
  DownloadTask({
    this.id = -1,
    this.items = const [],
    this.mbPerSegment = 0,
    this.doneTasksCount = 0,
  });

  Id id = Isar.autoIncrement;
  @Embedded()
  List<DownloadItem> items;
  double mbPerSegment;
  int doneTasksCount;

  @ignore
  @override
  List<Object?> get props => [
        items,
        mbPerSegment,
        doneTasksCount,
      ];

  @ignore
  double get getProgress {
    final downloadedTasks = items.where((v) => v.isDownloaded);

    final result = downloadedTasks.length / items.length;

    return result;
  }
}
