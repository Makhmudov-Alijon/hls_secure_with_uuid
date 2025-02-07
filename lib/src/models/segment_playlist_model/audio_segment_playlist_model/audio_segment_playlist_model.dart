import 'package:download_manager/download_manager.dart';

class AudioSegmentPlaylistModel {
  const AudioSegmentPlaylistModel({
    required this.segments,
    required this.iv,
    required this.encKey,
    required this.totalDuration,
    required this.audioTrack,
    required HlsPlaylistData playlistData,
    required HlsLinkSwapper linkSwapper,
    required HlsLinkSwapper keySwapper,
    required this.encKeyUrl,
  })  : _playlistData = playlistData,
        _linkSwapper = linkSwapper,
        _keySwapper = keySwapper;

  factory AudioSegmentPlaylistModel.parse({
    required String playlist,
    required HlsPathManager pathManager,
    required HlsAudioTrack audioTrack,
    required String encKey,
    required String? playlistBaseUrl,
    required String baseUrl,
    required String? token,
  }) {
    final parsedPlaylist = HlsParser(playlist: playlist).parseData(
      swapper: (link) {
        final updatedLink = playlistBaseUrl == null
            ? link
            : <String>[baseUrl, playlistBaseUrl, link].join('/');
        if (token != null) {
          return '$updatedLink?t=$token';
        }
        return updatedLink;
      },
    );
    final segments = <HlsSegment>[];
    final linkSwapper = HlsLinkSwapper(useAbsolute: false);
    final keySwapper = HlsLinkSwapper(useAbsolute: false);

    final baseDir = pathManager.audioDir(audioTrack: audioTrack);
    final encKeyUrl = parsedPlaylist.encKeyUrl;
    final iv = parsedPlaylist.iv;
    if (encKeyUrl == null) {
      throw UnimplementedError('encKey not found');
    } else if (iv == null) {
      throw UnimplementedError('iv not found');
    }
    keySwapper.addLinkFromFile(
      originalLink: encKeyUrl.url,
      file: pathManager.encKeyFile,
      baseDir: baseDir,
    );
    var totalDuration = 0.0;
    for (final item in parsedPlaylist.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        final duration = double.parse(
          item.hlsValueParameters[HlsParamConstants.empty]!.value,
        );
        final url = item.url!;
        print(url);
        totalDuration += duration;
        final saveFile = pathManager.fileFromAudio(
          url: url,
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
      encKey: encKey,
      iv: iv,
      segments: segments,
      totalDuration: totalDuration,
      audioTrack: audioTrack,
      linkSwapper: linkSwapper,
      playlistData: parsedPlaylist,
      encKeyUrl: encKeyUrl,
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
  final HlsEncryptionKey encKeyUrl;
  final String iv;
  final String encKey;
}
