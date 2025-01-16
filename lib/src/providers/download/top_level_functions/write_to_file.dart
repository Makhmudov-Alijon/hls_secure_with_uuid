import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import '../datas/datas.dart';

/// **Isolate function to write bytes to file**

void writeToFileTop(SendPort sendPort) {
  Future<void> store({
    required String path,
    required Uint8List content,
  }) async {
    final file = File(path);
    final raf = await file.open(mode: FileMode.write);

    try {
      for (final v in content) {

              print('>< ><  $v');
        raf.writeByteSync(v);
      }
    } finally {
      await raf.close();
    }
  }

  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is (String, Uint8List)) {
      store(path: message.$1, content: message.$2).then((v) {
        print('>< >< store file done :  ');
        sendPort.send(DM.doneFor);
      });
    }
    if (message is int) {
      if (message == DM.goBack) {
        receivePort.close();
        sendPort.send(DM.gottenBack);
      }
    }
  });
}
