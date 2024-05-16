import 'package:download_manager/src/models/master_playlist_model/hls_enctyption_key.dart';
import 'package:download_manager/src/utils/hls_link_swapper/hls_link_swapper_group.dart';

import '../../../../download_manager.dart';
import 'hls_playlist_item.dart';

class HlsPlaylistData {
  const HlsPlaylistData({
    required this.playlistItems,
    this.encKey,
  });

  final List<HlsPlaylistItem> playlistItems;
  final HlsEncryptionKey? encKey;

  @override
  String toString() {
    return playlistItems.map((e) => e.toString()).join('\r\n');
  }

  String toLocalPlaylist({
    required HlsLinkSwapperGroup linkSwapperGroup,
  }) {
    if (linkSwapperGroup.isEmpty) {
      return toString();
    }

    final strings = <String>[];

    for (var item in playlistItems) {
      final uri = item.hlsValueParameters[HlsParamConstants.uri];
      if (uri != null) {
        final swapperLink = linkSwapperGroup[uri.value.escapeQuotes];
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
        final swapperLink = linkSwapperGroup[item.url!];
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
