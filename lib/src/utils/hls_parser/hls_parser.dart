// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:download_manager/src/utils/extension/list_extension.dart';
import 'package:download_manager/src/utils/extension/string_extension.dart';

import '../../models/segment_playlist_model/hls_segment_playlist_key.dart';
import 'entities/hls_playlist_data.dart';
import 'entities/hls_playlist_item.dart';
import 'entities/hls_playlist_type.dart';
import 'hls_constants.dart';

class HlsParser {
  const HlsParser({
    required this.playlist,
    this.key,
    this.useAbsoluteLinks = true,
  });

  /// Playlist data that came in response
  final String playlist;

  /// Auth key
  final HlsSegmentsPlaylistKey? key;

  final bool useAbsoluteLinks;

  HlsPlaylistData parseData(HlsPlaylistType playlistType) {
    final playlistLines = playlist.split('\n');
    final playlistItems = <HlsPlaylistItem>[];
    String? iv;

    for (var i = 0; i < playlistLines.length; i++) {
      var line = playlistLines[i];
      if (line.endsWith(',')) {
        line = line.substring(0, line.length - 2);
      }

      final valueParameters = <HlsParam?, HlsParamValue>{};
      String key;
      if (line.isEmpty) {
        continue;
      }
      if (line.startsWith('#')) {
        final temp = line.splitWithExclude(pattern: ':', excludePattern: '"');
        key = temp.first;

        if (temp.length > 1) {
          final parametersLine = temp[1];
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
              var value = HlsParamValue(value: temp.last);

              if (key == HlsParamConstants.uri) {
                value = value.copyWith(
                  value: temp.last,
                );
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
              hlsKey: HlsKey(key: key),
              hlsValueParameters: valueParameters,
            ),
          );
        } else {
          /// URL FOUND
          final nextLine = playlistLines[i + 1];
          if (nextLine.isNotEmpty) {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: HlsKey(key: key),
                hlsValueParameters: valueParameters,
                url: nextLine,
              ),
            );
          } else {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: HlsKey(key: key),
                hlsValueParameters: valueParameters,
              ),
            );
          }
          i += 1;
        }
      }

      final ivValue = valueParameters[HlsParamConstants.iv];

      if (ivValue != null) {
        iv = ivValue.value;
      }
    }

    if (key != null) {
      for (var i = 0; i < playlistItems.length; i++) {
        final item = playlistItems[i];
        if (item.hlsKey == HlsKeyConstants.extInf) {
          if (i != 0) {
            playlistItems.insert(
              i,
              HlsPlaylistItem(
                hlsKey: HlsKeyConstants.extXKey,
                hlsValueParameters: {
                  HlsParamConstants.method: HlsParamValueConstants.aes128,
                  HlsParamConstants.uri:
                      HlsParamValue(value: '"${key!.encKeyUrl}"'),
                  if (iv != null)
                    HlsParamConstants.iv: HlsParamValue(
                      value: iv,
                    ),
                },
              ),
            );
            break;
          }
        }
      }
    }

    return HlsPlaylistData(
      playlistItems: playlistItems,
      playlistType: playlistType,
    );
  }
}
