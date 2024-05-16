import 'package:freezed_annotation/freezed_annotation.dart';

import '../hls_playlist_details_model/hls_playlist_details_model.dart';

part 'hls_full_non_parsed_model.freezed.dart';
part 'hls_full_non_parsed_model.g.dart';

@freezed
class HlsFullNonParsedModel with _$HlsFullNonParsedModel {
  factory HlsFullNonParsedModel({
    required String master,
    required List<HlsPlaylistDetailsModel> videoPlaylists,
    required List<HlsPlaylistDetailsModel> audioPlaylists,
    String? enc,
  }) = _HlsFullNonParsedModel;

  factory HlsFullNonParsedModel.fromJson(Map<String, dynamic> json) =>
      _$HlsFullNonParsedModelFromJson(json);
}
