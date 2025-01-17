import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:download_manager/src/providers/download/top_level_functions/write_to_file.dart';
import 'package:http/http.dart' as http;

import '../datas/datas.dart';

void cancellableHttp(DownloadFullTask full) {
  var cancel = false;
  final receivePort = ReceivePort();
  final fileReceivePort = ReceivePort();

  final clients = <String, http.Client>{};
  var count = 0;
  var failedCount = 0;
  Isolate? writeFileIsolate;
  SendPort? writeFileSendPort;

  Isolate.spawn(writeToFileTop, fileReceivePort.sendPort).then(
    (isolate) {
      writeFileIsolate = isolate;
      fileReceivePort.listen(
        (message) {
          if (message is int) {
            if (message == DM.gottenBack || message == DM.doneFull) {
              print('>< >< write to file isolate $message: ');
              writeFileIsolate?.kill(priority: Isolate.immediate);
              receivePort.close();
              full.sendPort.send(message);
            }
            if (message == DM.doneFor) {
              full.sendPort.send(message);
              count++;

              if (failedCount + count == full.tasks.length) {
                writeFileSendPort?.send(DM.doneFull);
              }
            }
          }

          if (message is SendPort) {
            writeFileSendPort = message;

            full.sendPort.send(receivePort.sendPort);

            receivePort.listen((v) {
              if (v == DM.goBack) {
                writeFileSendPort?.send(DM.goBack);

                cancel = true;

                for (final client in List<http.Client>.from(clients.values)) {
                  try {
                    client.close();
                  } catch (e) {
                    print('>< >< close client exception : $e');
                  }
                }
              }
            });

            for (final task in full.tasks) {
              if (cancel) break;

              final client = http.Client();
              clients[task.absPath] = client;
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
                  )
                  .onError(
                    (error, stackTrace) {},
                  )
                  .whenComplete(
                    () {
                      clients.remove(task.absPath);
                      if (content != null) {
                        writeFileSendPort?.send((task.absPath, content));
                      } else {
                        failedCount++;
                      }
                      if (failedCount + count == full.tasks.length) {
                        writeFileSendPort?.send(DM.doneFull);
                      }
                    },
                  );
            }
          }
        },
      );
    },
  );
}
