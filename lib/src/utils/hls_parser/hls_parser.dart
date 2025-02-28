// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:download_manager/download_manager.dart';

class HlsParser {
  const HlsParser({
    required this.playlist,
  });

  /// Playlist data that came in response
  final String playlist;

  HlsPlaylistData parseData({
    String Function(String link)? swapper,
  }) {
    final exp = RegExp(r'\r?\n');
    final playlistLines = playlist.split(exp);
    final playlistItems = <HlsPlaylistItem>[];
    HlsEncryptionKey? encKey;
    String? iv;

    HlsKey? hlsKey;
    var valueParameters = <HlsParam?, HlsParamValue>{};

    for (var line in playlistLines) {
      if (line.endsWith(',')) {
        line = line.substring(0, line.length - 2);
      }

      if (line.isEmpty) {
        continue;
      } else {
        if (line.startsWith('#')) {
          if (hlsKey != null) {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: hlsKey,
                hlsValueParameters: {...valueParameters},
              ),
            );
            valueParameters = {};
            hlsKey = null;
          }

          final temp = line.splitWithExclude(pattern: ':', excludePattern: '"');

          hlsKey = HlsKey(key: temp.first);

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
                if (key == HlsParamConstants.iv) {
                  iv = value.value;
                }

                valueParameters[key] = value;
              }
            }
          }
        } else {
          if (hlsKey != null) {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: hlsKey,
                hlsValueParameters: {...valueParameters},
                url: swapper?.call(line) ?? line,
              ),
            );
            hlsKey = null;
            valueParameters = {};
          }
        }
      }
    }

    if (hlsKey != null) {
      playlistItems.add(
        HlsPlaylistItem(
          hlsKey: hlsKey,
          hlsValueParameters: {...valueParameters},
        ),
      );
    }

    return HlsPlaylistData(
      playlistItems: playlistItems,
      encKeyUrl: encKey,
      iv: iv,
    );
  }
}
