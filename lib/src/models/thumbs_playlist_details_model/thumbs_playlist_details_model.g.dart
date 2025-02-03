// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbs_playlist_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThumbsPlaylistDetailsModelImpl _$$ThumbsPlaylistDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ThumbsPlaylistDetailsModelImpl(
      uri: json['uri'] as String,
      baseUrl: json['base_url'] as String,
      name: json['name'] as String,
      size: (json['size'] as num).toInt(),
      filesCount: (json['files_count'] as num).toInt(),
      data: json['data'] as String,
    );

Map<String, dynamic> _$$ThumbsPlaylistDetailsModelImplToJson(
        _$ThumbsPlaylistDetailsModelImpl instance) =>
    <String, dynamic>{
      'uri': instance.uri,
      'base_url': instance.baseUrl,
      'name': instance.name,
      'size': instance.size,
      'files_count': instance.filesCount,
      'data': instance.data,
    };
