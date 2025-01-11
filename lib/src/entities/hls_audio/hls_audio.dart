// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'hls_audio.g.dart';

enum HlsAudioTrackType {
  low('group_audio_low', 'low'),
  high('group_audio_high', 'high'),
  defaultTrack('default', 'default');

  const HlsAudioTrackType(this.name, this.shortName);

  final String name;
  final String shortName;
}

extension HlsAudioTrackTypeX on HlsAudioTrackType {
  HlsAudioTrackType fromString(String name) {
    for (final trackType in HlsAudioTrackType.values) {
      if (trackType.name == name) {
        return trackType;
      }
    }
    return HlsAudioTrackType.defaultTrack;
  }
}

@Embedded(inheritance: false)
class HlsAudioTrack extends Equatable{
  HlsAudioTrack({
    this.trackType = HlsAudioTrackType.defaultTrack,
    this.trackUrl = '',
    this.trackName = '',
    this.filesCount = 0,
    this.size = 0,
  });

  final String trackName;
  final String trackUrl;
  final int size;
  final int filesCount;
  @enumerated
  HlsAudioTrackType trackType;

// @Property(type: PropertyType.int,)
//   int tcType = 2;
//
//   @Transient()
//   HlsAudioTrackType get trackType {
//     return HlsAudioTrackType.values[tcType];
//   }
//
//   set trackType(HlsAudioTrackType value) {
//     tcType = value.index;
//   }

  Map<String, dynamic> toMap() {
    return {
      'trackType': trackType.name,
      'trackName': trackName,
      'trackUrl': trackUrl,
      'filesCount': filesCount,
      'size': size,
    };
  }

  factory HlsAudioTrack.fromMap(Map<String, dynamic> json) {
    return HlsAudioTrack(
      filesCount: json['filesCount'] as int,
      size: json['size'] as int,
      trackType: HlsAudioTrackType.values.first
          .fromString(json['trackType'] as String),
      trackUrl: json['trackUrl'] as String,
      trackName: json['trackName'] as String,
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory HlsAudioTrack.fromJson(String jsonString) {
    return HlsAudioTrack.fromMap(
      json.decode(jsonString) as Map<String, dynamic>,
    );
  }

@override
@ignore
  List<Object?> get props => [
        trackType,
        trackUrl,
        trackName,
        size,
        filesCount,
      ];
}

class HlsAudioTrackGroup extends Equatable {
  const HlsAudioTrackGroup({required this.language, required this.tracks});

  final String language;
  final Set<HlsAudioTrack> tracks;

  @override
  List<Object?> get props => [language, tracks];

  HlsAudioTrackGroup copyWith({
    String? language,
    Set<HlsAudioTrack>? tracks,
  }) {
    return HlsAudioTrackGroup(
      language: language ?? this.language,
      tracks: tracks ?? this.tracks,
    );
  }
}
