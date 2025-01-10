import 'dart:isolate';

import 'package:download_manager/src/providers/download/top_level_functions/store_to_file.dart';
import 'package:http/http.dart' as http;

Future<void> downloadFileHttp(SendPort sendPort) async {
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
      DateTime start = DateTime.now();
      final response = await http.get(
        Uri.parse(
          item.$1,
          // 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      );
      // final response = await http.get(Uri.parse(item.$1));

      print(
          '>< >< spent time HTTP : ${DateTime.now().difference(start).inMilliseconds}, ${response.bodyBytes.length / (1024 * 1024)} MB');
      if (response.statusCode == 200) {
        data = StoreFileData(
          bytes: response.bodyBytes,
          filePath: item.$2 + 'big bunny',
        );
      } else {
        // print('Failed to download ${item.url}: ${response.statusCode}');
        sendPort.send(
          MapEntry(
            response.reasonPhrase ?? 'Reason is null',
            item,
          ),
        ); // Re-send the item for retry
      }
    } catch (e) {
      // print('Error downloading ${item.url}: $e');
      sendPort.send(MapEntry(e.toString(), item)); // Re-send the item for retry
    }

    // Notify the main isolate that this task is done
    sendPort.send(data);
  }
}
