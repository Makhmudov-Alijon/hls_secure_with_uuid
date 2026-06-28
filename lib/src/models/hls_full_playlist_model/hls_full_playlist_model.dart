import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';

class HlsFullPlaylistModel {
  HlsFullPlaylistModel({
    required this.master,
    required this.videoPlaylists,
    required this.audioPlaylists,
    required this.masterLinkExcluder,
  });

  final MasterPlaylistModel master;
  final List<VideoSegmentPlaylistModel> videoPlaylists;
  final List<AudioSegmentPlaylistModel> audioPlaylists;
  final HlsLinkExcluder masterLinkExcluder;

  String get iv => videoPlaylists.first.iv;
  String get enc => videoPlaylists.first.encKey;
}
