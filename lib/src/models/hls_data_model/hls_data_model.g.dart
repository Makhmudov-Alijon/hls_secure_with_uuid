// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HlsDataModelImpl _$$HlsDataModelImplFromJson(Map<String, dynamic> json) =>
    _$HlsDataModelImpl(
      master: json['master'] as String,
      videoPlaylists: (json['video_playlists'] as List<dynamic>)
          .map((e) =>
              HlsPlaylistDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      audioPlaylists: (json['audio_playlists'] as List<dynamic>)
          .map((e) =>
              HlsPlaylistDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      enc: json['enc'] as String?,
    );

Map<String, dynamic> _$$HlsDataModelImplToJson(_$HlsDataModelImpl instance) =>
    <String, dynamic>{
      'master': instance.master,
      'video_playlists':
          instance.videoPlaylists.map((e) => e.toJson()).toList(),
      'audio_playlists':
          instance.audioPlaylists.map((e) => e.toJson()).toList(),
      'enc': instance.enc,
    };
