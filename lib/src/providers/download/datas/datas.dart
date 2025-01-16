import 'dart:isolate';

class DownloadFullTask {
  const DownloadFullTask({
    required this.tasks,
    required this.sendPort,
  });

  final List<TheTask> tasks;
  final SendPort sendPort;
}

class DM {
  const DM._();

  static const doneFull = 0;
  static const doneFor = 1;
  static const goBack = 2;
  static const gottenBack = 3;
}

typedef TheTask = ({String url, String absPath});
