// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'local_hls_id.g.dart';

@embedded
class LocalHlsId extends Equatable {
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
  List<Object?> get props => [
        contentId,
        filmId,
        seasonId,
        episodeId,
      ];
}
