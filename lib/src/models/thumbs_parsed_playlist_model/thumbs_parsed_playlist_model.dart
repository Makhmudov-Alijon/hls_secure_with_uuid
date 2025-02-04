import 'package:download_manager/src/models/thumbs_parsed_playlist_model/vtt_duration.dart';
import 'package:download_manager/src/models/thumbs_parsed_playlist_model/vtt_image.dart';
import 'package:download_manager/src/models/thumbs_playlist_details_model/thumbs_playlist_details_model.dart';
import 'package:equatable/equatable.dart';

class ThumbsParsedPlaylistModel extends Equatable {
  const ThumbsParsedPlaylistModel({required this.data});

  factory ThumbsParsedPlaylistModel.fromPlaylistDetails({
    required ThumbsPlaylistDetailsModel details,
    required String baseUrl,
  }) {
    final playlistStrLines = details.data.split('\n');
    VTTImage? tempImage;
    VTTDurationRange? tempRange;
    final data = <VTTDurationRange, VTTImage>{};
    for (final line in playlistStrLines) {
      if (line.isEmpty) {
        continue;
      } else if (line == 'WEBVTT') {
        continue;
      } else {
        if (tempRange == null) {
          tempRange = VTTDurationRange.fromString(line);
        } else {
          tempImage = VTTImage.fromStringWithRelativeUrl(
            string: line,
            playlistBaseUrl: details.baseUrl,
            baseUrl: baseUrl,
          );
          data[tempRange] = tempImage;
          tempRange = null;
          tempImage = null;
        }
      }
    }
    return ThumbsParsedPlaylistModel(data: data);
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

  final Map<VTTDurationRange, VTTImage> data;

  @override
  List<Object?> get props => [data];
}
