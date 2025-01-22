import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import '../datas/datas.dart';

Future<void> retryWithoutExiting3(DownloadFullTask2 full) async {
  // print('>< >< enter the isolate');
  const limit = 2000;
  var cancel = false;
  final mainReceivePort = ReceivePort();
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

    try {
      final response = await client.send(request).timeout(
            const Duration(
              seconds: 35,
            ),
          );
      // print('>< >< response : ${response.statusCode}');

      if (response.statusCode == 200) {
        if (!cancel) {
          final tempFile = File(task.tempFile);
          await tempFile.create(recursive: true);
          await response.stream.pipe(tempFile.openWrite());
          if (!cancel) {
            if (tempFile.existsSync()) {
              await tempFile.rename(task.filePath);
            }
          }
          return null;
        }
        return task;
      }
      return task;
    } catch (error) {
      // // print('>< >< on error : ${error.runtimeType}');
      // if (error is http.ClientException) {
      //   // print('>< >< message : ${error.message}');
      // } else if (error is PathAccessException) {
      //   // print('>< >< message : ${error.message}');
      //   // print('>< >< o m : ${error.osError?.message}');
      //   // print('>< >< o e c : ${error.osError?.errorCode}');
      // } else if (error is TimeoutException) {
      //   // print('>< >< t e message: ${error.message}  ');
      //   // print('>< >< t e duration: ${error.duration}  ');
      // } else if (error is FileSystemException) {
      //   // print('>< >< message : ${error.message}  ');
      //   // print('>< >< path : ${error.path}  ');
      //   // print('>< >< osError : ${error.osError?.message}  ');
      // } else {
      //   // print('>< >< error downloading : ${error.runtimeType}  ');
      // }
      return task;
    }
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
          full.sendPort.send(DM.doneFull);
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
