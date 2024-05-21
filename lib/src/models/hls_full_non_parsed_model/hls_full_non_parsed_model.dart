import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/models/thumbs_non_parsed_playlist/thumbs_non_parsed_playlist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hls_full_non_parsed_model.freezed.dart';
part 'hls_full_non_parsed_model.g.dart';

@freezed
class HlsFullNonParsedModel with _$HlsFullNonParsedModel {
  factory HlsFullNonParsedModel({
    required String master,
    required List<HlsPlaylistDetailsModel> videoPlaylists,
    required List<HlsPlaylistDetailsModel> audioPlaylists,
    @ThumbsConverter() required List<ThumbsPlaylist> thumbsPlaylists,
    String? enc,
  }) = _HlsFullNonParsedModel;

  factory HlsFullNonParsedModel.fromJson(Map<String, dynamic> json) =>
      _$HlsFullNonParsedModelFromJson(json);
}
