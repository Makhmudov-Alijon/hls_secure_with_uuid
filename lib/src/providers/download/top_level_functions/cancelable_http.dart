import 'dart:async';
import 'dart:isolate';

import 'package:download_manager/src/providers/download/top_level_functions/write_to_file.dart';
import 'package:http/http.dart' as http;

import '../datas/datas.dart';

void cancellableHttp(DownloadFullTask full) {
  var cancel = false;
  final receivePort = ReceivePort();
  final fileReceivePort = ReceivePort();

  final clients = <String, http.Client>{};
  var countt = 0;
  Isolate? writeFileIsolate;
  SendPort? writeFileSendPort;
  Isolate.spawn(writeToFileTop, fileReceivePort.sendPort).then(
    (v) {
      writeFileIsolate = v;
      fileReceivePort.listen(
        (message) {
          if (message is int) {
            if (message == DM.gottenBack) {
              print('>< >< write to file isolate gotten back : ');
            }
            if (message == DM.doneFor) {
              full.sendPort.send(message);
              countt++;

              if (countt >= full.tasks.length) {
                receivePort.close();
                full.sendPort.send(DM.doneFull);
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
                writeFileIsolate?.kill(priority: Isolate.immediate);
                // Cancel all ongoing requests
                for (final client in List<http.Client>.from(clients.values)) {
                  try {
                    client.close();
                  } catch (e) {
                    print('>< >< close client exception : ${e}');
                  }
                }

                receivePort.close();
                full.sendPort.send(DM.gottenBack);
              }
            });

            for (final task in full.tasks) {
              if (cancel) break;

              final client = http.Client();
              clients[task.absPath] = client;
              final uri = Uri.parse(task.url);
              final request = http.Request('GET', uri);

              client.send(request).timeout(const Duration(seconds: 15)).then(
                (response) async {
                  if (cancel) return;

                  if (response.statusCode == 200) {
                    if (!cancel) {
                      // Send bytes to another isolate for writing
                      // Isolate.spawn(writeFileIsolate, [task.absPath, bytes]);
                      final v = await response.stream.toBytes();
                      writeFileSendPort?.send((task.absPath, v));
                    }
                  }
                },
              ).onError(
                (error, stackTrace) {
                  print('>< >< Download error: $error');
                },
              ).whenComplete(
                () {
                  clients.remove(task.absPath);
                },
              );
            }
          }
        },
      );
    },
  );
}
