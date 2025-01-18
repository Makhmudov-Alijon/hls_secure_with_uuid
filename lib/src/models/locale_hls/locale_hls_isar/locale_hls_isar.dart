import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../download_manager.dart';

part 'locale_hls_isar.g.dart';

@Collection(inheritance: false)
class LocalHlsModelIsar extends Equatable {
  LocalHlsModelIsar({
    required this.baseDirPath,
    required this.masterDirPath,
    required this.posterFilePath,
    required this.masterFilePath,
    required this.downloadTasksFilePath,
    required this.totalSegments,
    required this.hlsDetails,
    required this.downloadStatus,
  });

  Id id = Isar.autoIncrement;

  String baseDirPath;
  String masterDirPath;
  String posterFilePath;
  String masterFilePath;
  String downloadTasksFilePath;

  int totalSegments;

  late LocalHlsDetailsModel hlsDetails;

  LocalHlsStatus downloadStatus;

  /// transients
  @ignore
  Directory get baseDir => Directory(baseDirPath);

  set baseDir(Directory dir) => baseDirPath = dir.path;

  @ignore
  Directory get masterDir => Directory(masterDirPath);

  set masterDir(Directory dir) => masterDirPath = dir.path;

  @ignore
  File get posterFile => File(posterFilePath);

  set posterFile(File file) => posterFilePath = file.path;

  @ignore
  File get masterFile => File(masterFilePath);

  set masterFile(File file) => masterFilePath = file.path;



  @ignore
  File get downloadTasksFile => File(downloadTasksFilePath);

  set downloadTasksFile(File file) => downloadTasksFilePath = file.path;

  /// getters
  LocalHlsId get iD {
    final v = hlsDetails.localHlsId;

    return v;
  }

  @ignore
  HlsPathManager get pathManager {
    return HlsPathManager(
      baseDir: baseDir,
      localHlsId: iD!,
      isRemote: false,
    );
  }

  @ignore
  File get videoMasterFile {
    return pathManager.videoMasterFile(
      resolutionType: hlsDetails.resolution.resolution,
    );
  }

  @ignore
  List<File> get audioMasterFiles {
    return hlsDetails.audioTracks
        .map(
          (e) => pathManager.audioMasterFile(
            audioTrack: e,
          ),
        )
        .toList();
  }

  @ignore
  bool get videoMasterExists {
    return videoMasterFile.existsSync();
  }

  @ignore
  bool get audioMastersExists {
    for (final masterFile in audioMasterFiles) {
      if (!masterFile.existsSync()) {
        return false;
      }
    }
    return true;
  }

  bool validate() {
    return baseDir.existsSync() &&
        masterDir.existsSync() &&
        posterFile.existsSync() &&
        masterFile.existsSync() &&
        downloadTasksFile.existsSync() &&
        audioMastersExists &&
        videoMasterExists;
  }

  @ignore
  Duration get timeLeft {
    final hoursPassed =
        downloadStatus.getCreationDate.difference(DateTime.now()).inHours.abs();
    return Duration(
      hours: AppConstants.hlsLifeHours.inHours - hoursPassed,
    );
  }

  @ignore
  double get calculateProgress {
    /// point calculate
    double result = 0;
    if (downloadTasksFile.existsSync()) {
      final task = DownloadTask.fromFilee(downloadTasksFile);
      final downloadedTasks = task.items.where((v) => v.isDownloaded);
      result = downloadedTasks.length / task.items.length;
    }

    return result;
  }

  @ignore
  LocalHlsState get localHlsStateWithoutProgress {
    switch (downloadStatus.statusType) {
      case LocalHlsStatusType.error:
        return LocalHlsErrorState();
      case LocalHlsStatusType.inQueue:
        return LocalHlsInQueueState();
      case LocalHlsStatusType.paused:
        return LocalHlsPauseState();
      case LocalHlsStatusType.complete:
        return LocalHlsCompleteState();
      case LocalHlsStatusType.notExist:
        return LocalHlsNotExistState();
      case LocalHlsStatusType.downloading:
        return LocalHlsDownloadingState();
      case LocalHlsStatusType.deleted:
        return LocalHlsDeletedState();
      case LocalHlsStatusType.prepared:
        return LocalHlsPreparedState();
    }
  }

  @ignore
  LocalHlsState get localHlsState {
    final progress = calculateProgress;

    switch (downloadStatus.statusType) {
      case LocalHlsStatusType.error:
        return LocalHlsErrorState(
          progress: progress,
        );
      case LocalHlsStatusType.inQueue:
        return LocalHlsInQueueState(
          progress: progress,
        );
      case LocalHlsStatusType.paused:
        return LocalHlsPauseState(
          progress: progress,
        );
      case LocalHlsStatusType.complete:
        return LocalHlsCompleteState(
          progress: progress,
        );
      case LocalHlsStatusType.notExist:
        return LocalHlsNotExistState(
          progress: progress,
        );
      case LocalHlsStatusType.downloading:
        return LocalHlsDownloadingState(
          progress: progress,
        );
      case LocalHlsStatusType.deleted:
        return LocalHlsDeletedState(
          progress: progress,
        );
      case LocalHlsStatusType.prepared:
        return LocalHlsPreparedState(
          progress: progress,
        );

    }
  }

  @ignore
  @override
  List<Object?> get props => [
        hlsDetails,
        posterFile,
        masterFile,
        baseDir,
        masterDir,
        downloadStatus,
        downloadTasksFile,
        totalSegments,
      ];

  String get getStatusKey {
    if (hlsDetails.isSerial) {
      return '${hlsDetails.localHlsId.contentId}-${hlsDetails.localHlsId.episodeId}';
    }
    return '${hlsDetails.localHlsId.contentId}';
  }
}
