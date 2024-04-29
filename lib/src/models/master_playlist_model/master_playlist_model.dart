import 'package:download_manager/src/utils/hls_parser/hls_path_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../utils/hls_parser/hls_constants.dart';
import '../../utils/hls_parser/hls_parser.dart';
import '../segment_playlist_model/hls_segment_playlist_key.dart';
import 'hls_resolution.dart';

class MasterPlaylistModel extends Equatable {
  const MasterPlaylistModel({
    required this.resolutions,
    required this.masterPlaylistData,
    required this.audioPlaylistUrl,
    required this.playlistLocale,
    this.segmentPlaylistKey,
  });

  final String audioPlaylistUrl;
  final Set<HlsResolution> resolutions;
  final HlsPlaylistData masterPlaylistData;
  final Locale playlistLocale;
  final HlsSegmentsPlaylistKey? segmentPlaylistKey;

  factory MasterPlaylistModel.fromParsedPlaylist(
      HlsPlaylistData parsedMasterPlaylist,
      [HlsSegmentsPlaylistKey? segmentPlaylistKey]) {
    final resolutions = <HlsResolution>{};
    String? audioUrl;
    Locale? locale;

    for (var i = 0; i < parsedMasterPlaylist.playlistItems.length; i++) {
      final item = parsedMasterPlaylist.playlistItems[i];
      final videoUrl = item.url;
      if (videoUrl != null) {
        for (var resolution in HlsResolutionType.values) {
          if (videoUrl.contains(resolution.title)) {
            resolutions.add(
              HlsResolution(
                resolution: resolution,
                videoPlaylistUrl: videoUrl,
              ),
            );
          }
        }
      }

      if (item.hlsValueParameters[HlsParamConstants.type] ==
              HlsParamValueConstants.audio &&
          item.hlsValueParameters[HlsParamConstants.uri] != null) {
        audioUrl =
            item.hlsValueParameters[HlsParamConstants.uri]!.value.escapeQuotes;
      }

      final language =
          item.hlsValueParameters[HlsParamConstants.language]?.value;

      if (locale == null && language != null) {
        locale = Locale(language.replaceAll('"', ''));
      }
    }

    if (audioUrl == null) {
      throw UnimplementedError("Make sure your playlist contains AUDIO URI");
    } else if (locale == null) {
      throw UnimplementedError("Make sure your playlist contains LANGUAGE");
    }

    return MasterPlaylistModel(
      resolutions: resolutions,
      masterPlaylistData: parsedMasterPlaylist,
      audioPlaylistUrl: audioUrl,
      playlistLocale: locale,
      segmentPlaylistKey: segmentPlaylistKey,
    );
  }

  @override
  List<Object?> get props => [
        audioPlaylistUrl,
        resolutions,
        masterPlaylistData,
        audioPlaylistUrl,
        segmentPlaylistKey
      ];
}
