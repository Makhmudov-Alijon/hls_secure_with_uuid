import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

void download(DownloadFullTask full) {
  final key = DateTime.now().millisecondsSinceEpoch;
  final List<Completer<void>> completers = [];

  var count = 0;
  for (final task in full.tasks.indexed) {
    http
        .get(
      Uri.parse(
        task.$2.$1,
      ),
        )
        .timeout(const Duration(seconds: 35))
        .then(
      (response) async {
        if (response.statusCode == 200) {
          full.sendPort.send(
                DM.doneFor,
              );
              final file = File(task.$2.$2);

              // Open the file for writing
          final randomAccessFile = await file.open(mode: FileMode.write);

          // Write the downloaded bytes to the file
          await randomAccessFile.writeFrom(response.bodyBytes);

          // Close the file
          await randomAccessFile.close();

          // print('>< >< done for : $count <> ${task.$1}');
        }
      },
    ).onError(
          (error, v) {},
        )
        .whenComplete(() {
          count++;

          // print('>< >< when complete : $count key: $key');
      if (count >= full.tasks.length) {
        full.sendPort.send(
              DM.doneFull,
            );
          }
        });
  }
}

class DownloadFullTask {
  const DownloadFullTask({
    required this.tasks,
    required this.sendPort,
  });

  final List<(String url, String absPath)> tasks;
  final SendPort sendPort;
}

class DM {
  const DM._();

  static const doneFull = 0;
  static const doneFor = 1;
  static const goBack = 2;
  static const gottenBack = 3;
}
