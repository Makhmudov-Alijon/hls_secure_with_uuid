import 'package:freezed_annotation/freezed_annotation.dart';

part 'hls_playlist_details_model.freezed.dart';
part 'hls_playlist_details_model.g.dart';

@freezed
abstract class HlsPlaylistDetailsModel with _$HlsPlaylistDetailsModel {
  factory HlsPlaylistDetailsModel({
    required String path,
    required String data,
    required int size,
    required int filesCount,
  }) = _HlsPlaylistDetailsModel;

  factory HlsPlaylistDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$HlsPlaylistDetailsModelFromJson(json);
}
