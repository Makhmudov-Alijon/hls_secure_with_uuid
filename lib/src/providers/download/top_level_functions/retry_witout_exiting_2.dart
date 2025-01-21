import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import '../datas/datas.dart';

Future<void> retryWithoutExiting2(DownloadFullTask2 full) async {
  print('>< >< enter the isolate');
  const limit = 200;
  var cancel = false;
  final mainRecivePort = ReceivePort();
  Map<String, String> failedTaskss = <String, String>{};

  final clients = <String, http.Client>{};

  int _retry = 0;
  bool canRetry() {
    _retry++;
    return _retry <= 3;
  }

  void func(
    List<MapEntry<String, String>> tasks, {
    required void Function(MapEntry<String, String>?) onDone,
    required String where,
  }) {
    print('>< >< start func  ');
    for (final task in tasks) {
      if (cancel) break;
      bool success = false;
      final client = http.Client();
      clients[task.absPath] = client;
      final uri = Uri.parse(task.url);
      final request = http.Request('GET', uri);

      client.send(request).timeout(const Duration(seconds: 15)).then(
        (response) async {
          print('>< >< response : ${response.statusCode}');
          if (cancel) return;

          if (response.statusCode == 200) {
            if (!cancel) {
              final tempFile = File(task.tempFile);
              await tempFile.create(recursive: true);
              await response.stream.pipe(tempFile.openWrite());
              if (!cancel) {
                if (tempFile.existsSync()) {
                  await tempFile.rename(task.absPath);
                  success = true;
                }
              }
            }
          }
        },
      ).onError(
        (error, stackTrace) {
          print('>< >< on error : ${error.runtimeType}');
          if (error is PathAccessException) {
            print('>< >< message : ${error.message}');
            print('>< >< o m : ${error.osError?.message}');
            print('>< >< o e c : ${error.osError?.errorCode}');
          } else if (error is TimeoutException) {
            // print('>< >< t e message: ${error.message}  ');
            // print('>< >< t e duration: ${error.duration}  ');
          } else if (error is FileSystemException) {
            print('>< >< message : ${error.message}  ');
            print('>< >< path : ${error.path}  ');
            print('>< >< osError : ${error.osError?.message}  ');
          } else {
            // print('>< >< error downloading : ${error.runtimeType}  ');
          }
        },
      ).whenComplete(
        () {
          clients.remove(task.absPath);
          if (success) {
            onDone(null);
          } else {
            onDone(task);
          }
        },
      );
    }
  }

  Future<void> baraban(Map<String, String> tasks) async {
    print('>< >< start baraban ');
    final entries = tasks.entries.toList();

    for (var i = 0; i < entries.length; i += limit) {
      if (cancel) {
        break;
      }
      int count = 0;
      final chunkCompleter = Completer<void>();
      final chunk = entries.sublist(
        i,
        (i + limit) > entries.length ? entries.length : i + limit,
      );

      func(
        chunk,
        onDone: (result) {
          count++;

          if (result == null) {
            full.sendPort.send(DM.doneFor);
          } else {
            failedTaskss[result.key] = result.value;
          }
          if (count == chunk.length) {
            chunkCompleter.complete();
          }
        },
        where: 'line 84',
      );
      await chunkCompleter.future;
    }
    if (cancel) {
      mainRecivePort.close();

      // print('>< >< go back from braban');
      full.sendPort.send(DM.goBack);
    }
    if (failedTaskss.isEmpty) {
      mainRecivePort.close();
      full.sendPort.send(DM.doneFull);
    } else {
      if (canRetry()) {
        final newMission = failedTaskss;
        failedTaskss = {};
        await baraban(newMission);
      } else {
        mainRecivePort.close();
        full.sendPort.send(DM.error);
      }
    }
  }

  full.sendPort.send(mainRecivePort.sendPort);

  unawaited(baraban(full.tasks));

  mainRecivePort.listen(
    (message) {
      // print('>< >< got message : ${message}');
      if (message == DM.goBack ||
          message == DM.waitForNetwork ||
          message == DM.error) {
        cancel = true;
        mainRecivePort.close();
        int c = 0;

        for (final client in List<http.Client>.from(clients.values)) {
          try {
            // print('>< >< close client : ${c++}');
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
