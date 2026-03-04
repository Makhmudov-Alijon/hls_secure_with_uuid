import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/utils/serializers/thumbs_serializer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../thumbs_playlist_details_model/thumbs_playlist_details_model.dart';

part 'hls_full_non_parsed_model.freezed.dart';
part 'hls_full_non_parsed_model.g.dart';

@freezed
class HlsFullNonParsedModel with _$HlsFullNonParsedModel {
  factory HlsFullNonParsedModel({
    required String master,
    required String baseUrl,
    required List<HlsPlaylistDetailsModel> videoPlaylists,
    required List<HlsPlaylistDetailsModel> audioPlaylists,
    @ThumbsSerializer()
    required Map<ThumbsPlaylistType, ThumbsPlaylistDetailsModel>
        thumbsPlaylists,
    required String enc,
    String? token,
  }) = _HlsFullNonParsedModel;

  factory HlsFullNonParsedModel.fromJson(Map<String, dynamic> json) =>
      _$HlsFullNonParsedModelFromJson(json);
}
