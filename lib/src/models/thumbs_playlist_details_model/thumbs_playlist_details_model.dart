import 'package:freezed_annotation/freezed_annotation.dart';

part 'thumbs_playlist_details_model.freezed.dart';
part 'thumbs_playlist_details_model.g.dart';

@freezed
abstract class ThumbsPlaylistDetailsModel with _$ThumbsPlaylistDetailsModel {
  factory ThumbsPlaylistDetailsModel({
    required String uri,
    required String baseUrl,
    required String name,
    required int size,
    required int filesCount,
    required String data,
  }) = _ThumbsPlaylistDetailsModel;

  factory ThumbsPlaylistDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ThumbsPlaylistDetailsModelFromJson(json);
}
