// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/models/master_playlist_model/hls_enctyption_key.dart';
import 'package:download_manager/src/utils/extension/list_extension.dart';
import 'package:download_manager/src/utils/extension/string_extension.dart';

import 'entities/hls_playlist_data.dart';
import 'entities/hls_playlist_item.dart';
import 'entities/hls_playlist_type.dart';
import 'hls_constants.dart';

class HlsParser {
  const HlsParser({
    required this.playlist,
  });

  /// Playlist data that came in response
  final String playlist;

  HlsPlaylistData parseData(HlsPlaylistType playlistType) {
    final exp = RegExp(r'\r?\n');
    final playlistLines = playlist.split(exp);
    final playlistItems = <HlsPlaylistItem>[];
    HlsEncryptionKey? encKey;

    for (var i = 0; i < playlistLines.length; i++) {
      var line = playlistLines[i];
      if (line.endsWith(',')) {
        line = line.substring(0, line.length - 2);
      }

      final valueParameters = <HlsParam?, HlsParamValue>{};
      String lineKey;
      if (line.isEmpty) {
        continue;
      }
      if (line.startsWith('#')) {
        final temp = line.splitWithExclude(pattern: ':', excludePattern: '"');

        lineKey = temp.first;

        if (temp.length > 1) {
          final parametersLine = temp.last;
          final valueParametersStr = parametersLine.splitWithExclude(
            pattern: ',',
            excludePattern: '"',
          );
          for (final parameter in valueParametersStr) {
            final temp =
                parameter.splitWithExclude(pattern: '=', excludePattern: '"');

            if (temp.length == 1) {
              /// ONLY VALUE PARAMETER
              valueParameters[null] = HlsParamValue(value: temp.first);
            } else {
              /// NAMED PARAMETER WITH VALUE
              final key = HlsParam(parameter: temp.first);
              final value = HlsParamValue(value: temp.last);

              if (key == HlsParamConstants.uri &&
                  value.value.contains('enc.key')) {
                encKey = HlsEncryptionKey(url: value.value.escapeQuotes);
              }

              valueParameters[key] = value;
            }
          }
        }
        if (playlistLines.hasItem(i + 1) &&
            playlistLines[i + 1].startsWith('#')) {
          /// NO URL FOUND
          playlistItems.add(
            HlsPlaylistItem(
              hlsKey: HlsKey(key: lineKey),
              hlsValueParameters: valueParameters,
            ),
          );
        } else {
          /// URL FOUND
          final nextLine = playlistLines[i + 1];
          if (nextLine.isNotEmpty) {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: HlsKey(key: lineKey),
                hlsValueParameters: valueParameters,
                url: nextLine,
              ),
            );
          } else {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: HlsKey(key: lineKey),
                hlsValueParameters: valueParameters,
              ),
            );
          }
          i += 1;
        }
      }
    }

    return HlsPlaylistData(
      playlistItems: playlistItems,
      playlistType: playlistType,
      encKey: encKey,
    );
  }
}
