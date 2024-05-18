import 'dart:io';

import 'package:equatable/equatable.dart';

class HlsWatchLink extends Equatable {
  const HlsWatchLink({
    required this.master,
  });

  final File master;

  void close() {
    master.deleteSync(recursive: true);
  }

  @override
  List<Object?> get props => [master];
}
