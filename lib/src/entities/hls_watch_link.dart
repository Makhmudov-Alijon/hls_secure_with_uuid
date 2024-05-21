import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

class HlsWatchLink extends Equatable {
  const HlsWatchLink({
    required this.master,
    required this.masterDir,
    this.mediumThumbnails,
    this.largeThumbnails,
  });

  factory HlsWatchLink.fromPathManager(HlsPathManager pathManager) {
    return HlsWatchLink(
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

  void close() {
    masterDir.deleteSync(recursive: true);
  }

  @override
  List<Object?> get props => [
        master,
        mediumThumbnails,
        largeThumbnails,
        masterDir,
      ];
}
