import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

void download(DownloadFullTask full) {
  final key = DateTime.now().millisecondsSinceEpoch;
  final List<Completer<void>> completers = [];

  var count = 0;
  for (final task in full.tasks.indexed) {
    final completer = Completer<void>();
    completers.add(completer);
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
                DownloadMassager.doneFor,
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
      (error, v) {
        if (!completer.isCompleted) completer.complete();
      },
    ).whenComplete(() {
      count++;

      if (!completer.isCompleted) completer.complete();
      print('>< >< when comple : ${completer.isCompleted}');

      // print('>< >< when complete : $count key: $key');
      if (count >= full.tasks.length) {
        full.sendPort.send(
          DownloadMassager.doneFull,
        );
          }
        });
    completer.future.catchError((_) {
      print('>< >< COMPLETER EXCEPTION : ${_}');
      // Cancel request logic if supported, or ignore
    });
  }
  // Wait for cancellation signal
  full.cancelSignal.stream.listen((_) {
    print('>< >< listen the consel signal : $_ ');
    // Complete all pending tasks to "cancel" them
    for (var completer in completers) {
      print('>< >< is completed : ${completer.isCompleted}');
      if (!completer.isCompleted)
        completer.completeError(Exception('Cancelled'));
    }
  });
}

class DownloadFullTask {
  const DownloadFullTask({
    required this.tasks,
    required this.sendPort,
    required this.cancelSignal,
  });

  final List<(String url, String absPath)> tasks;
  final SendPort sendPort;
  final StreamController<bool> cancelSignal;
}

class DownloadMassager {
  const DownloadMassager._();

  static const doneFor = 1;
  static const doneFull = 0;
}
