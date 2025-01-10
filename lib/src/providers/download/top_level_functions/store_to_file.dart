import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

// import 'package:flutter/foundation.dart';

Future<void> storeToFileWorker(StoreFileData v) async {
  // final file = File(v.filePath);
  //
  // // Open the file for writing
  // final randomAccessFile = await file.open(mode: FileMode.write);
  //
  // // Write the downloaded bytes to the file
  // await randomAccessFile.writeFrom(v.bytes);
  //
  // // Close the file
  // await randomAccessFile.close();

  /// gpt
  // final file = File(v.filePath);
  //
  // // Ensure the directory exists
  // await file.create(recursive: true);
  //
  // // Write the bytes to the file
  // await file.writeAsBytes(v.bytes, flush: true);

  /// gpt two
  final file = File(v.filePath);
  final raf = await file.open(mode: FileMode.write);

  const int chunkSize = 8192; // 8 KB
  int offset = 0;
  final data = v.bytes;
  while (offset < data.length) {
    int end =
        (offset + chunkSize > data.length) ? data.length : offset + chunkSize;
    await raf.writeFrom(data, offset, end);
    offset = end;
  }

  await raf.close();

  Isolate.exit(v.sendPort, true);
}

class StoreFileData {
  const StoreFileData({
    required this.bytes,
    required this.filePath,
    this.sendPort,
  });

  final Uint8List bytes;
  final SendPort? sendPort;
  final String filePath;

  StoreFileData copyWith({
    Uint8List? bytes,
    SendPort? sendPort,
    String? filePath,
  }) =>
      StoreFileData(
        bytes: bytes ?? this.bytes,
        sendPort: sendPort ?? this.sendPort,
        filePath: filePath ?? this.filePath,
      );
}
