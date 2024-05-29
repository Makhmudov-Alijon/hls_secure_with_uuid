import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ThumbsConverter
    extends JsonConverter<List<ThumbsPlaylist>, Map<String, dynamic>> {
  const ThumbsConverter();

  @override
  List<ThumbsPlaylist> fromJson(Map<String, dynamic> json) {
    final playlists = <ThumbsPlaylist>[];

    for (final playlistType in ThumbsPlaylistType.values) {
      final playlist = json[playlistType.name] as String?;
      if (playlist != null) {
        playlists.add(
          ThumbsPlaylist(
            playlistType: playlistType,
            content: playlist,
          ),
        );
      }
    }

    return playlists;
  }

  @override
  Map<String, dynamic> toJson(List<ThumbsPlaylist> object) {
    throw UnimplementedError();
  }
}

enum ThumbsPlaylistType {
  medium,
  large;
}

class ThumbsPlaylist extends Equatable {
  const ThumbsPlaylist({
    required this.playlistType,
    required this.content,
  });

  final ThumbsPlaylistType playlistType;
  final String content;

  @override
  List<Object?> get props => [playlistType, content];
}
