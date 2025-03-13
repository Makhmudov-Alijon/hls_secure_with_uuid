// ignore_for_file: avoid_unused_constructor_parameters

import 'package:download_manager/src/models/thumbs_parsed_playlist_model/vtt_duration.dart';
import 'package:download_manager/src/models/thumbs_parsed_playlist_model/vtt_image.dart';
import 'package:download_manager/src/models/thumbs_playlist_details_model/thumbs_playlist_details_model.dart';
import 'package:equatable/equatable.dart';

class ThumbsParsedPlaylistModel extends Equatable {

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
  const ThumbsParsedPlaylistModel({required this.data});

  factory ThumbsParsedPlaylistModel._parse({
    required String playlistString,
    required String? playlistBaseUrl,
    required String? baseUrl,
  }) {
    final playlistStrLines = playlistString.split('\n');
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
          tempImage = baseUrl != null && playlistBaseUrl != null
              ? VTTImage.fromStringWithRelativeUrl(
                  string: line,
                  playlistBaseUrl: playlistBaseUrl,
                  baseUrl: baseUrl,
                )
              : VTTImage.fromString(
                  string: line,
                );
          data[tempRange] = tempImage;
          tempRange = null;
          tempImage = null;
        }
      }
    }
    return ThumbsParsedPlaylistModel(data: data);
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

  final Map<VTTDurationRange, VTTImage> data;

  @override
  List<Object?> get props => [data];
}
