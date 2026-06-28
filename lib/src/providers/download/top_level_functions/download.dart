import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:hls_secure_with_uuid/src/entities/local_hls_state.dart';
import 'package:hls_secure_with_uuid/src/utils/extension/int_extension.dart';
import 'package:http/http.dart' as http;

import '../datas/datas.dart';

Future<void> downloadWithDioAndWatchTheProgress(DownloadFullTask2 full) async {
  const limit = 10;
  var cancel = false;
  final mainReceivePort = ReceivePort();
  int downloadedBytes = 0;
  Stopwatch? stopwatch = Stopwatch()..start();
  Timer? progressTimer;
  void progress(timer) {
    if (!cancel && stopwatch != null) {
      final elapsedTime = stopwatch!.elapsedMilliseconds / 1000;
      final speed = downloadedBytes.toMb / elapsedTime;

      full.sendPort.send((downloadedBytes, speed));
    } else {
      progressTimer?.cancel();
      progressTimer = null;
    }

  }

  progressTimer = Timer.periodic(
    const Duration(milliseconds: 1000),
    progress,
  );
  Map<String, String> failedTasks = <String, String>{};
  Map<String, String> missionn = full.tasks;
  int missionLength = full.tasks.length;

  final clients = <String, http.Client>{};
  void closeClients() {
    for (final client in List<http.Client>.from(clients.values)) {
      try {
         client.close();
      } catch (e) {
        // print('<>< ><> close client exception : $e');
      }
    }
  }

  void dispose() {
    cancel = true;
    mainReceivePort.close();
    stopwatch?.stop();
    stopwatch = null;
    closeClients();
  }

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

    final completer = Completer<MapEntry<String, String>?>();

    try {
      final response = await client.send(request).timeout(
            const Duration(
              seconds: 35,
            ),
          );

      try {
        final tempFile = File(task.tempFile);
        IOSink? sink;

        try {
          sink = tempFile.openWrite();
        } catch (e) {
          completer.complete(task);
        }
        response.stream.listen(
          (chunk) {
            sink?.add(chunk);
            downloadedBytes += chunk.length;
          },
          onDone: () async {
            await sink?.close();
            if (tempFile.existsSync()) {
              await tempFile.rename(task.filePath);
              completer.complete(null);
            }
          },
          onError: (e) async {
            await sink?.close();
            if (tempFile.existsSync()) {
               await tempFile.delete(recursive: true);
            }

            completer.complete(task);
          },
          cancelOnError: true,
        );
      } catch (e) {
        completer.complete(task);
      }
    } catch (error) {

      completer.complete(task);
    }
    final result = await completer.future;
    try {
      clients[task.key]?.close();
      clients.remove(task.key);
    } catch (e) {}


    return result;
  }

  void baraban() {
    final completer = Completer<void>();
    int count = 0;

    void processNextTask() {
      // Continue processing tasks while there are tasks and the limit is not exceeded

      if (cancel) {
        return;
      }

      if (missionn.isNotEmpty) {
        final task = missionn.entries.first;
        missionn.remove(task.key);

        // Execute the task
        func(task).then(
          (result) {
            count++; // Decrement process count when the task finishes

            // Handle task completion
            if (result == null) {
              full.sendPort.send(DM.doneFor);
            } else {
              failedTasks[result.key] = result.value;
            }

            // If all tasks are completed, mark the completer as done
            if (count == missionLength) {
              completer.complete();
            } else {
              processNextTask();
            }
          },
        );
      } else {
        return;
      }
    }
    // Start processing tasks
    for (var i = 0; i < limit; i++) {
      processNextTask();
    }

    // Handle completion
    completer.future.then(
      (v) {
        if (failedTasks.isEmpty) {
          dispose();
          full.sendPort.send((DM.doneFull, downloadedBytes));
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
      if (message == DM.goBack ||
          message == DM.waitForNetwork ||
          message == DM.deleted ||
          message == DM.doneFull) {
        dispose();

        full.sendPort.send(message);
      }
      if (message is LocalHlsState) {
        dispose();

        full.sendPort.send(message);
      }
    },
  );
}
