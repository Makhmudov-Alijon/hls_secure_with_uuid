// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_full_non_parsed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HlsFullNonParsedModelImpl _$$HlsFullNonParsedModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HlsFullNonParsedModelImpl(
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

Map<String, dynamic> _$$HlsFullNonParsedModelImplToJson(
        _$HlsFullNonParsedModelImpl instance) =>
    <String, dynamic>{
      'master': instance.master,
      'video_playlists':
          instance.videoPlaylists.map((e) => e.toJson()).toList(),
      'audio_playlists':
          instance.audioPlaylists.map((e) => e.toJson()).toList(),
      'enc': instance.enc,
    };
