import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/models/segment_playlist_model/audio_segment_playlist_model/audio_segment_playlist_model.dart';
import 'package:download_manager/src/models/segment_playlist_model/video_segment_playlist_model/video_segment_playlist_model.dart';
import 'package:download_manager/src/utils/hls_link_exlcluder/hls_link_excluder.dart';

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
}
