// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

class LocalHlsModel extends Equatable {
  final Directory baseDir;
  final Directory masterDir;
  final File posterFile;
  final File masterFile;
  final File localHlsFile;
  final File downloadTasksFile;
  final LocalHlsDetailsModel hlsDetails;
  final LocalHlsStatus downloadStatus;
  final int totalSegments;

  const LocalHlsModel({
    required this.baseDir,
    required this.hlsDetails,
    required this.posterFile,
    required this.masterFile,
    required this.masterDir,
    required this.downloadStatus,
    required this.downloadTasksFile,
    required this.localHlsFile,
    required this.totalSegments,
  });

  LocalHlsId get id => hlsDetails.id;

  HlsPathManager get pathManager {
    return HlsPathManager(
      baseDir: baseDir,
      localHlsId: hlsDetails.id,
      isRemote: false,
    );
  }

  File get videoMasterFile {
    return pathManager.videoMasterFile(
      resolutionType: hlsDetails.resolution.resolution,
    );
  }

  List<File> get audioMasterFiles {
    return hlsDetails.audioTracks
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
    final hoursPassed =
        downloadStatus.creationDate.difference(DateTime.now()).inHours.abs();
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
        localHlsFile,
        totalSegments,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'masterDir': masterDir.path,
      'posterFile': posterFile.path,
      'masterFile': masterFile.path,
      'hlsDetails': hlsDetails.toMap(),
      'downloadStatus': downloadStatus.toMap(),
      'downloadTaskFile': downloadTasksFile.path,
      'localHlsFile': localHlsFile.path,
      'baseDir': baseDir.path,
      'totalSegments': totalSegments,
    };
  }

  factory LocalHlsModel.fromFile(File file) {
    final content = file.readAsStringSync();
    return LocalHlsModel.fromJson(content);
  }

  factory LocalHlsModel.fromMap(Map<String, dynamic> map) {
    return LocalHlsModel(
      totalSegments: map['totalSegments'] as int,
      baseDir: Directory(map['baseDir'] as String),
      masterDir: Directory(map['masterDir'] as String),
      posterFile: File(map['posterFile'] as String),
      masterFile: File(map['masterFile'] as String),
      hlsDetails: LocalHlsDetailsModel.fromMap(
        map['hlsDetails'] as Map<String, dynamic>,
      ),
      downloadStatus: LocalHlsStatus.fromMap(
        map['downloadStatus'] as Map<String, dynamic>,
      ),
      downloadTasksFile: File(map['downloadTaskFile'] as String),
      localHlsFile: File(map['localHlsFile'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsModel.fromJson(String source) =>
      LocalHlsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  LocalHlsModel copyWith({
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
    return LocalHlsModel(
      baseDir: baseDir ?? this.baseDir,
      masterDir: masterDir ?? this.masterDir,
      posterFile: posterFile ?? this.posterFile,
      masterFile: masterFile ?? this.masterFile,
      localHlsFile: localHlsFile ?? this.localHlsFile,
      downloadTasksFile: downloadTasksFile ?? this.downloadTasksFile,
      hlsDetails: hlsDetails ?? this.hlsDetails,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      totalSegments: totalSegments ?? this.totalSegments,
    );
  }

  String get getStatusKey {
    if (hlsDetails.isSerial) {
      return '${hlsDetails.id.contentId}-${hlsDetails.id.episodeId}';
    }
    return '${hlsDetails.id.contentId}';
  }
}
