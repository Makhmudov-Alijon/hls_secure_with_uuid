import 'dart:developer' as developerLog;

import '../../entities/local_hls_status.dart';

extension StringExtension on String {
  void log() {
    developerLog.log(this);
  }

  List<String> splitWithExclude(
      {required String pattern, required String excludePattern}) {
    final result = <String>[];
    final buffer = StringBuffer();
    var isInQuotes = false;

    for (var i = 0; i < length; i++) {
      final char = this[i];

      if (char == excludePattern) {
        isInQuotes =
            !isInQuotes; // Переключаем состояние внутри/вне excludePattern
      }

      if (char == pattern && !isInQuotes) {
        // Если находим pattern вне excludePattern, добавляем элемент в результат
        result.add(buffer.toString().trim());
        buffer.clear(); // Очищаем буфер для следующего элемента
      } else {
        buffer.write(char); // Добавляем символ в буфер, включая кавычки
      }
    }

    // Добавляем последний элемент после обработки всей строки
    if (buffer.isNotEmpty) {
      result.add(buffer.toString().trim());
    }

    return result;
  }

  int fastHash() {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  LocalHlsStatusType? get getLocalHlsStatus {
    switch (this) {
      case 'complete':
        return LocalHlsStatusType.complete;
      case 'downloading':
        return LocalHlsStatusType.downloading;
      case 'paused':
        return LocalHlsStatusType.paused;
      case 'inQueue':
        return LocalHlsStatusType.inQueue;
      case 'notExist':
        return LocalHlsStatusType.notExist;
      case 'deleted':
        return LocalHlsStatusType.deleted;
      case 'prepared':
        return LocalHlsStatusType.prepared;
      case 'error':
        return LocalHlsStatusType.error;
      default:
        return LocalHlsStatusType.error;
    }
  }
}
