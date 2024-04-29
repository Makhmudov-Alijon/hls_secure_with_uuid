// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:download_manager/src/utils/extension/list_extension.dart';
import 'package:download_manager/src/utils/extension/string_extension.dart';
import 'package:equatable/equatable.dart';

import '../../models/master_playlist_model/hls_resolution.dart';
import '../../models/segment_playlist_model/hls_segment_playlist_key.dart';
import 'hls_constants.dart';
import 'hls_path_manager.dart';
import 'hls_utils.dart';

class HlsKey extends Equatable {
  const HlsKey({required this.key});
  final String key;

  @override
  String toString() {
    return key;
  }

  @override
  List<Object?> get props => [key];
}

class HlsParamValue extends Equatable {
  const HlsParamValue({required this.value});
  final String value;

  @override
  String toString() {
    return value;
  }

  HlsParamValue copyWith({
    String? value,
  }) {
    return HlsParamValue(
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [value];
}

class HlsParam extends Equatable {
  const HlsParam({required this.parameter});
  final String parameter;

  @override
  String toString() {
    return parameter;
  }

  HlsParam copyWith({
    String? parameter,
  }) {
    return HlsParam(
      parameter: parameter ?? this.parameter,
    );
  }

  @override
  List<Object?> get props => [parameter];
}

class HlsPlaylistItem {
  const HlsPlaylistItem({
    required this.hlsKey,
    required this.hlsValueParameters,
    this.url,
  });

  final HlsKey hlsKey;
  final Map<HlsParam?, HlsParamValue> hlsValueParameters;
  final String? url;

  bool containsParam({required HlsParam param, HlsParamValue? paramValue}) {
    if (paramValue == null) {
      return hlsValueParameters.keys.contains(param);
    }
    return hlsValueParameters[param] == paramValue;
  }

  HlsPlaylistItem copyWith({
    HlsKey? hlsKey,
    Map<HlsParam?, HlsParamValue>? hlsValueParameters,
    String? url,
  }) {
    return HlsPlaylistItem(
      hlsKey: hlsKey ?? this.hlsKey,
      hlsValueParameters: hlsValueParameters ?? this.hlsValueParameters,
      url: url ?? this.url,
    );
  }

  @override
  String toString() {
    if (hlsValueParameters.isEmpty) {
      if (url == null) {
        return '$hlsKey';
      } else {
        return '$hlsKey\r\n$url';
      }
    } else {
      final valuePairs = <String>[];

      for (var entry in hlsValueParameters.entries) {
        final temp = entry.key == null
            ? entry.value.toString()
            : '${entry.key}=${entry.value}';
        valuePairs.add(temp);
      }

      final temp =
          '$hlsKey:${valuePairs.join(', ')}${hlsKey == HlsKeyConstants.extInf ? ',' : ''}';
      if (url == null) {
        return temp;
      } else {
        return '$temp\r\n$url';
      }
    }
  }
}

enum HlsPlaylistType {
  videoSegmentPlaylist,
  audioSegmentPlaylist,
  masterPlaylist;
}

class HlsPlaylistData {
  const HlsPlaylistData({
    required this.playlistItems,
    required this.playlistUrl,
    required this.playlistType,
  });

  final List<HlsPlaylistItem> playlistItems;
  final HlsPlaylistType playlistType;
  final String playlistUrl;

  @override
  String toString() {
    return playlistItems.map((e) => e.toString()).join('\r\n');
  }

  Future<String> toLocalPlaylist({
    required HlsPathManager pathManager,
    bool ignoreSegments = false,
    bool ignoreOtherResolutions = true,
  }) async {
    final strings = <String>[];

    for (var item in playlistItems) {
      final url = item.url;
      switch (playlistType) {
        case HlsPlaylistType.masterPlaylist:
          if (url != null) {
            if (item.containsParam(param: HlsParamConstants.resolution)) {
              if (!url.contains(pathManager.resolutionType.title) &&
                  ignoreOtherResolutions) {
                continue;
              } else {
                item = item.copyWith(
                  url: pathManager
                      .videoFileFrom(
                        url,
                        HlsResolutionType.v1080p.fromString(url),
                      )
                      .playlistPath,
                );
              }
            }
          }

          if (item.containsParam(
              param: HlsParamConstants.type,
              paramValue: HlsParamValueConstants.audio)) {
            item = item.copyWith(
              hlsValueParameters: {
                ...item.hlsValueParameters,
                HlsParamConstants.uri: HlsParamValue(
                  value: pathManager
                      .audioFileFrom(
                          item.hlsValueParameters[HlsParamConstants.uri]!.value)
                      .playlistPath
                      .inQuotes,
                ),
              },
            );
          }
          break;
        case HlsPlaylistType.audioSegmentPlaylist:
          if (ignoreSegments) break;

          if (url != null) {
            item = item.copyWith(
              url: pathManager.audioFileFrom(url).playlistPath,
            );
          }

          if (item.containsParam(param: HlsParamConstants.method) &&
              item.containsParam(param: HlsParamConstants.uri)) {
            item = item.copyWith(
              hlsValueParameters: {
                ...item.hlsValueParameters,
                HlsParamConstants.uri: HlsParamValue(
                  value: pathManager
                      .masterFileFrom(
                          item.hlsValueParameters[HlsParamConstants.uri]!.value)
                      .playlistPath,
                ),
              },
            );
          }
          break;
        case HlsPlaylistType.videoSegmentPlaylist:
          if (ignoreSegments) break;

          if (url != null) {
            item = item.copyWith(
              url: pathManager.videoFileFrom(url).playlistPath,
            );
          }

          if (item.containsParam(param: HlsParamConstants.method) &&
              item.containsParam(param: HlsParamConstants.uri)) {
            item = item.copyWith(
              hlsValueParameters: {
                ...item.hlsValueParameters,
                HlsParamConstants.uri: HlsParamValue(
                  value: pathManager
                      .masterFileFrom(
                          item.hlsValueParameters[HlsParamConstants.uri]!.value)
                      .playlistPath,
                ),
              },
            );
          }
          break;
      }
      strings.add(item.toString());
    }
    return strings.join('\n');
  }
}

class HlsParser {
  const HlsParser({
    required this.playlist,
    required this.playlistUrl,
    this.key,
  });

  // Playlist data that came in response
  final String playlist;
  // URL form where the playlist was requested
  final String playlistUrl;

  final HlsSegmentsPlaylistKey? key;

  HlsPlaylistData parseData(HlsPlaylistType playlistType) {
    final playlistLines = playlist.split('\n');
    final playlistItems = <HlsPlaylistItem>[];
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
      if (line.startsWith("#")) {
        final temp = line.splitWithExclude(pattern: ':', excludePattern: '"');
        key = temp.first;

        if (temp.length > 1) {
          final parametersLine = temp[1];
          final valueParametersStr = parametersLine.splitWithExclude(
              pattern: ',', excludePattern: '"');
          for (var parameter in valueParametersStr) {
            final temp =
                parameter.splitWithExclude(pattern: '=', excludePattern: '"');

            if (temp.length == 1) {
              /// ONLY VALUE PARAMETER
              valueParameters[null] = HlsParamValue(value: temp.first);
            } else {
              /// NAMED PARAMETER WITH VALUE
              var key = HlsParam(parameter: temp.first);
              var value = HlsParamValue(value: temp.last);

              if (key == HlsParamConstants.uri) {
                value = value.copyWith(
                  value:
                      HlsUtils.checkLinks(temp.last.escapeQuotes, playlistUrl)
                          .inQuotes,
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
          if (playlistLines[i + 1].isNotEmpty) {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: HlsKey(key: key),
                hlsValueParameters: valueParameters,
                url: HlsUtils.checkLinks(playlistLines[i + 1], playlistUrl),
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
                  HlsParamConstants.iv:
                      HlsParamValue(value: HlsUtils.asciiToHex(key!.salt)),
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
      playlistUrl: playlistUrl,
      playlistType: playlistType,
    );
  }
}
