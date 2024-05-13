// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_playlist_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HlsPlaylistDetailsModelImpl _$$HlsPlaylistDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HlsPlaylistDetailsModelImpl(
      path: json['path'] as String,
      data: json['data'] as String,
      size: (json['size'] as num).toInt(),
      filesCount: (json['files_count'] as num).toInt(),
    );

Map<String, dynamic> _$$HlsPlaylistDetailsModelImplToJson(
        _$HlsPlaylistDetailsModelImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'data': instance.data,
      'size': instance.size,
      'files_count': instance.filesCount,
    };
