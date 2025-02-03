import 'package:download_manager/src/entities/thumbs_playlist_type.dart';
import 'package:download_manager/src/models/thumbs_playlist_details_model/thumbs_playlist_details_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ThumbsSerializer extends JsonConverter<
    Map<ThumbsPlaylistType, ThumbsPlaylistDetailsModel>, Map<String, dynamic>> {
  const ThumbsSerializer();

  @override
  Map<ThumbsPlaylistType, ThumbsPlaylistDetailsModel> fromJson(
    Map<String, dynamic> json,
  ) {
    return Map.fromEntries(
      List.generate(
        ThumbsPlaylistType.values.length,
        (index) {
          final playlist = ThumbsPlaylistType.values.elementAt(index);
          return MapEntry(
            playlist,
            ThumbsPlaylistDetailsModel.fromJson(
              json[playlist.name] as Map<String, dynamic>,
            ),
          );
        },
      ),
    );
  }

  @override
  Map<String, dynamic> toJson(
    Map<ThumbsPlaylistType, ThumbsPlaylistDetailsModel> object,
  ) {
    return Map.fromEntries(
      List.generate(
        object.length,
        (index) {
          final playlistEntry = object.entries.elementAt(index);
          return MapEntry(
            playlistEntry.key.name,
            playlistEntry.value.toJson(),
          );
        },
      ),
    );
  }
}
