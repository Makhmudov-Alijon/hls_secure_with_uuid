// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../master_playlist_model/hls_audio.dart';
import '../master_playlist_model/hls_resolution.dart';
import 'local_hls_id.dart';

class LocalHlsDetailsModel extends Equatable {
  const LocalHlsDetailsModel({
    required this.id,
    required this.title,
    required this.isSerial,
    required this.episodeNum,
    required this.seasonNum,
    required this.masterLink,
    required this.resolution,
    required this.audioTracks,
  });

  final LocalHlsId id;
  final String title;
  final bool isSerial;
  final int? episodeNum;
  final int? seasonNum;
  final String? masterLink;
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
      'masterLink': masterLink,
      'resolution': resolution.toMap(),
      'audioTracks': audioTracks.map((e) => e.toMap()).toSet(),
    };
  }

  factory LocalHlsDetailsModel.fromMap(Map<String, dynamic> map) {
    final audioTracks = map['audioTracks'] as Set<Map<String, dynamic>>;
    return LocalHlsDetailsModel(
      id: LocalHlsId.fromMap(map['id'] as Map<String, dynamic>),
      title: map['title'] as String,
      isSerial: map['isSerial'] as bool,
      episodeNum: map['episodeNum'] != null ? map['episodeNum'] as int : null,
      seasonNum: map['seasonNum'] != null ? map['seasonNum'] as int : null,
      masterLink:
          map['masterLink'] != null ? map['masterLink'] as String : null,
      resolution:
          HlsResolution.fromMap(map['resolution'] as Map<String, dynamic>),
      audioTracks: Set<HlsAudioTrack>.from(
        audioTracks.map(HlsAudioTrack.fromMap),
      ),
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
        masterLink,
        resolution,
        audioTracks,
      ];
}
