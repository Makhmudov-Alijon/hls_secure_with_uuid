import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import '../datas/datas.dart';

/// **Isolate function to write bytes to file**

void writeToFileTop(SendPort sendPort) {
  const limit = 100;
  int processCount = 0;
  Map<String, Uint8List> buffer = {};

  Future<bool> storee((String, Uint8List) task) async {
    final file = File(task.$1);
    try {
      await file.parent.create(recursive: true);
      await file.writeAsBytes(task.$2, flush: true, mode: FileMode.writeOnly);
      return true;
    } catch (e) {
      print('<>< ><> write to file exception : $e');

      return false;
    }
  }

  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  void receiveTask((String, Uint8List) task) {
    if (limit > processCount) {
      processCount++;
      storee(task).then((v) {
        sendPort.send(v ? DM.doneFor : task);
        processCount--;
        if (buffer.isNotEmpty) {
          final nextTask = buffer.entries.first;
          buffer.remove(nextTask.key);
          receiveTask(nextTask.getAsTask);
        }
      });
    } else {
      buffer[task.$1] = task.$2;
    }
  }

  receivePort.listen((message) {
    if (message is (String, Uint8List)) {
      receiveTask(message);
    }

    if (message is int) {
      if (message == DM.goBack ||
          message == DM.goBackWithError ||
          message == DM.waitForNetwork) {
        buffer = {};
        receivePort.close();
        sendPort.send(
          message == DM.goBack
              ? DM.gottenBack
              : (
                  message == DM.goBackWithError
                      ? DM.gottenBackWithError
                      : DM.waitForNetwork,
                ),
        );
      }
      if (message == DM.doneFull) {
        buffer = {};
        receivePort.close();
        sendPort.send(DM.doneFull);
      }
    }
  });
}
