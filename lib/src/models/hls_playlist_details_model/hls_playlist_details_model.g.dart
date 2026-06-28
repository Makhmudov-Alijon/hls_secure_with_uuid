// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_playlist_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HlsPlaylistDetailsModel _$HlsPlaylistDetailsModelFromJson(
        Map<String, dynamic> json) =>
    _HlsPlaylistDetailsModel(
      baseUrl: json['base_url'] as String,
      uri: json['uri'] as String,
      data: json['data'] as String,
      size: (json['size'] as num).toInt(),
      filesCount: (json['files_count'] as num).toInt(),
    );

Map<String, dynamic> _$HlsPlaylistDetailsModelToJson(
        _HlsPlaylistDetailsModel instance) =>
    <String, dynamic>{
      'base_url': instance.baseUrl,
      'uri': instance.uri,
      'data': instance.data,
      'size': instance.size,
      'files_count': instance.filesCount,
    };
