import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;
  String? _videoPath;
  bool _isDownloading = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _downloadAndPlayVideo();
  }

  Future<void> _downloadAndPlayVideo() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoPath = '${directory.path}/video.m3u8';

      // Download the HLS video
      final dio = Dio();
      await dio.download(
        'https://hlsjs.video-dev.org/demo/?src=https%3A%2F%2Fapi.splay.uz%2Fen%2Fapi%2Fv3%2Fcontent%2Fhls-simple%2Fcuser-agent-for-generating-picture-in-the-middle-of-video%2F48315%2Fplaylist.m3u8&demoConfig=eyJlbmFibGVTdHJlYW1pbmciOnRydWUsImF1dG9SZWNvdmVyRXJyb3IiOnRydWUsInN0b3BPblN0YWxsIjpmYWxzZSwiZHVtcGZNUDQiOmZhbHNlLCJsZXZlbENhcHBpbmciOi0xLCJsaW1pdE1ldHJpY3MiOi0xfQ==',
        videoPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      setState(() {
        _videoPath = videoPath;
        _isDownloading = false;
      });

      // Initialize the video player
      _controller = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        });
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      print("Error downloading video: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HLS Video Downloader"),
      ),
      body: Center(
        child: _isDownloading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(value: _progress),
                  SizedBox(height: 20),
                  Text("Downloading: ${(_progress * 100).toStringAsFixed(0)}%"),
                ],
              )
            : _controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Text("Failed to download video"),
      ),
    );
  }
}
