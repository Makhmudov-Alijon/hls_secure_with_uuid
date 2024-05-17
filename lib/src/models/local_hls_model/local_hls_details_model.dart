// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

class LocalHlsDetailsModel extends Equatable {
  const LocalHlsDetailsModel({
    required this.id,
    required this.title,
    required this.isSerial,
    required this.episodeNum,
    required this.seasonNum,
    required this.resolution,
    required this.audioTracks,
  });

  final LocalHlsId id;
  final String title;
  final bool isSerial;
  final int? episodeNum;
  final int? seasonNum;
  final HlsResolution resolution;
  final Set<HlsAudioTrack> audioTracks;

  String get fullTitle {
    if (isSerial) {
      return '$title, $seasonNum, $episodeNum';
    } else {
      return title;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toMap(),
      'title': title,
      'isSerial': isSerial,
      'episodeNum': episodeNum,
      'seasonNum': seasonNum,
      'resolution': resolution.toMap(),
      'audioTracks': audioTracks.map((e) => e.toMap()).toList(),
    };
  }

  factory LocalHlsDetailsModel.fromMap(Map<String, dynamic> map) {
    final audioTracks =
        List<Map<String, dynamic>>.from(map['audioTracks'] as List<dynamic>);
    return LocalHlsDetailsModel(
      id: LocalHlsId.fromMap(map['id'] as Map<String, dynamic>),
      title: map['title'] as String,
      isSerial: map['isSerial'] as bool,
      episodeNum: map['episodeNum'] != null ? map['episodeNum'] as int : null,
      seasonNum: map['seasonNum'] != null ? map['seasonNum'] as int : null,
      resolution:
          HlsResolution.fromMap(map['resolution'] as Map<String, dynamic>),
      audioTracks: audioTracks.map(HlsAudioTrack.fromMap).toSet(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsDetailsModel.fromJson(String source) =>
      LocalHlsDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        id,
        title,
        isSerial,
        episodeNum,
        seasonNum,
        resolution,
        audioTracks,
      ];
}
