import 'dart:io';
import 'dart:async';
import 'package:download_manager/download_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';

class HLSDownloader {
  final String playlistUrl;

  HLSDownloader({required this.playlistUrl});

  Future<void> download() async {
    final segments = await _fetchSegments();
    // await downloadSegments(segments);
  }

  Future<List<String>> _fetchSegments() async {
    final response = await http.get(Uri.parse(playlistUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load playlist');
    }

    final lines = response.body.split('\n');
    final result = lines.where((line) => line.endsWith('.ts')).toList();
    return result;
  }

static  Future<void> downloadSegments( DownloadItem  segment) async {
    // final tempDir = await getTemporaryDirectory();
    final httpClient = http.Client();

    final segmentUri = Uri.parse(segment.url);
    final file = File(segment.absolutePath);

    final response = await httpClient.get(segmentUri);

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download segment: ${segment.url}');
    }


  }
}
