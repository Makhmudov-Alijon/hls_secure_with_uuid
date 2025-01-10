import 'dart:isolate';

import 'package:download_manager/src/providers/download/top_level_functions/store_to_file.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> downloadWithFlutterDownloaderr(SendPort sendPort) async {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  await for (final item in receivePort) {
    if (item is! (
      String url,
      String absPath,
    )) {
      break; // Exit loop and isolate when receiving a null value
    }

    // print(' *** started for: ${item.url.split(".")[2].split("/").last}');
    StoreFileData? data;
    try {

      final taskId = await FlutterDownloader.enqueue(
        url: item.$1,
        savedDir: item.$2,
        showNotification: true,
        // Show download progress in the notification bar
        openFileFromNotification:
            true, // Open the file after download is complete
      );
      final v = 0;
      // if (response.statusCode == 200) {
      //   data = StoreFileData(
      //     bytes: response.bodyBytes,
      //     filePath: item.$2,
      //   );
      // } else {
      //   // print('Failed to download ${item.url}: ${response.statusCode}');
      //   sendPort.send(
      //     MapEntry(
      //       response.reasonPhrase ?? 'Reason is null',
      //       item,
      //     ),
      //   ); // Re-send the item for retry
      // }
    } catch (e) {
      // print('Error downloading ${item.url}: $e');
      sendPort.send(MapEntry(e.toString(), item)); // Re-send the item for retry
    }

    // Notify the main isolate that this task is done
    sendPort.send(data);
  }
}
