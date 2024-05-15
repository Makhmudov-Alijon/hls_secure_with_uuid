import 'package:download_manager/download_manager.dart';
import 'package:download_manager_example/views/test_pages/directory_page.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

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
  // final link = 'http://192.168.0.130:8000/en/api/v3/content/hls-json-enc/654/';

  // final link = 'http://192.168.0.130:8000/en/api/v3/content/hls-json-enc/1313/';

  // final link =
  //     'https://api.splay.glob.uz/en/api/v3/content/hls-json-enc/48161/';

  final link = 'https://api.splay.uz/en/api/v3/content/hls-json-enc/30959/';

  final token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE1MzIxMjQ0LCJpYXQiOjE3MTUzMTU2ODksImp0aSI6ImY3NDVlNzgzMzM2MjQyMDY4ZTI5YmVhYmJhMmM0MGFlIiwidXNlcl9pZCI6Mjc3Njg3MiwicHJvZmlsZV9pZCI6MTAxOTgzMywiYWdlIjoxOCwiYWdlX2dyb3VwIjo0LCJnZW5kZXIiOiJNIiwiY19jb2RlIjoiVVoiLCJtb2RlbF9uYW1lIjoiaVBob25lIiwib3MiOiJpT1MiLCJicm93c2VyIjoiU3BsYXlBcHAiLCJkZXZpY2UiOiJTbWFydHBob25lIiwiYXBwX3R5cGUiOiJhcHAiLCJzaWQiOiJlZDM2NmEzZWNiY2JmZjYxNDA4ODc4N2NlYTIyMGZjMjc4NzRmZDY2In0.knwbF89TzN2TLxNT5wS6wv3BfurO5Cc_I2bwbEALDiU';

  final key = 'API_DI_KEY';

  final hlsId = const LocalHlsId(movieId: 123);

  MasterPlaylistModel? masterPlaylist;

  Set<HlsResolution> resolutions = {};

  Set<HlsAudioTrackGroup> trackGroups = {};

  HlsResolution? selectedResolution;

  Set<HlsAudioTrackGroup> selectedGroups = {};

  void resetAll() {
    setState(() {
      masterPlaylist = null;
      selectedResolution = null;
      resolutions.clear();
      trackGroups.clear();
      selectedGroups.clear();
    });
  }

  Future<void> prepareForWatching() async {
    ref.read(hlsRepositoryProvider).prepareForWatching(
          url: link,
          token: token,
          key: key,
          hlsId: hlsId,
        );
  }

  Future<void> prepareForDownload() async {
    resetAll();

    final master = await ref.read(hlsRepositoryProvider).fetchMasterPlaylist(
          url: link,
          key: key,
          token: token,
          hlsId: hlsId,
        );

    setState(() {
      resolutions = master.resolutions;
      trackGroups = master.audioTrackGroups;
      masterPlaylist = master;
    });
  }

  bool get canDownload =>
      selectedGroups.isNotEmpty && selectedResolution != null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
              actions: [
                IconButton(
                  onPressed: () async {
                    final dir = await getApplicationDocumentsDirectory();
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DirectoryPage(directory: dir);
                          },
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.folder),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    link,
                  ),
                  ElevatedButton(
                    onPressed: prepareForDownload,
                    child: const Text("Подготовить к скачиванию"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: prepareForWatching,
                    child: const Text('Посмотреть'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (resolutions.isNotEmpty)
                              const Text(
                                "Доступные качества",
                              ),
                            ...List.generate(
                              resolutions.length,
                              (index) {
                                final resolution = resolutions.elementAt(index);
                                return RadioListTile.adaptive(
                                  dense: true,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  contentPadding: EdgeInsets.zero,
                                  value: resolution == selectedResolution,
                                  groupValue: true,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedResolution = resolution;
                                    });
                                  },
                                  title: Text(
                                    resolution.resolution.title,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (trackGroups.isNotEmpty)
                              const Text(
                                "Доступные озвучки",
                              ),
                            ...List.generate(
                              trackGroups.length,
                              (index) {
                                final group = trackGroups.elementAt(index);
                                return CheckboxListTile(
                                  title: Text(group.language),
                                  dense: true,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  contentPadding: EdgeInsets.zero,
                                  value: selectedGroups.contains(group),
                                  onChanged: (value) {
                                    setState(() {
                                      if (selectedGroups.contains(group)) {
                                        selectedGroups.remove(group);
                                      } else {
                                        selectedGroups.add(group);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: canDownload ? () {} : null,
                    child: const Text('Скачать'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
