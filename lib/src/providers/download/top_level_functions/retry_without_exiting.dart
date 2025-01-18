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
  Map<String, String> failedTasks = <String, String>{};
  Map<String, String> mission = full.tasks;

  final clients = <String, http.Client>{};
  var count = 0;
  Isolate? writeFileIsolate;
  SendPort? writeFileSendPortt;
  // late DateTime sendTime;

  Isolate.spawn(writeToFileTop, fileReceivePort.sendPort).then(
    (isolate) {
      writeFileIsolate = isolate;
      fileReceivePort.listen(
        (message) {
          if (message is int) {
            if (message == DM.gottenBack) {
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

              if (failedTasks.length + count == mission.length) {
                if (failedTasks.isEmpty) {
                  writeFileSendPortt?.send(DM.doneFull);
                } else {
                  // sendTime = DateTime.now();
                  full.sendPort.send(DM.error);
                }
              }
            }
          }

          if (message is SendPort) {
            writeFileSendPortt = message;

            full.sendPort.send(mainRecivePort.sendPort);

            /// ///////////////////////////
            ///        FUNC        ////////
            /// ///////////////////////////
            void func(Map<String, String> full) {
              for (final task in full.entries) {
                if (cancel) break;

                final client = http.Client();
                clients[task.absPath] = client;
                final uri = Uri.parse(task.url);
                final request = http.Request('GET', uri);

                Uint8List? content;

                client
                    .send(request)
                    .timeout(const Duration(seconds: 15))
                    .then(
                      (response) async {
                        if (cancel) return;

                        if (response.statusCode == 200) {
                          if (!cancel) {
                            content = await response.stream.toBytes();
                          }
                        }
                      },
                    )
                    .onError(
                      (error, stackTrace) {},
                    )
                    .whenComplete(
                      () {
                        clients.remove(task.absPath);
                        if (content != null) {
                          writeFileSendPortt?.send((task.absPath, content));
                        } else {
                          failedTasks[task.key] = task.value;
                        }
                      },
                    );
              }
            }

            mainRecivePort.listen(
              (v) {
                if (v == DM.error) {
                  count = 0;
                  mission = failedTasks;
                  failedTasks = {};

                  // print(
                  //     '>< >< spent time to check retry : ${DateTime.now().difference(sendTime).inMicroseconds} microseconds');
                  func(mission);
                }
                if (v == DM.goBack) {
                  writeFileSendPortt?.send(DM.goBack);

                  cancel = true;

                  for (final client in List<http.Client>.from(clients.values)) {
                    try {
                      client.close();
                    } catch (e) {
                      print('>< >< close client exception : $e');
                    }
                  }
                }
              },
            );

            func(mission);
          }
        },
      );
    },
  );
}
