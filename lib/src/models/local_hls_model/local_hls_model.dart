// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../providers/local_hls_movie_provider.dart';
import '../../utils/app_constants.dart';
import 'local_hls_details_model.dart';
import 'local_hls_id.dart';
import 'local_hls_status.dart';

class LocalHlsModel extends Equatable {
  final Directory masterDir;
  final Directory audioDir;
  final Directory videoDir;
  final File posterFile;
  final File masterFile;
  final File videoMasterFile;
  final File audioMasterFile;
  final File localHlsFile;
  final File downloadTasksFile;
  final LocalHlsDetailsModel hlsDetails;
  final LocalHlsStatus downloadStatus;
  final int videoSegmentsLength;
  final int audioSegmentsLength;

  const LocalHlsModel({
    required this.hlsDetails,
    required this.posterFile,
    required this.masterFile,
    required this.masterDir,
    required this.audioDir,
    required this.videoDir,
    required this.audioMasterFile,
    required this.videoMasterFile,
    required this.downloadStatus,
    required this.downloadTasksFile,
    required this.localHlsFile,
    required this.audioSegmentsLength,
    required this.videoSegmentsLength,
  });

  LocalHlsId get id => hlsDetails.id;

  int get sizeInBytes {
    final list = [
      ...videoDir.listSync(),
      ...audioDir.listSync(),
    ];
    var temp = 0;

    for (final item in list) {
      if (item is File) {
        temp += item.statSync().size;
      }
    }
    return temp;
  }

  Duration get timeLeft {
    final hoursPassed =
        downloadStatus.creationDate.difference(DateTime.now()).inHours.abs();
    return Duration(
      hours: AppConstants.hlsLifeHours.inHours - hoursPassed,
    );
  }

  LocalHlsModel copyWith({
    Directory? masterDir,
    Directory? audioDir,
    Directory? videoDir,
    File? posterFile,
    File? masterFile,
    File? videoMasterFile,
    File? audioMasterFile,
    File? localHlsFile,
    File? downloadTasksFile,
    LocalHlsDetailsModel? hlsDetails,
    LocalHlsStatus? downloadStatus,
    int? videoSegmentsLength,
    int? audioSegmentsLength,
  }) {
    return LocalHlsModel(
      masterDir: masterDir ?? this.masterDir,
      audioDir: audioDir ?? this.audioDir,
      videoDir: videoDir ?? this.videoDir,
      posterFile: posterFile ?? this.posterFile,
      masterFile: masterFile ?? this.masterFile,
      videoMasterFile: videoMasterFile ?? this.videoMasterFile,
      audioMasterFile: audioMasterFile ?? this.audioMasterFile,
      localHlsFile: localHlsFile ?? this.localHlsFile,
      downloadTasksFile: downloadTasksFile ?? this.downloadTasksFile,
      hlsDetails: hlsDetails ?? this.hlsDetails,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      videoSegmentsLength: videoSegmentsLength ?? this.videoSegmentsLength,
      audioSegmentsLength: audioSegmentsLength ?? this.audioSegmentsLength,
    );
  }

  double get downloadProgress {
    final currentSegments =
        videoDir.listSync().length + audioDir.listSync().length - 2;
    final totalSegments = videoSegmentsLength + audioSegmentsLength;
    return currentSegments / totalSegments;
  }

  LocalHlsState get localHlsState {
    switch (downloadStatus.statusType) {
      case LocalHlsStatusType.error:
        return LocalHlsErrorState(
          progress: downloadProgress,
        );
      case LocalHlsStatusType.inQueue:
        return LocalHlsInQueueState(
          progress: downloadProgress,
        );
      case LocalHlsStatusType.paused:
        return LocalHlsPauseState(
          progress: downloadProgress,
        );
      case LocalHlsStatusType.complete:
        return LocalHlsCompleteState(
          progress: downloadProgress,
        );
      case LocalHlsStatusType.notExist:
        return LocalHlsDisableState(
          progress: downloadProgress,
        );
      case LocalHlsStatusType.downloading:
        return LocalHlsDownloadingState(
          progress: downloadProgress,
        );
      case LocalHlsStatusType.deleted:
        return LocalHlsDeletedState(
          progress: downloadProgress,
        );
    }
  }

  @override
  List<Object?> get props => [
        hlsDetails,
        posterFile,
        masterFile,
        masterDir,
        audioDir,
        videoDir,
        audioMasterFile,
        videoMasterFile,
        downloadStatus,
        downloadTasksFile,
        localHlsFile,
        audioSegmentsLength,
        videoSegmentsLength,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'masterDir': masterDir.path,
      'audioDir': audioDir.path,
      'videoDir': videoDir.path,
      'posterFile': posterFile.path,
      'masterFile': masterFile.path,
      'videoMasterFile': videoMasterFile.path,
      'audioMasterFile': audioMasterFile.path,
      'hlsDetails': hlsDetails.toMap(),
      'downloadStatus': downloadStatus.toMap(),
      'videoSegmentsLength': videoSegmentsLength,
      'audioSegmentsLength': audioSegmentsLength,
      'downloadTaskFile': downloadTasksFile.path,
      'localHlsFile': localHlsFile.path,
    };
  }

  factory LocalHlsModel.fromFile(File file) {
    final content = file.readAsStringSync();
    return LocalHlsModel.fromJson(content);
  }

  factory LocalHlsModel.fromMap(Map<String, dynamic> map) {
    return LocalHlsModel(
      masterDir: Directory(map['masterDir'] as String),
      audioDir: Directory(map['audioDir'] as String),
      videoDir: Directory(map['videoDir'] as String),
      posterFile: File(map['posterFile'] as String),
      masterFile: File(map['masterFile'] as String),
      videoMasterFile: File(map['videoMasterFile'] as String),
      audioMasterFile: File(map['audioMasterFile'] as String),
      hlsDetails: LocalHlsDetailsModel.fromMap(
        map['hlsDetails'] as Map<String, dynamic>,
      ),
      downloadStatus: LocalHlsStatus.fromMap(
        map['downloadStatus'] as Map<String, dynamic>,
      ),
      downloadTasksFile: File(map['downloadTaskFile'] as String),
      localHlsFile: File(map['localHlsFile'] as String),
      videoSegmentsLength: map['videoSegmentsLength'] as int,
      audioSegmentsLength: map['audioSegmentsLength'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsModel.fromJson(String source) =>
      LocalHlsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
