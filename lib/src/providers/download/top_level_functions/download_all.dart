import 'dart:isolate';

import 'package:http/http.dart' as http;

Future<void> downloadFull(DownloadFullTask full) async {
  print('>< >< length : ${full.tasks.length}');
  int count = 0;
  for (final v in full.tasks) {
    final response = http
        .get(
      Uri.parse(
        v.$1,
        // 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
    )
        .then((v) {
      if (v.statusCode == 200) {
        print('>< >< done for : ${count++}');

        full.sendPort.send('done-for');
      } else {
        print('>< >< fail for : ${count++}');
      }
      if (count >= full.tasks.length) {
        full.sendPort.send('done-full');
      }
    });
  }
  full.sendPort.send('done');
}

class DownloadFullTask {
  const DownloadFullTask({
    required this.tasks,
    required this.sendPort,
  });

  final List<(String url, String absPath)> tasks;
  final SendPort sendPort;
}
