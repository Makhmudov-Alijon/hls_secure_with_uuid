import 'dart:developer';

import 'package:download_manager/download_manager.dart';

class AudioSegmentPlaylistModel {
  const AudioSegmentPlaylistModel({
    required this.segments,
    required this.totalDuration,
    required this.audioTrack,
    required HlsPlaylistData playlistData,
    required HlsLinkSwapper linkSwapper,
    required HlsLinkSwapper keySwapper,
    this.encKey,
  })  : _playlistData = playlistData,
        _linkSwapper = linkSwapper,
        _keySwapper = keySwapper;

  factory AudioSegmentPlaylistModel.parse({
    required String playlist,
    required HlsPathManager pathManager,
    required HlsAudioTrack audioTrack,
  }) {
    final parsedPlaylist = HlsParser(playlist: playlist).parseData();
    final segments = <HlsSegment>[];
    final linkSwapper = HlsLinkSwapper(useAbsolute: false);
    final keySwapper = HlsLinkSwapper(useAbsolute: false);

    final baseDir = pathManager.audioDir(audioTrack: audioTrack);
    final encKey = parsedPlaylist.encKey;
    if (encKey != null) {
      keySwapper.addLinkFromFile(
        originalLink: encKey.url,
        file: pathManager.encKeyFile,
        baseDir: baseDir,
      );
    }
    var totalDuration = 0.0;
    for (final item in parsedPlaylist.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        final duration = double.parse(
          item.hlsValueParameters[HlsParamConstants.empty]!.value,
        );
        final url = item.url!;
        log('audio url: $url');
        totalDuration += duration;
        final saveFile = pathManager.fileFromAudio(
          url: item.url!,
          audioTrack: audioTrack,
        );
        linkSwapper.addLinkFromUrl(
          url: url,
          saveFile: saveFile,
          baseDir: baseDir,
        );
        segments.add(
          HlsSegment(
            link: url,
            isVideo: true,
            duration: duration,
            saveFile: saveFile,
          ),
        );
      }
    }

    return AudioSegmentPlaylistModel(
      segments: segments,
      totalDuration: totalDuration,
      audioTrack: audioTrack,
      linkSwapper: linkSwapper,
      playlistData: parsedPlaylist,
      encKey: encKey,
      keySwapper: keySwapper,
    );
  }

  String toLocalPlaylist({required bool isForWatching}) {
    return _playlistData.toLocalPlaylist(
      linkSwapperGroup: HlsLinkSwapperGroup(
        swappers: [
          if (!isForWatching) _linkSwapper,
          _keySwapper,
        ],
      ),
    );
  }

  final HlsAudioTrack audioTrack;
  final List<HlsSegment> segments;
  final double totalDuration;
  final HlsLinkSwapper _linkSwapper;
  final HlsLinkSwapper _keySwapper;
  final HlsPlaylistData _playlistData;
  final HlsEncryptionKey? encKey;
}
