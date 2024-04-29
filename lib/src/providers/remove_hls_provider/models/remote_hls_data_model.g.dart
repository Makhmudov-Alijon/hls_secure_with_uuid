// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_hls_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteHlsDataModelImpl _$$RemoteHlsDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RemoteHlsDataModelImpl(
      master: json['master'] as String,
      videoPlaylists: (json['video_playlists'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      audioPlaylists: (json['audio_playlists'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$RemoteHlsDataModelImplToJson(
        _$RemoteHlsDataModelImpl instance) =>
    <String, dynamic>{
      'master': instance.master,
      'video_playlists': instance.videoPlaylists,
      'audio_playlists': instance.audioPlaylists,
    };
