// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

enum HlsResolutionType {
  v240p('240p', 240, '240p'),
  v360p('360p', 360, '360 SD'),
  v480p('480p', 480, '480 SD'),
  v720p('720p', 720, '720 HD'),
  v1080p('1080p', 1080, '1080 FHD'),
  v2k('2k', 2560, '2560 QHD'),
  v4k('4k', 3840, '3840 UHD');

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
      (element) => element.title == value,
    );
  }
}

@Entity()
class HlsResolution extends Equatable {
    HlsResolution({
    required this.resolution,
    required this.videoPlaylistUrl,
    required this.trackType,
    required this.filesCount,
    required this.size,

    this.id = 0,
  });

  @Property(type: PropertyType.byte)
  final HlsResolutionType resolution;
  final String videoPlaylistUrl; 
  final int size;
  final int filesCount;
  @Property(type: PropertyType.byte) // Store enum as byte
  HlsAudioTrackTypee trackType;
  @Id(assignable: true)
  int id = 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'resolution': resolution.title,
      'videoPlaylistUrl': videoPlaylistUrl,
      'trackType': trackType.name,
      'filesCount': filesCount,
      'size': size,
    };
  }

  factory HlsResolution.fromMap(Map<String, dynamic> map) {
    return HlsResolution(
      size: map['size'] as int,
      filesCount: map['filesCount'] as int,
      resolution: HlsResolutionType.values.first
          .fromString(map['resolution'] as String),
      videoPlaylistUrl: map['videoPlaylistUrl'] as String,
      trackType:
          HlsAudioTrackTypee.values.first.fromString(map['trackType'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory HlsResolution.fromJson(String source) =>
      HlsResolution.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        resolution,
        videoPlaylistUrl,
        trackType,
        size,
        filesCount,
      ];
}
