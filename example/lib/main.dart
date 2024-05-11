import 'package:download_manager/download_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final playerHls = ref.read(remoteHlsProvider.notifier);
      const token =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE1MzIxMjQ0LCJpYXQiOjE3MTUzMTU2ODksImp0aSI6ImY3NDVlNzgzMzM2MjQyMDY4ZTI5YmVhYmJhMmM0MGFlIiwidXNlcl9pZCI6Mjc3Njg3MiwicHJvZmlsZV9pZCI6MTAxOTgzMywiYWdlIjoxOCwiYWdlX2dyb3VwIjo0LCJnZW5kZXIiOiJNIiwiY19jb2RlIjoiVVoiLCJtb2RlbF9uYW1lIjoiaVBob25lIiwib3MiOiJpT1MiLCJicm93c2VyIjoiU3BsYXlBcHAiLCJkZXZpY2UiOiJTbWFydHBob25lIiwiYXBwX3R5cGUiOiJhcHAiLCJzaWQiOiJlZDM2NmEzZWNiY2JmZjYxNDA4ODc4N2NlYTIyMGZjMjc4NzRmZDY2In0.knwbF89TzN2TLxNT5wS6wv3BfurO5Cc_I2bwbEALDiU';
      // final response = await Dio().get(
      //     'http://192.168.0.130:8000/en/api/v3/content/hls-data-film/123',
      //     options: Options(
      //         headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

      // final data = response.data as Map<String, dynamic>;

      // playerHls.fetchVideoData(
      //   url: 'https://vod02.splay.uz/bare_bottle/master.m3u8',
      //   key: 'API_DT_KY',
      //   isEnc: false,
      //   token: token,
      // );

      playerHls.parse(
        url: 'https://vod02.splay.uz/bare_bottle/master.m3u8',
        token: token,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
      ),
    );
  }
}
