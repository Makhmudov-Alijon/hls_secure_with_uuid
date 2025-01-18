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

  Future<void> store((String, Uint8List) task) async {
    final start = DateTime.now();
    final file = File(task.$1);
    try {
      await file.parent.create(recursive: true);
      await file.writeAsBytes(task.$2, flush: true);
    } catch (e) {
      print('>< >< write to file exception : $e');
      buffer[task.$1] = task.$2;
    }

    return;
  }

  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  void closeFile() {
    // raf?.close();
  }

  void receiveTask((String, Uint8List) task) {
    if (limit > processCount) {
      processCount++;
      store(task).then((v) {
        sendPort.send(DM.doneFor);
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
      // print('>< >< buffer length: ${buffer.length} : ${processCount}');

      receiveTask(message);
    }

    if (message is int) {
      if (message == DM.goBack) {
        // print(
        //     '>< >< buffer length go back: ${buffer.length} : ${processCount}');

        closeFile();
        buffer = {};
        receivePort.close();
        sendPort.send(DM.gottenBack);
      }
      if (message == DM.doneFull) {
        closeFile();
        buffer = {};
        receivePort.close();
        sendPort.send(DM.doneFull);
      }
    }
  });
}
