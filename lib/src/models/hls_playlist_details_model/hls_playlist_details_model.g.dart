// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_playlist_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HlsPlaylistDetailsModel _$HlsPlaylistDetailsModelFromJson(
  Map<String, dynamic> json,
) => _HlsPlaylistDetailsModel(
  path: json['path'] as String,
  data: json['data'] as String,
  size: (json['size'] as num).toInt(),
  filesCount: (json['files_count'] as num).toInt(),
);

Map<String, dynamic> _$HlsPlaylistDetailsModelToJson(
  _HlsPlaylistDetailsModel instance,
) => <String, dynamic>{
  'path': instance.path,
  'data': instance.data,
  'size': instance.size,
  'files_count': instance.filesCount,
};
