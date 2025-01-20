import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import '../datas/datas.dart';

void download(DownloadFullTask full) {
  final key = DateTime.now().millisecondsSinceEpoch;
  bool cancel = false;
  final List<Completer<void>> completers = [];

  var count = 0;
  for (final task in full.tasks) {
    http
        .get(
      Uri.parse(
        task.url,
      ),
        )
        .timeout(const Duration(seconds: 35))
        .then(
      (response) async {
        if (response.statusCode == 200) {
          full.sendPort.send(
                DM.doneFor,
              );
              final file = File(task.absPath);

              // Open the file for writing
          final randomAccessFile = await file.open(mode: FileMode.write);

          // Write the downloaded bytes to the file
          await randomAccessFile.writeFrom(response.bodyBytes);

          // Close the file
          await randomAccessFile.close();

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

