import 'package:download_manager/src/models/thumbs_parsed_playlist_model/vtt_duration.dart';
import 'package:download_manager/src/models/thumbs_parsed_playlist_model/vtt_image.dart';
import 'package:download_manager/src/models/thumbs_playlist_details_model/thumbs_playlist_details_model.dart';
import 'package:equatable/equatable.dart';

class ThumbsParsedPlaylistModel extends Equatable {
  const ThumbsParsedPlaylistModel({
    required this.data,
    required this.imagesPerRow,
    required this.rowsLength,
    required this.secondsImages,
    required this.spriteUrls,
  });

  factory ThumbsParsedPlaylistModel.fromPlaylistDetails({
    required ThumbsPlaylistDetailsModel details,
    required String baseUrl,
  }) {
    return ThumbsParsedPlaylistModel._parse(
      playlistString: details.data,
      playlistBaseUrl: details.baseUrl,
      baseUrl: baseUrl,
    );
  }

  factory ThumbsParsedPlaylistModel._parse({
    required String playlistString,
    required String? playlistBaseUrl,
    required String? baseUrl,
  }) {
    final playlistStrLines = playlistString.split('\n');
    VTTImage? tempImage;
    VTTDurationRange? tempRange;
    var imagesPerRow = 0;
    var rowsLength = 0;
    String? firstImageUrl;
    final secondsImages = <int, VTTImage>{};
    final data = <VTTDurationRange, VTTImage>{};
    final spriteUrls = <String>{};
    for (final line in playlistStrLines) {
      if (line.isEmpty) {
        continue;
      } else if (line == 'WEBVTT') {
        continue;
      } else {
        if (tempRange == null) {
          tempRange = VTTDurationRange.fromString(line);
        } else {
          tempImage = baseUrl != null && playlistBaseUrl != null
              ? VTTImage.fromStringWithRelativeUrl(
                  string: line,
                  playlistBaseUrl: playlistBaseUrl,
                  baseUrl: baseUrl,
                )
              : VTTImage.fromString(
                  string: line,
                );
          firstImageUrl ??= tempImage.imageUrl;

          if (firstImageUrl == tempImage.imageUrl) {
            final box = tempImage.box;
            if (box.y == 0) {
              imagesPerRow++;
            }
            if (box.x == 0) {
              rowsLength++;
            }
          }
          final startSeconds = tempRange.startDuration.duration.inSeconds;
          final endSeconds = tempRange.endDuration.duration.inSeconds;

          if (startSeconds < endSeconds) {
            for (var second = startSeconds; second < endSeconds; second++) {
              secondsImages[second] = tempImage;
            }
          }
          final spriteUrl = tempImage.imageUrl;
          if (!spriteUrls.contains(spriteUrl)) {
            spriteUrls.add(spriteUrl);
          }
          data[tempRange] = tempImage;
          tempRange = null;
          tempImage = null;
        }
      }
    }
    return ThumbsParsedPlaylistModel(
      data: data,
      spriteUrls: spriteUrls.toList(),
      secondsImages: secondsImages,
      imagesPerRow: imagesPerRow,
      rowsLength: rowsLength,
    );
  }

  factory ThumbsParsedPlaylistModel.parseString(String playlist) {
    return ThumbsParsedPlaylistModel._parse(
      playlistString: playlist,
      playlistBaseUrl: null,
      baseUrl: null,
    );
  }

  static ThumbsParsedPlaylistModel? tryParseString(String playlist) {
    try {
      return ThumbsParsedPlaylistModel.parseString(playlist);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    final stringBuffer = StringBuffer('WEBVTT');
    for (final entry in data.entries) {
      stringBuffer
        ..write('\n\n')
        ..write(entry.key.toString())
        ..write('\n')
        ..write(
          entry.value.toString(),
        );
    }
    return stringBuffer.toString();
  }

  VTTImage? thumbnailByPosition(Duration position) {
    return secondsImages[position.inSeconds];
  }

  final Map<VTTDurationRange, VTTImage> data;
  final Map<int, VTTImage> secondsImages;
  final List<String> spriteUrls;
  final int rowsLength;
  final int imagesPerRow;

  @override
  List<Object?> get props => [data, rowsLength, imagesPerRow];
}
