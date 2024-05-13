import 'package:freezed_annotation/freezed_annotation.dart';

import '../hls_playlist_details_model/hls_playlist_details_model.dart';

part 'hls_data_model.freezed.dart';
part 'hls_data_model.g.dart';

@freezed
class HlsDataModel with _$HlsDataModel {
  factory HlsDataModel({
    required String master,
    required List<HlsPlaylistDetailsModel> videoPlaylists,
    required List<HlsPlaylistDetailsModel> audioPlaylists,
    String? enc,
  }) = _HlsDataModel;

  factory HlsDataModel.fromJson(Map<String, dynamic> json) =>
      _$HlsDataModelFromJson(json);
}
