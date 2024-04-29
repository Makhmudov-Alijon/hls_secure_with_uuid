// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class LocalHlsId extends Equatable {
  const LocalHlsId({
    required this.movieId,
    this.seasonId,
    this.episodeId,
  });

  final int movieId;
  final int? seasonId;
  final int? episodeId;

  @override
  List<Object?> get props => [movieId, seasonId, episodeId];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'movieId': movieId,
      'seasonId': seasonId,
      'episodeId': episodeId,
    };
  }

  String toStringId() {
    return '$movieId-$seasonId-$episodeId';
  }

  factory LocalHlsId.fromMap(Map<String, dynamic> map) {
    return LocalHlsId(
      movieId: map['movieId'] as int,
      seasonId: map['seasonId'] != null ? map['seasonId'] as int : null,
      episodeId: map['episodeId'] != null ? map['episodeId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsId.fromJson(String source) =>
      LocalHlsId.fromMap(json.decode(source) as Map<String, dynamic>);
}
