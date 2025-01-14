import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

void downloadFull(DownloadFullTask full) {
  var count = 0;
  for (final task in full.tasks.indexed) {
    http
        .get(
      Uri.parse(
        task.$2.$1,
      ),
      )
        .then(
      (response) async {
        if (response.statusCode == 200) {
          full.sendPort.send(
            DownloadFullHintEnum.doneFor.index,
          );
          final file = File(task.$2.$2);

          // Open the file for writing
          final randomAccessFile = await file.open(mode: FileMode.write);

          // Write the downloaded bytes to the file
          await randomAccessFile.writeFrom(response.bodyBytes);

          // Close the file
          await randomAccessFile.close();

          // print('>< >< done for : $count <> ${task.$1}');
        } else {
          print(
            '>< >< fail for else : $count <> ${task.$1} Exception: ${response.body}',
          );
          full.sendPort.send(
            DownloadFullHintEnum.failFor.index,
          );
        }
      },
    ).onError(
      (error, v) {
        print(
          '>< >< fail for catch : $count <> ${task.$1} Exception: ${error.toString()}',
        );
        full.sendPort.send(
          DownloadFullHintEnum.failFor.index,
        );
      },
    ).whenComplete(() {
      count++;
      print('>< >< when complete : ${count}');
      if (count >= full.tasks.length) {
        full.sendPort.send(
          DownloadFullHintEnum.doneFull.index,
        );
      }
    });
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
