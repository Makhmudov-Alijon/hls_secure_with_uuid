import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

Future<void> downloadFull(DownloadFullTask full) async {
  print('>< >< length : ${full.tasks.length}');
  int count = 0;
  for (final task in full.tasks.indexed) {
    unawaited(
      http
          .get(
        Uri.parse(
          task.$2.$1,
          // 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      )
          .then(
        (response) async {
          count++;
          if (response.statusCode == 200) {
            final file = File(task.$2.$2);

            // Open the file for writing
            final randomAccessFile = await file.open(mode: FileMode.write);

            // Write the downloaded bytes to the file
            await randomAccessFile.writeFrom(response.bodyBytes);

            // Close the file
            await randomAccessFile.close();

            print('>< >< done for : $count <> ${task.$1}');
            full.sendPort.send(
              DownloadFullHintEnum.doneFor.index,
            );
          } else {
            print('>< >< fail for : $count <> ${task.$1}');
            full.sendPort.send(
              DownloadFullHintEnum.failFor.index,
            );
          }
          if (count >= full.tasks.length) {
            full.sendPort.send(
              DownloadFullHintEnum.doneFull.index,
            );
          }
        },
      ),
    );
  }
  full.sendPort.send(
    DownloadFullHintEnum.startingTaskCompleted.index,
  );
}

class DownloadFullTask {
  const DownloadFullTask({
    required this.tasks,
    required this.sendPort,
  });

  final List<(String url, String absPath)> tasks;
  final SendPort sendPort;
}
enum DownloadFullHintEnum {
  doneFor,
  doneFull,
  failFor,
  startingTaskCompleted,
}

extension DownloadFullHintEnumExtension on DownloadFullHintEnum {
  bool get isDoneFor => this == DownloadFullHintEnum.doneFor;

  bool get isDoneFull => this == DownloadFullHintEnum.doneFull;

  bool get isFailFor => this == DownloadFullHintEnum.failFor;

  bool get isStartingTaskCompleted =>
      this == DownloadFullHintEnum.startingTaskCompleted;
}