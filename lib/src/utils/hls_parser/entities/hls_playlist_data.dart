import 'package:download_manager/src/models/master_playlist_model/hls_enctyption_key.dart';
import 'package:download_manager/src/utils/hls_link_exlcluder/hls_link_excluder.dart';
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
    HlsLinkExcluder? linkExcluder,
  }) {
    if (linkSwapperGroup.isEmpty) {
      return toString();
    }

    final strings = <String>[];

    for (var item in playlistItems) {
      final uri = item.hlsValueParameters[HlsParamConstants.uri];

      if (uri != null) {
        final link = uri.value.escapeQuotes;
        if (linkExcluder != null && linkExcluder.contains(link)) {
          continue;
        }
        final swapperLink = linkSwapperGroup[link];
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
        if (linkExcluder != null && linkExcluder.contains(item.url!)) {
          continue;
        }
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
