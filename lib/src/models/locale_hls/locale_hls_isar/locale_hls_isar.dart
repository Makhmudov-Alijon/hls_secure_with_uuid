import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../download_manager.dart';

part 'locale_hls_isar.g.dart';

@Collection(inheritance: false)
class LocalHlsModelIsar extends Equatable {
  LocalHlsModelIsar({
    this.baseDirPath = '',
    this.masterDirPath = '',
    this.posterFilePath = '',
    this.masterFilePath = '',
    this.totalSegments = 0,
    this.hlsDetails = const LocalHlsDetailsModel(),
    this.downloadStatus,
  });

  Id id = Isar.autoIncrement;

  String baseDirPath;
  String masterDirPath;
  String posterFilePath;
  String masterFilePath;

  int totalSegments;

  LocalHlsDetailsModel hlsDetails;

  LocalHlsStatus? downloadStatus;

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

  /// getters
  LocalHlsId get iD {
    final v = hlsDetails.localHlsId;

    return v;
  }

  @ignore
  HlsPathManager get pathManager {
    return HlsPathManager(
      baseDir: baseDir,
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
  Future<bool> get videoMasterExistsS async {
    return (await videoMasterFile.getDirWithReplacingUuid).existsSync();
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

  @ignore
  Future<bool> get audioMastersExistsS async {
    for (final masterFile in audioMasterFiles) {
      if (!(await masterFile.getDirWithReplacingUuid).existsSync()) {
        return false;
      }
    }
    return true;
  }

  Future<bool> validate() async {
    print('>< >< baseDir : ${baseDir.existsSync()}');
    print('>< >< masterDir : ${masterDir.existsSync()}');
    print('>< >< posterFile : ${posterFile.existsSync()}');
    print('>< >< masterFile : ${masterFile.existsSync()}');
    print('>< >< audioMastersExists : ${audioMastersExists}');
    print('>< >< videoMasterExists : ${videoMasterExists}');

    final result = (await baseDir.getDirWithReplacingUuid).existsSync() &&
        (await masterDir.getDirWithReplacingUuid).existsSync() &&
        (await posterFile.getDirWithReplacingUuid).existsSync() &&
        (await masterFile.getDirWithReplacingUuid).existsSync() &&
        await audioMastersExistsS &&
        await videoMasterExistsS;
    return result;
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
extension DirExte on Directory {
  Future<Directory> get getDirWithReplacingUuid {
    return Prefs.getString(PrefKeys.uuidOfDocPath).then((v) {
      if (v != null) {
        final parts = path.split('/')..replaceRange(6, 7, [v]);
        return Directory(parts.join('/'));
      }
      return this;
    });
  }

  Future<void> setUuiToPrefs() async {
    final parts = path.split('/');
    String? uuid;
    try {
      uuid = parts[6];
    } catch (e) {
      final v = 0;
    }
    if (uuid != null) {
      if (Prefs.initialized) {
        await Prefs.setString(PrefKeys.uuidOfDocPath, uuid);
      } else {
        await Prefs.initt();
        await Prefs.setString(PrefKeys.uuidOfDocPath, uuid);
      }
    } else {
      final v = 0;
    }
  }
}

extension FieleExt on File {
  Future<File> get getDirWithReplacingUuid {
    return Prefs.getString(PrefKeys.uuidOfDocPath).then((v) {
      if (v != null) {
        final parts = path.split('/')..replaceRange(6, 7, [v]);
        return File(parts.join('/'));
      }
      return this;
    });
  }
}
