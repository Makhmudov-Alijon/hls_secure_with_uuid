import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

part 'download_task_model.g.dart';

@Collection(inheritance: false)
class DownloadTask extends Equatable {
  DownloadTask({
    this.id = -1,
    this.items = const [],
    this.mbPerSegment = 0,
  });

  Id id = Isar.autoIncrement;
  @Embedded()
  List<DownloadItem> items;
  double mbPerSegment;

  @ignore
  @override
  List<Object?> get props => [items,mbPerSegment,];


}
