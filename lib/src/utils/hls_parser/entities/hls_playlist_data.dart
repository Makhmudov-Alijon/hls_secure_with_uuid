import 'package:download_manager/src/models/master_playlist_model/hls_enctyption_key.dart';
import 'package:download_manager/src/utils/hls_parser/entities/hls_link_swapper.dart';

import '../../../../download_manager.dart';
import 'hls_playlist_item.dart';
import 'hls_playlist_type.dart';

class HlsPlaylistData {
  const HlsPlaylistData({
    required this.playlistItems,
    required this.playlistType,
    this.encKey,
  });

  final List<HlsPlaylistItem> playlistItems;
  final HlsPlaylistType playlistType;
  final HlsEncryptionKey? encKey;

  @override
  String toString() {
    return playlistItems.map((e) => e.toString()).join('\r\n');
  }

  String toLocalPlaylist({
    HlsLinkSwapper? linkSwapper,
  }) {
    if (linkSwapper == null || linkSwapper.isEmpty) {
      return toString();
    }

    final strings = <String>[];

    for (var item in playlistItems) {
      final uri = item.hlsValueParameters[HlsParamConstants.uri];
      if (uri != null) {
        final swapperLink = linkSwapper[uri.value.escapeQuotes];
        if (swapperLink != null) {
          item = item.copyWith(
            hlsValueParameters: {
              ...item.hlsValueParameters,
              HlsParamConstants.uri: HlsParamValue(
                value: swapperLink.inQuotes,
              ),
            },
          );
        }
      }

      if (item.url != null) {
        final swapperLink = linkSwapper[item.url!];
        if (swapperLink != null) {
          item = item.copyWith(
            url: swapperLink,
          );
        }
      }

      strings.add(item.toString());
    }
    return strings.join('\n');
  }
}
