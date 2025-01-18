import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../../entities/hls_audio/hls_audio.dart';
import '../../../entities/hls_resolution/hls_resolution.dart';
import '../locale_hls_id/local_hls_id.dart';

part 'local_hls_details_model.g.dart';

@Embedded(inheritance: false)
class LocalHlsDetailsModel extends Equatable {
  const LocalHlsDetailsModel({
    this.localHlsId = const LocalHlsId(),
    this.resolution = const HlsResolution(),
    this.title = '',
    this.isSerial = false,
    this.episodeNum = -1,
    this.seasonNum = -1,
    this.audioTracks = const [],
  });

  final String title;
  final bool isSerial;
  final int? episodeNum;
  final int? seasonNum;


  final LocalHlsId localHlsId;

  final HlsResolution resolution;

  final List<HlsAudioTrack> audioTracks;

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
    return resolution.size + audioSize;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': localHlsId.toMap(),
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
    final serialized = audioTracks.map(HlsAudioTrack.fromMap).toSet().toList();
    final model = LocalHlsDetailsModel(
      title: map['title'] as String,
      isSerial: map['isSerial'] as bool,
      episodeNum: map['episodeNum'] != null ? map['episodeNum'] as int : null,
      seasonNum: map['seasonNum'] != null ? map['seasonNum'] as int : null,
      localHlsId: LocalHlsId.fromMap(map['id'] as Map<String, dynamic>),
      resolution:
          HlsResolution.fromMap(map['resolution'] as Map<String, dynamic>),
      audioTracks: serialized,
    );

    return model;
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsDetailsModel.fromJson(String source) =>
      LocalHlsDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  @ignore
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
