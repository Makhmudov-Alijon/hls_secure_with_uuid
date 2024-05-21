import 'dart:io';

import 'package:equatable/equatable.dart';


class HlsWatchLink extends Equatable {
  const HlsWatchLink({
    required this.master,
    required this.mediumThumbnails,
    required this.largeThumbnails,
  });

  final File master;
  final File mediumThumbnails;
  final File largeThumbnails;

  void close() {
    master.deleteSync(recursive: true);
  }

  @override
  List<Object?> get props => [master, mediumThumbnails, largeThumbnails];
}
