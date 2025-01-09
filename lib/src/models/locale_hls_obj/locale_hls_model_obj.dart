import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../download_manager.dart';

@Entity()
class LocalHlsModelObj extends Equatable {
  LocalHlsModelObj({
    required this.baseDirPath,
    required this.masterDirPath,
    required this.posterFilePath,
    required this.masterFilePath,
    required this.localHlsFilePath,
    required this.downloadTasksFilePath,
    required this.totalSegments,
    this.id = 0,
  });

  @Id(assignable: true)
  int id = 0;

  String baseDirPath;
  String masterDirPath;
  String posterFilePath;
  String masterFilePath;
  String localHlsFilePath;
  String downloadTasksFilePath;

  int totalSegments;

  // Relationships
  final ToOne<LocalHlsDetailsModel> hlsDetails = ToOne<LocalHlsDetailsModel>();
  final ToOne<LocalHlsStatus> downloadStatus = ToOne<LocalHlsStatus>();

  /// transients
  @Transient()
  Directory get baseDir => Directory(baseDirPath);

  set baseDir(Directory dir) => baseDirPath = dir.path;

  @Transient()
  Directory get masterDir => Directory(masterDirPath);

  set masterDir(Directory dir) => masterDirPath = dir.path;

  @Transient()
  File get posterFile => File(posterFilePath);

  set posterFile(File file) => posterFilePath = file.path;

  @Transient()
  File get masterFile => File(masterFilePath);

  set masterFile(File file) => masterFilePath = file.path;

  @Transient()
  File get localHlsFile => File(localHlsFilePath);

  set localHlsFile(File file) => localHlsFilePath = file.path;

  @Transient()
  File get downloadTasksFile => File(downloadTasksFilePath);

  set downloadTasksFile(File file) => downloadTasksFilePath = file.path;

  /// getters

  LocalHlsId get iD {
    final v = hlsDetails.target!.localHlsId.target!;

    return v;
  }

  HlsPathManager get pathManager {
    return HlsPathManager(
      baseDir: baseDir,
      localHlsId: iD!,
      isRemote: false,
    );
  }

  File get videoMasterFile {
    return pathManager.videoMasterFile(
      resolutionType: hlsDetails.target!.resolution.target!.resolution,
    );
  }

  List<File> get audioMasterFiles {
    return hlsDetails.target!.audioTracks
        .map(
          (e) => pathManager.audioMasterFile(
            audioTrack: e,
          ),
        )
        .toList();
  }

  bool get videoMasterExists {
    return videoMasterFile.existsSync();
  }

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
        localHlsFile.existsSync() &&
        downloadTasksFile.existsSync() &&
        audioMastersExists &&
        videoMasterExists;
  }

  Duration get timeLeft {
    final hoursPassed = downloadStatus.target!.creationDate
        .difference(DateTime.now())
        .inHours
        .abs();
    return Duration(
      hours: AppConstants.hlsLifeHours.inHours - hoursPassed,
    );
  }

  double get calculateProgress {
    double result = 0;
    if (downloadTasksFile.existsSync()) {
      final task = DownloadTask.fromFile(downloadTasksFile);
      final downloadedTasks = task.items.where((v) => v.isDownloaded);
      result = downloadedTasks.length / task.items.length;
    }

    return result;
  }

  LocalHlsState get localHlsStateWithoutProgress {
    const progress = 0.0;

    switch (downloadStatus.target!.statusType) {
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

  LocalHlsState get localHlsState {
    final progress = calculateProgress;

    switch (downloadStatus.target!.statusType) {
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
        hlsDetails.target,
        posterFile,
        masterFile,
        baseDir,
        masterDir,
        downloadStatus.target,
        downloadTasksFile,
        localHlsFile,
        totalSegments,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'masterDir': masterDirPath,
      'posterFile': posterFilePath,
      'masterFile': masterFilePath,
      'hlsDetails': hlsDetails.target!.toJson(),
      'downloadStatus': downloadStatus.target!.toMap(),
      'downloadTaskFile': downloadTasksFilePath,
      'localHlsFile': localHlsFilePath,
      'baseDir': baseDirPath,
      'totalSegments': totalSegments,
    };
  }

  factory LocalHlsModelObj.fromFile(File file) {
    final content = file.readAsStringSync();
    return LocalHlsModelObj.fromJson(content);
  }

  factory LocalHlsModelObj.fromMap(Map<String, dynamic> json) {
    final baseDirPat = json['baseDir'] as String?;
    final masterDirPat = json['masterDir'] as String?;
    final posterFilePat = json['posterFile'] as String?;
    final masterFilePat = json['masterFile'] as String?;
    final localHlsFilePat = json['localHlsFile'] as String?;
    final downloadTasksFilePat = json['downloadTaskFile'] as String?;
    final totalSegment = json['totalSegments'] as int?;

    final v = 0;
    final model = LocalHlsModelObj(
      id: (json['id'] as int?) ?? 0,
      baseDirPath: baseDirPat!,
      masterDirPath: masterDirPat!,
      posterFilePath: posterFilePat!,
      masterFilePath: masterFilePat!,
      localHlsFilePath: localHlsFilePat!,
      downloadTasksFilePath: downloadTasksFilePat!,
      totalSegments: totalSegment!,
    );
    final hlsDt = json['hlsDetails'];
    final ds = json['downloadStatus'];
    final vv = 0;
    // Deserialize relationships
    if (hlsDt != null) {
      model.hlsDetails.target = LocalHlsDetailsModel.fromJson(hlsDt as String);
    } else {
      final v = 0;
    }

    if (ds != null) {
      if (ds is String) {
        model.downloadStatus.target = LocalHlsStatus.fromJson(ds);
      }
      if (ds is Map) {
        model.downloadStatus.target =
            LocalHlsStatus.fromMap(ds as Map<String, dynamic>);
      }
    }
    return model;
  }

  String toJson() => jsonEncode(toMap());

  factory LocalHlsModelObj.fromJson(String source) =>
      LocalHlsModelObj.fromMap(json.decode(source) as Map<String, dynamic>);

  LocalHlsModelObj copyWith({
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
    final model = LocalHlsModelObj(
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
    );
    // Deserialize relationships
    if (hlsDetails != null) {
      model.hlsDetails.target = hlsDetails;
    } else {
      model.hlsDetails.target = this.hlsDetails.target;
    }

    if (downloadStatus != null) {
      model.downloadStatus.target = downloadStatus;
    } else {
      model.downloadStatus.target = this.downloadStatus.target;
    }
    return model;
  }

  String get getStatusKey {
    final hd = hlsDetails.target;

    if (hlsDetails.target!.isSerial) {
      return '${hlsDetails.target!.localHlsId.target!.contentId}-${hlsDetails.target!.localHlsId.target!.episodeId}';
    }
    return '${hlsDetails.target!.localHlsId.target!.contentId}';
  }
}
