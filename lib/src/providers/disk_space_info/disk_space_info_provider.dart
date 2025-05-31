import 'dart:async';
import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../repository/isar/download_task/download_task_repository_impl.dart';

part 'disk_space_info_state.dart';

final diskSpaceInfoProvider =
    AutoDisposeAsyncNotifierProvider<DiskSpaceInfoNotifier, DiskSpaceInfoState>(
  DiskSpaceInfoNotifier.new,
);

class DiskSpaceInfoNotifier
    extends AutoDisposeAsyncNotifier<DiskSpaceInfoState> {
  Future<DiskSpaceInfoState> checkState() async {
    double? totalDiskSpace;

    totalDiskSpace = await DiskSpace.getTotalDiskSpace;

    List<Directory> directories;

    if (Platform.isIOS) {
      directories = [HlsDirectoryHelper.instance.appDir];
    } else if (Platform.isAndroid) {
      directories =
          await getExternalStorageDirectories(type: StorageDirectory.movies)
              .then(
        (list) async => list ?? [HlsDirectoryHelper.instance.appDir],
      );
    } else {
      directories = [];
    }
    double free = 0;

    for (final directory in directories) {
      final space = await DiskSpace.getFreeDiskSpaceForPath(directory.path);
      if (space != null) {
        free += space;
      }
    }
    var occupied = 0;
    final list = await ref.read(downloadTaskIsarProvider).getAll();
    for (final v in list) {
      occupied += v.downloadedBytes;
    }

    return const DiskSpaceInfoState().copyWith(
      occupied: occupied.toMb,
      total: totalDiskSpace,
      available: free,
    );
  }

  @override
  FutureOr<DiskSpaceInfoState> build() async {
    return checkState();
  }
}
