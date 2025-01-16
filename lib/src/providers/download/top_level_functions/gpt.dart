import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../datas/datas.dart';

bool breakFor = false;

void downloadDio(DownloadFullTask full) {
  var count = 0;
  bool breakFor = false;
  final receivePort = ReceivePort();
  full.sendPort.send(receivePort.sendPort);
  final dio = Dio();
  CancelToken cancelTokens = CancelToken();

  receivePort.listen(
    (message) {
      if (message is int) {
        if (message == DM.goBack) {
          breakFor = true;
          try {
            cancelTokens.cancel();

            print('>< >< token canceled');
          } catch (e) {
            print('>< >< cancel token exception : $e');
            // continue;
          }

          receivePort.close();
          Isolate.exit(full.sendPort, DM.gottenBack);
        }
      }
    },
  );

  for (final task in full.tasks) {
    if (breakFor) {
      break;
    }

    dio
        .get<dynamic>(
      task.url,
      options: Options(responseType: ResponseType.bytes),
      cancelToken: cancelTokens,
    )
        .then((response) async {
      if (response.data is Uint8List) {
        full.sendPort.send(DM.doneFor);
        final file = File(task.absPath);

        // Open the file for writing
        final randomAccessFile = await file.open(mode: FileMode.write);

        // Write the downloaded bytes to the file
        await randomAccessFile.writeFrom(response.data as Uint8List);

        // Close the file
        await randomAccessFile.close();
      } else {
        // print('>< >< rtt : ${response.data.runtimeType}');
      }
    }).catchError((error, c) {
      if (error is DioException) {
        if (CancelToken.isCancel(error)) {
          print('>< >< cancel token exception : ${error.message}');
        }
      }
    }).whenComplete(() {
      count++;
      if (count >= full.tasks.length) {
        receivePort.close();

        print('>< >< full done in isolate ');
        Isolate.exit(full.sendPort, DM.doneFull);
      }
    });
  }
}
