// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'local_hls_id.g.dart';

@Embedded(inheritance: false)
class LocalHlsId extends Equatable {
  const LocalHlsId({
    this.contentId = -1,
    this.uuid,
    this.seasonId,
    this.episodeId,
  });

  final int contentId;
  final String? uuid;
  final int? seasonId;
  final int? episodeId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'seasonId': seasonId,
      'episodeId': episodeId,
      'contentId': contentId,
    };
  }

  String toStringId() {
    return '$uuid-$seasonId-$episodeId';
  }

  factory LocalHlsId.fromMap(Map<String, dynamic> map) {
    return LocalHlsId(
      uuid: map['uuid'] as String?,
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
        uuid,
        seasonId,
        episodeId,
      ];

  @override
  String toString() {
    return '''contentId: $contentId, uuid: $uuid, seasonId: $seasonId, episodeId: $episodeId''';
  }
}
