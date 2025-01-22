import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:download_manager/src/providers/download/top_level_functions/write_to_file.dart';
import 'package:http/http.dart' as http;

import '../datas/datas.dart';

void retryWithoutExiting(DownloadFullTask2 full) {
  var cancel = false;
  final mainRecivePort = ReceivePort();
  final fileReceivePort = ReceivePort();
  Map<String, String> failedTaskss = <String, String>{};
  Map<String, String> mission = full.tasks;

  final clients = <String, http.Client>{};
  var count = 0;
  Isolate? writeFileIsolate;
  SendPort? writeFileSendPortt;
  // late DateTime sendTime;

  void checkDoneFullOrError() {
    if (failedTaskss.length + count == mission.length) {
      if (failedTaskss.isEmpty) {
        writeFileSendPortt?.send(DM.doneFull);
      } else {
        // sendTime = DateTime.now();
        full.sendPort.send(DM.error);
      }
    }
  }

  void func(
    Map<String, String> tasks, {
    required String where,
  }) {
    for (final task in tasks.entries) {
      if (cancel) break;

      final client = http.Client();
      clients[task.filePath] = client;
      final uri = Uri.parse(task.url);
      final request = http.Request('GET', uri);

      Uint8List? content;

      client.send(request).timeout(const Duration(seconds: 15)).then(
        (response) async {
          if (cancel) return;

          if (response.statusCode == 200) {
            if (!cancel) {
              content = await response.stream.toBytes();
            }
          }
        },
      ).onError(
        (error, stackTrace) {
          const v = -1;
        },
      ).whenComplete(
        () {
          clients.remove(task.filePath);
          if (content != null) {
            writeFileSendPortt?.send((task.filePath, content));
          } else {
            failedTaskss[task.filePath] = task.url;
            checkDoneFullOrError();
          }
        },
      );
    }
  }

  Isolate.spawn(writeToFileTop, fileReceivePort.sendPort).then(
    (isolate) {
      writeFileIsolate = isolate;
      fileReceivePort.listen(
        (message) {
          if (message is (String, Uint8List)) {
            final url = mission[message.$1];

            if (url != null) {
              failedTaskss[message.$1] = url;
              checkDoneFullOrError();
            }
          }
          if (message is int) {
            if (message == DM.gottenBack ||
                message == DM.gottenBackWithError ||
                message == DM.waitForNetwork) {
              writeFileIsolate?.kill(priority: Isolate.immediate);
              mainRecivePort.close();
              full.sendPort.send(message);
            }
            if (message == DM.doneFull) {
              writeFileIsolate?.kill(priority: Isolate.immediate);
              mainRecivePort.close();
              full.sendPort.send(message);
            }
            if (message == DM.doneFor) {
              full.sendPort.send(message);
              count++;

              checkDoneFullOrError();
            }
          }

          if (message is SendPort) {
            writeFileSendPortt = message;

            full.sendPort.send(mainRecivePort.sendPort);



            mainRecivePort.listen(
              (message) {
                if (message == DM.error) {
                  count = 0;
                  mission = failedTaskss;
                  failedTaskss = {};
                  cancel = false;
                  func(mission, where: 'retry');
                }
                if (message == DM.goBack ||
                    message == DM.goBackWithError ||
                    message == DM.waitForNetwork) {
                  writeFileSendPortt?.send(message);

                  cancel = true;

                  for (final client in List<http.Client>.from(clients.values)) {
                    try {
                      client.close();
                    } catch (e) {
                      print('<>< ><> close client exception : $e');
                    }
                  }
                }
              },
            );

            func(mission, where: 'initial call');
          }
        },
      );

      /// ///////////////////////////
      ///        FUNC        ////////
      /// ///////////////////////////
    },
  );
}
