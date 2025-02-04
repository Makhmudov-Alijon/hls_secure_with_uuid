import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../download_manager.dart';

part 'locale_hls_isar.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable TODO:
class LocalHlsModelIsar extends Equatable {
  LocalHlsModelIsar({
    this.totalSegments = 0,
    this.iv = '',
    required this.hlsDetails,
    this.downloadStatus,
  });

  Id id = Isar.autoIncrement;

  String iv;

  int totalSegments;

  LocalHlsDetailsModel hlsDetails;

  LocalHlsStatus? downloadStatus;

  String get baseDirPath => HlsDirectoryHelper.instance.appDir.path;

  @ignore
  Directory get baseDir => Directory(baseDirPath);

  @ignore
  Directory get masterDir => pathManager.masterDir;

  @ignore
  File get posterFile => pathManager.posterFile;

  @ignore
  File posterFileForIsolate(String appDir) =>
      pathManagerForIsolate(appDir).posterFile;

  @ignore
  File get masterFile => pathManager.masterFile;

  /// getters
  LocalHlsId get iD {
    final v = hlsDetails.localHlsId;

    return v;
  }

  @ignore
  HlsPathManager get pathManager {
    return HlsPathManager(
      baseDir: HlsDirectoryHelper.instance.appDir,
      localHlsId: iD,
      isRemote: false,
    );
  }

  @ignore
  HlsPathManager pathManagerForIsolate(String appDir) {
    return HlsPathManager(
      baseDir: Directory(appDir),
      localHlsId: iD,
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
        audioMastersExists &&
        videoMasterExists;
  }

  @ignore
  Duration get timeLeft {
    final hoursPassed = downloadStatus!.getCreationDate
        .difference(DateTime.now())
        .inHours
        .abs();
    return Duration(
      hours: AppConstants.hlsLifeHours.inHours - hoursPassed,
    );
  }

  @ignore
  LocalHlsState localHlsState({
    double progresss = 0,
  }) {
    switch (downloadStatus!.statusType) {
      case LocalHlsStatusType.error:
        return LocalHlsErrorState(
          progress: progresss,
        );
      case LocalHlsStatusType.inQueue:
        return LocalHlsInQueueState(
          progress: progresss,
        );
      case LocalHlsStatusType.paused:
        return LocalHlsPauseState(
          progress: progresss,
        );
      case LocalHlsStatusType.complete:
        return LocalHlsCompleteState(
          progress: progresss,
        );
      case LocalHlsStatusType.notExist:
        return LocalHlsNotExistState(
          progress: progresss,
        );
      case LocalHlsStatusType.downloading:
        return LocalHlsDownloadingState(
          progress: progresss,
        );
      case LocalHlsStatusType.deleted:
        return LocalHlsDeletedState(
          progress: progresss,
        );
      case LocalHlsStatusType.prepared:
        return LocalHlsPreparedState(
          progress: progresss,
        );

      case LocalHlsStatusType.waitingForNetwork:
        return LocalHlsWaitingForNetworkState(
          progress: progresss,
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
        totalSegments,
      ];

  String get getStatusKey {
    if (hlsDetails.isSerial) {
      return '${hlsDetails.localHlsId.contentId}-${hlsDetails.localHlsId.episodeId}';
    }
    return '${hlsDetails.localHlsId.contentId}';
  }
}
