import 'dart:isolate';
import 'dart:typed_data';

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
  static const error = 4;
}

typedef TheTask = ({String url, String absPath});

class DownloadFullTask2 {
  const DownloadFullTask2({
    required this.tasks,
    required this.sendPort,
  });

  final Map<String, String> tasks;
  final SendPort sendPort;
}

extension MapEntryExtension on MapEntry<String, String> {
  String get url => key;

  String get absPath => value;
}

extension MapEntryExtensionUint8List on MapEntry<String, Uint8List> {
  (String, Uint8List) get getAsTask => (key, value);
}