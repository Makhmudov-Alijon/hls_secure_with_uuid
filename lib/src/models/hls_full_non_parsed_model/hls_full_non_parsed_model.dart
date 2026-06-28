import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';
import 'package:hls_secure_with_uuid/src/models/thumbs_non_parsed_playlist/thumbs_non_parsed_playlist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hls_full_non_parsed_model.freezed.dart';
part 'hls_full_non_parsed_model.g.dart';

@freezed
abstract class HlsFullNonParsedModel with _$HlsFullNonParsedModel {
  factory HlsFullNonParsedModel({
    required String master,
    required List<HlsPlaylistDetailsModel> videoPlaylists,
    required List<HlsPlaylistDetailsModel> audioPlaylists,
    @ThumbsConverter() required List<ThumbsPlaylist> thumbsPlaylists,
    required String enc,
  }) = _HlsFullNonParsedModel;

  factory HlsFullNonParsedModel.fromJson(Map<String, dynamic> json) =>
      _$HlsFullNonParsedModelFromJson(json);
}
