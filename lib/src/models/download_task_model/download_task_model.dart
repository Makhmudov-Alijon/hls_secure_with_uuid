import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';
import 'package:equatable/equatable.dart';

part 'download_task_model.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable TODO:
class DownloadTask extends Equatable {
  DownloadTask({
    this.id = -1,
    this.items = const [],
    this.totalBytes = 0,
    this.downloadedBytes = 0,
  });

  Id id = Isar.autoIncrement;
  @Embedded()
  List<DownloadItem> items;
  int totalBytes;
  int downloadedBytes;

  @ignore
  @override
  List<Object?> get props => [
        items,
        totalBytes,
        downloadedBytes,
      ];

  @ignore
  double get getProgress {
    var progress = downloadedBytes / totalBytes;
    final downloadedTasks = items.where((v) => v.isDownloaded);

    if (progress > .98) {
      if (downloadedTasks.length < items.length) {
        progress = .98;
      } else if (downloadedTasks.length == items.length) {
        progress = 1;
      }
    }

    return progress;
  }

  @ignore
  int get remainingBytes {
    return totalBytes - downloadedBytes;
  }
}
