import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

class HlsWatchLink extends Equatable {
  const HlsWatchLink({
    required this.master,
    this.mediumThumbnails,
    this.largeThumbnails,
  });

  factory HlsWatchLink.fromPathManager(HlsPathManager pathManager) {
    return HlsWatchLink(
      master: pathManager.masterFile,
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

  void close() {
    master.deleteSync(recursive: true);
  }

  @override
  List<Object?> get props => [master, mediumThumbnails, largeThumbnails];
}
