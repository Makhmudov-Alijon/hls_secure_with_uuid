import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'download.dart';

void downloadGpt(DownloadFullTask full) {
  final key = DateTime.now().millisecondsSinceEpoch;
  var count = 0;
  final dio = Dio();
  final CancelToken cancelToken = CancelToken();

  for (final task in full.tasks) {
    dio
        .get<dynamic>(
      task.$1,
      options: Options(responseType: ResponseType.bytes),
      cancelToken: cancelToken,
    )
        .then((response) async {
      if (response.data is Uint8List) {
        final file = File(task.$2);

        // Open the file for writing
        final randomAccessFile = await file.open(mode: FileMode.write);

        // Write the downloaded bytes to the file
        await randomAccessFile.writeFrom(response.data as Uint8List);

        // Close the file
        await randomAccessFile.close();

        // Notify that this task is done
        full.sendPort.send(DownloadMassager.doneFor);
      } else {
        print('>< >< rtt : ${response.data.runtimeType}');
      }
    }).catchError((error) {
      if (error is DioException) {
        if (CancelToken.isCancel(error)) {
          print('Download cancelled for: ${task.$1}');
        } else {
          print('Error downloading ${task.$2}: $error');
        }
      } else {
        print('>< >< not dio exception : ${error.runtimeType}');
      }
    }).whenComplete(() {
      count++;
      if (count >= full.tasks.length) {
        full.sendPort.send(DownloadMassager.doneFull);
      }
    });
  }

  // Listen for cancellation signal
  full.cancelSignal.stream.listen((_) {
    cancelToken.cancel('Download cancelled by user.');
  });
}
