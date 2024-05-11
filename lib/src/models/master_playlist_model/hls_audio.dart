// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

enum HlsAudioTrackType {
  low('group_audio_low', 'low'),
  high('group_audio_high', 'high');

  const HlsAudioTrackType(this.name, this.shortName);

  final String name;
  final String shortName;
}

extension HlsAudioTrackTypeX on HlsAudioTrackType {
  HlsAudioTrackType fromString(String name) {
    return HlsAudioTrackType.values
        .firstWhere((element) => element.name == name);
  }
}

class HlsAudioTrack extends Equatable {
  const HlsAudioTrack({
    required this.trackType,
    required this.trackUrl,
    required this.trackName,
  });

  final String trackName;
  final HlsAudioTrackType trackType;
  final String trackUrl;

  Map<String, dynamic> toMap() {
    return {
      'track_type': trackType.name,
      'track_name': trackName,
      'track_url': trackUrl,
    };
  }

  factory HlsAudioTrack.fromMap(Map<String, dynamic> json) {
    return HlsAudioTrack(
      trackType: HlsAudioTrackType.values.first
          .fromString(json['track_type'] as String),
      trackUrl: json['track_url'] as String,
      trackName: json['track_url'] as String,
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory HlsAudioTrack.fromJson(String jsonString) {
    return HlsAudioTrack.fromMap(
        json.decode(jsonString) as Map<String, dynamic>);
  }

  @override
  List<Object?> get props => [trackType, trackUrl];
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
