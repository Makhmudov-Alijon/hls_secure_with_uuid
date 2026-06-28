// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_full_non_parsed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HlsFullNonParsedModel _$HlsFullNonParsedModelFromJson(
        Map<String, dynamic> json) =>
    _HlsFullNonParsedModel(
      master: json['master'] as String,
      baseUrl: json['base_url'] as String,
      videoPlaylists: (json['video_playlists'] as List<dynamic>)
          .map((e) =>
              HlsPlaylistDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      audioPlaylists: (json['audio_playlists'] as List<dynamic>)
          .map((e) =>
              HlsPlaylistDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      thumbsPlaylists: const ThumbsSerializer()
          .fromJson(json['thumbs_playlists'] as Map<String, dynamic>),
      enc: json['enc'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$HlsFullNonParsedModelToJson(
        _HlsFullNonParsedModel instance) =>
    <String, dynamic>{
      'master': instance.master,
      'base_url': instance.baseUrl,
      'video_playlists':
          instance.videoPlaylists.map((e) => e.toJson()).toList(),
      'audio_playlists':
          instance.audioPlaylists.map((e) => e.toJson()).toList(),
      'thumbs_playlists':
          const ThumbsSerializer().toJson(instance.thumbsPlaylists),
      'enc': instance.enc,
      'token': instance.token,
    };
