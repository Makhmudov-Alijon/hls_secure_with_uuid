import 'dart:io';

import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';
import 'package:equatable/equatable.dart';

class HlsWatchLink extends Equatable {
  const HlsWatchLink({
    required this.master,
    required this.masterDir,
    required this.fullplaylist,
    this.mediumThumbnails,
    this.largeThumbnails,
  });

  factory HlsWatchLink.fromPathManager({
    required HlsPathManager pathManager,
    required HlsFullPlaylistModel fullPlaylist,
  }) {
    return HlsWatchLink(
      fullplaylist: fullPlaylist,
      master: pathManager.masterFile,
      masterDir: pathManager.masterDir,
      largeThumbnails: pathManager.largeThumbnailsFile.existsSync()
          ? pathManager.largeThumbnailsFile
          : null,
      mediumThumbnails: pathManager.mediaThumbnailsFile.existsSync()
          ? pathManager.mediaThumbnailsFile
          : null,
    );
  }

  final File master;
  final File? mediumThumbnails;
  final File? largeThumbnails;
  final Directory masterDir;
  final HlsFullPlaylistModel fullplaylist;

  void close() {
    masterDir.deleteSync(recursive: true);
  }

  @override
  List<Object?> get props => [
        master,
        mediumThumbnails,
        largeThumbnails,
        masterDir,
        fullplaylist,
      ];
}
