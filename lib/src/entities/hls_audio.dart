// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

enum HlsAudioTrackTypee {
  low('group_audio_low', 'low'),
  high('group_audio_high', 'high'),
  defaultTrack('default', 'default');

  const HlsAudioTrackTypee(this.name, this.shortName);

  final String name;
  final String shortName;
}

extension HlsAudioTrackTypeX on HlsAudioTrackTypee {
  HlsAudioTrackTypee fromString(String name) {
    for (final trackType in HlsAudioTrackTypee.values) {
      if (trackType.name == name) {
        return trackType;
      }
    }
    return HlsAudioTrackTypee.defaultTrack;
  }
}

@Entity()
class HlsAudioTrack extends Equatable {
  HlsAudioTrack({
    required this.trackType,
    required this.trackUrl,
    required this.trackName,
    required this.filesCount,
    required this.size,
    this.id = 0,
  });

  final String trackName;
  final String trackUrl;
  final int size;
  final int filesCount;
  @Id(assignable: true)
  int id = 0;
  @Property(type: PropertyType.byte)
  HlsAudioTrackTypee trackType;

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
      trackType: HlsAudioTrackTypee.values.first
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
