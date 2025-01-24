import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:download_manager/src/utils/extension/int_extension.dart';
import 'package:http/http.dart' as http;

import '../datas/datas.dart';

Future<void> downloadWithDioAndWatchTheProgress(DownloadFullTask2 full) async {
  // print('>< >< enter the isolate');
  const limit = 10;
  var cancel = false;
  final mainReceivePort = ReceivePort();
  int downloadedBytes = 0;
  final stopwatch = Stopwatch()..start();
  Timer? progressTimer;
  void progress(timer) {
    if (!cancel) {
      final elapsedTime = stopwatch.elapsedMilliseconds / 1000;
      final speed = downloadedBytes.toMb / elapsedTime;

      full.sendPort.send((downloadedBytes, speed));
    } else {
      progressTimer?.cancel();
      progressTimer = null;
    }
  }

  progressTimer = Timer.periodic(
    const Duration(milliseconds: 300),
    progress,
  );
  Map<String, String> failedTasks = <String, String>{};
  Map<String, String> missionn = full.tasks;
  int missionLength = full.tasks.length;

  final clients = <String, http.Client>{};

  int _retry = 0;
  bool canRetry() {
    _retry++;
    return _retry <= 3;
  }

  Future<MapEntry<String, String>?> func(MapEntry<String, String> task) async {
    final client = http.Client();
    clients[task.filePath] = client;
    final uri = Uri.parse(task.url);
    final request = http.Request('GET', uri);

    final idf = task.url.split('/').last;

    Completer<MapEntry<String, String>?> completer =
        Completer<MapEntry<String, String>?>();

    try {
      final response = await client.send(request).timeout(
            const Duration(
              seconds: 35,
            ),
          );

      final tempFile = File(task.tempFile);
      final sink = tempFile.openWrite();
      response.stream.listen(
        (chunk) {
          sink.add(chunk);
          downloadedBytes += chunk.length;
        },
        onDone: () async {
          await sink.close();
          if (tempFile.existsSync()) {
            await tempFile.rename(task.filePath);
            completer.complete(null);
          }
        },
        onError: (e) async {
          await sink.close();
          if (tempFile.existsSync()) {
            // print('>< >< delete uncompleted file : $idf');
            await tempFile.delete();
          }
          // print('>< >< on error : $idf   ');

          completer.complete(task);
        },
        cancelOnError: true,
      );
    } catch (error) {
      // if (error is SocketException) {
      //   print('>< >< message: ${error.message}');
      //   print('>< >< address: ${error.address}');
      //   print('>< >< osError: ${error.osError}');
      //   print('>< >< port: ${error.port}');
      // }
      // print('>< >< on error : ${error.runtimeType}');

      completer.complete(task);
    }
    final result = await completer.future;

    // if (result != null) {
    //   print('>< >< complete for : $idf result: $result');
    // }
    return result;
  }

  void baraban() {
    final completer = Completer<void>();
    int processCount = 0;
    int count = 0;

    void processNextTask() {
      // Continue processing tasks while there are tasks and the limit is not exceeded
      while (missionn.isNotEmpty && processCount < limit) {
        if (cancel) {
          break;
        }
        processCount++;

        final task = missionn.entries.first;
        missionn.remove(task.key);

        // Execute the task
        func(task).then(
          (result) {
            count++;
            processCount--; // Decrement process count when the task finishes

            // Handle task completion
            if (result == null) {
              full.sendPort.send(DM.doneFor);
            } else {
              failedTasks[result.key] = result.value;
            }

            // print(
            //   '>< >< comp cond : ${count == missionLength} count: $count, length: ${missionLength}',
            // );

            // If all tasks are completed, mark the completer as done
            if (count == missionLength) {
              completer.complete();
            } else {
              // Recursively process the next task

              // print(
              //     '>< >< recursion mission length: ${missionn.length} procces count ${processCount} ');
              processNextTask();
            }
          },
        );
      }
    }

    // Start processing tasks
    processNextTask();

    // Handle completion
    completer.future.then(
      (v) {
        // print('>< >< failed tasks : ${failedTasks.length}');
        if (failedTasks.isEmpty) {
          mainReceivePort.close();
          Future.delayed(Duration(milliseconds: 300), () {
            full.sendPort.send((DM.doneFull, downloadedBytes));
          });
        } else {
          if (canRetry()) {
            missionn = failedTasks;
            failedTasks = {};
            missionLength = missionn.length;
            baraban();
          } else {
            mainReceivePort.close();
            full.sendPort.send(DM.error);
          }
        }
      },
    );
  }

  full.sendPort.send(mainReceivePort.sendPort);

  baraban();

  mainReceivePort.listen(
    (message) {
      // print('>< >< got message : ${message}');
      if (message == DM.goBack ||
          message == DM.waitForNetwork ||
          message == DM.error) {
        cancel = true;
        mainReceivePort.close();
        int c = 0;

        for (final client in List<http.Client>.from(clients.values)) {
          try {
            client.close();
          } catch (e) {
            // print('<>< ><> close client exception : $e');
          }
        }

        // print('>< >< length : ${clients.length}');
        full.sendPort.send(message);
      }
    },
  );
}
