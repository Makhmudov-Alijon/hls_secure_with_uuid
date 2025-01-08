// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LocalHlsDetailsModel extends Equatable {
  LocalHlsDetailsModel({
    required this.title,
    required this.isSerial,
    required this.episodeNum,
    required this.seasonNum,
    this.id = 0,
  });

  final String title;
  final bool isSerial;
  final int? episodeNum;
  final int? seasonNum;
  @Id(assignable: true)
  int id = 0;

  final ToOne<LocalHlsId> localHlsId = ToOne<LocalHlsId>();
  final ToOne<HlsResolution> resolution = ToOne<HlsResolution>();
  final ToMany<HlsAudioTrack> audioTracks = ToMany<HlsAudioTrack>();

  String fullTitle({String? episodeTitle, String? seasonTitle}) {
    if (isSerial) {
      final episode = [
        if (episodeNum != null) episodeNum.toString(),
        if (episodeTitle != null) episodeTitle,
      ].join(' ');

      final season = [
        if (seasonNum != null) seasonNum.toString(),
        if (seasonTitle != null) seasonTitle,
      ].join(' ');
      return '$title / $season / $episode';
    } else {
      return title;
    }
  }

  int get sizeBytes {
    var audioSize = 0;
    for (final audio in audioTracks) {
      audioSize += audio.size;
    }
    return resolution.target!.size + audioSize;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': localHlsId.target!.toMap(),
      'title': title,
      'isSerial': isSerial,
      'episodeNum': episodeNum,
      'seasonNum': seasonNum,
      'resolution': resolution.target!.toMap(),
      'audioTracks': audioTracks.map((e) => e.toMap()).toList(),
    };
  }

  factory LocalHlsDetailsModel.fromMap(Map<String, dynamic> map) {
    final audioTracks =
        List<Map<String, dynamic>>.from(map['audioTracks'] as List<dynamic>);
    final model = LocalHlsDetailsModel(
      title: map['title'] as String,
      isSerial: map['isSerial'] as bool,
      episodeNum: map['episodeNum'] != null ? map['episodeNum'] as int : null,
      seasonNum: map['seasonNum'] != null ? map['seasonNum'] as int : null,
    );
    model.localHlsId.target =
        LocalHlsId.fromMap(map['id'] as Map<String, dynamic>);
    model.resolution.target =
        HlsResolution.fromMap(map['resolution'] as Map<String, dynamic>);
    model.audioTracks.addAll(
      audioTracks.map(HlsAudioTrack.fromMap).toSet(),
    );
    return model;
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsDetailsModel.fromJson(String source) =>
      LocalHlsDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        localHlsId,
        title,
        isSerial,
        episodeNum,
        seasonNum,
        resolution,
        audioTracks,
      ];
}
