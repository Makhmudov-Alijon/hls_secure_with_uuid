// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

enum HlsResolutionType {
  v240p("/240p", 240, "240p"),
  v360p("/360p", 360, "360 SD"),
  v480p("/480p", 480, "480 SD"),
  v720p("/720p", 720, "720 HD"),
  v1080p("/1080p", 1080, "1080 FHD"),
  v2k("/2k", 2560, "2560 QHD"),
  v4k("/4k", 3840, "3840 UHD");

  const HlsResolutionType(
    this.title,
    this.quality,
    this.name,
  );

  final String title;
  final int quality;
  final String name;
}

extension HlsResolutionTypeExt on HlsResolutionType {
  HlsResolutionType fromString(String value) {
    return HlsResolutionType.values.firstWhere(
      (element) => value.contains(element.title),
    );
  }
}

class HlsResolution extends Equatable {
  const HlsResolution({
    required this.resolution,
    required this.videoPlaylistUrl,
  });

  final HlsResolutionType resolution;
  final String videoPlaylistUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'resolution': resolution.name,
      'videoPlaylistUrl': videoPlaylistUrl,
    };
  }

  factory HlsResolution.fromMap(Map<String, dynamic> map) {
    return HlsResolution(
      resolution: HlsResolutionType.values
          .firstWhere((element) => element.name == map['resolution'] as String),
      videoPlaylistUrl: map['videoPlaylistUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HlsResolution.fromJson(String source) =>
      HlsResolution.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [resolution, videoPlaylistUrl];
}
