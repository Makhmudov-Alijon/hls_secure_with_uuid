import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../download_manager.dart';

part 'locale_hls_isar.g.dart';

@collection
class LocalHlsModelIsar extends Equatable {
  LocalHlsModelIsar({
    required this.baseDirPath,
    required this.masterDirPath,
    required this.posterFilePath,
    required this.masterFilePath,
    required this.localHlsFilePath,
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
  String localHlsFilePath;
  String downloadTasksFilePath;

  int totalSegments;

  // Relationships
  final LocalHlsDetailsModel hlsDetails;

  final LocalHlsStatus downloadStatus;

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
  File get localHlsFilee => File(localHlsFilePath);

  set localHlsFilee(File file) => localHlsFilePath = file.path;

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
        localHlsFilee.existsSync() &&
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
    double result = 0;
    if (downloadTasksFile.existsSync()) {
      final task = DownloadTask.fromFile(downloadTasksFile);
      final downloadedTasks = task.items.where((v) => v.isDownloaded);
      result = downloadedTasks.length / task.items.length;
    }

    return result;
  }

  @ignore
  LocalHlsState get localHlsStateWithoutProgress {
    const progress = 0.0;

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

  @override
  List<Object?> get props => [
        hlsDetails,
        posterFile,
        masterFile,
        baseDir,
        masterDir,
        downloadStatus,
        downloadTasksFile,
        localHlsFilee,
        totalSegments,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'masterDir': masterDirPath,
      'posterFile': posterFilePath,
      'masterFile': masterFilePath,
      'hlsDetails': hlsDetails.toJson(),
      'downloadStatus': downloadStatus.toMap(),
      'downloadTaskFile': downloadTasksFilePath,
      'localHlsFile': localHlsFilePath,
      'baseDir': baseDirPath,
      'totalSegments': totalSegments,
    };
  }

  factory LocalHlsModelIsar.fromFile(File file) {
    final content = file.readAsStringSync();
    return LocalHlsModelIsar.fromJson(content);
  }

  factory LocalHlsModelIsar.fromMap(Map<String, dynamic> json) {
    final baseDirPat = json['baseDir'] as String?;
    final masterDirPat = json['masterDir'] as String?;
    final posterFilePat = json['posterFile'] as String?;
    final masterFilePat = json['masterFile'] as String?;
    final localHlsFilePat = json['localHlsFile'] as String?;
    final downloadTasksFilePat = json['downloadTaskFile'] as String?;
    final totalSegment = json['totalSegments'] as int?;

    final v = 0;
    final model = LocalHlsModelIsar(
      baseDirPath: baseDirPat!,
      masterDirPath: masterDirPat!,
      posterFilePath: posterFilePat!,
      masterFilePath: masterFilePat!,
      localHlsFilePath: localHlsFilePat!,
      downloadTasksFilePath: downloadTasksFilePat!,
      totalSegments: totalSegment!,
      hlsDetails: LocalHlsDetailsModel.fromJson(json['hlsDetails'] as String),
      downloadStatus: LocalHlsStatus.fromMap(
          json['downloadStatus'] as Map<String, dynamic>),
    );

    return model;
  }

  String toJson() => jsonEncode(toMap());

  factory LocalHlsModelIsar.fromJson(String source) =>
      LocalHlsModelIsar.fromMap(json.decode(source) as Map<String, dynamic>);

  LocalHlsModelIsar copyWith({
    Directory? baseDir,
    Directory? masterDir,
    File? posterFile,
    File? masterFile,
    File? localHlsFile,
    File? downloadTasksFile,
    LocalHlsDetailsModel? hlsDetails,
    LocalHlsStatus? downloadStatus,
    int? totalSegments,
    File? mediumThumbnailsFile,
    File? largeThumbnailsFile,
  }) {
    final model = LocalHlsModelIsar(
      baseDirPath: baseDir == null ? baseDirPath : baseDir.path,
      masterDirPath: masterDir != null ? masterDir.path : masterDirPath,
      posterFilePath: posterFile != null ? posterFile.path : posterFilePath,
      masterFilePath: masterFile != null ? masterFile.path : masterFilePath,
      localHlsFilePath:
          localHlsFile != null ? localHlsFile.path : localHlsFilePath,
      downloadTasksFilePath: downloadTasksFile != null
          ? downloadTasksFile.path
          : downloadTasksFilePath,
      totalSegments: totalSegments ?? this.totalSegments,
      hlsDetails: hlsDetails ?? this.hlsDetails,
      downloadStatus: downloadStatus ?? this.downloadStatus,
    );

    return model;
  }

  String get getStatusKey {
    final hd = hlsDetails;

    if (hlsDetails.isSerial) {
      return '${hlsDetails.localHlsId.contentId}-${hlsDetails.localHlsId.episodeId}';
    }
    return '${hlsDetails.localHlsId.contentId}';
  }
}
