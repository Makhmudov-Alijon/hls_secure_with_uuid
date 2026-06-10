// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:isar_community/isar.dart';

part 'local_hls_id.g.dart';

sealed class HlsId with EquatableMixin {
  const HlsId();

  const factory HlsId.content({
    int contentId,
    int? filmId,
    int? seasonId,
    int? episodeId,
  }) = LocalHlsId;

  const factory HlsId.minidrama({
    required int minidramaId,
    required int seasonId,
    required int episodeId,
  }) = MiniDramaHlsId;
}

class MiniDramaHlsId extends HlsId {
  const MiniDramaHlsId({
    required this.minidramaId,
    required this.seasonId,
    required this.episodeId,
  });

  final int minidramaId;
  final int seasonId;
  final int episodeId;

  @override
  List<Object?> get props => [minidramaId, seasonId, episodeId];
}

@Embedded(inheritance: false)
class LocalHlsId extends HlsId {
  const LocalHlsId({
    this.contentId = -1,
    this.filmId,
    this.seasonId,
    this.episodeId,
  });

  final int contentId;
  final int? filmId;
  final int? seasonId;
  final int? episodeId;

  bool get isSerial => episodeId != null;

  int? get hlsDataVideoId => filmId ?? episodeId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filmId': filmId,
      'seasonId': seasonId,
      'episodeId': episodeId,
      'contentId': contentId,
    };
  }

  String toStringId() {
    return '$filmId-$seasonId-$episodeId';
  }

  factory LocalHlsId.fromMap(Map<String, dynamic> map) {
    return LocalHlsId(
      filmId: map['filmId'] as int?,
      seasonId: map['seasonId'] as int?,
      episodeId: map['episodeId'] as int?,
      contentId: map['contentId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsId.fromJson(String source) =>
      LocalHlsId.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  @ignore
  List<Object?> get props => [
        contentId,
        filmId,
        seasonId,
        episodeId,
      ];

  @override
  String toString() {
    return '''contentId: $contentId, filmId: $filmId, seasonId: $seasonId, episodeId: $episodeId''';
  }
}
