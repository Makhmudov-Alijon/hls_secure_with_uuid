import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager_example/delete_it/full_gpt_downloader.dart';
import 'package:download_manager_example/utils/widget_extension.dart';
import 'package:download_manager_example/views/test_pages/video_page/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:system_files_viewer/system_files_viewer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();

  ByteData data = await PlatformAssetBundle().load('assets/ca/client.pem');

  SecurityContext.defaultContext.setTrustedCertificatesBytes(
    data.buffer.asUint8List(),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final link =
      'https://api.splay.glob.uz/en/api/v3/content/hls-json-enc/48315/';

  final token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE1MzIxMjQ0LCJpYXQiOjE3MTUzMTU2ODksImp0aSI6ImY3NDVlNzgzMzM2MjQyMDY4ZTI5YmVhYmJhMmM0MGFlIiwidXNlcl9pZCI6Mjc3Njg3MiwicHJvZmlsZV9pZCI6MTAxOTgzMywiYWdlIjoxOCwiYWdlX2dyb3VwIjo0LCJnZW5kZXIiOiJNIiwiY19jb2RlIjoiVVoiLCJtb2RlbF9uYW1lIjoiaVBob25lIiwib3MiOiJpT1MiLCJicm93c2VyIjoiU3BsYXlBcHAiLCJkZXZpY2UiOiJTbWFydHBob25lIiwiYXBwX3R5cGUiOiJhcHAiLCJzaWQiOiJlZDM2NmEzZWNiY2JmZjYxNDA4ODc4N2NlYTIyMGZjMjc4NzRmZDY2In0.knwbF89TzN2TLxNT5wS6wv3BfurO5Cc_I2bwbEALDiU';

  final key = 'API_DI_KEY';

  final hlsId = const LocalHlsId(contentId: 123, filmId: 12);

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

  Future<void> onDownload() async {
    final resolution = selectedResolution!;
    final master = masterPlaylist!;
    final audioTracks = <HlsAudioTrack>{};
    const poster =
        "https://media.istockphoto.com/id/652739682/photo/minor-white-mosque-in-tashkent-uzbekistan.jpg?s=2048x2048&w=is&k=20&c=S1TzQNnjgheb2IvUTWF3gSA261aZUzQh7IZ923e-QXM=";
    final sg = selectedGroups;
    for (final trackGroup in selectedGroups) {
      for (final track in trackGroup.tracks) {
        if (track.trackType == resolution.trackType) {
          audioTracks.add(track);
        }
      }
    }

    final localHlsDetails = LocalHlsDetailsModel(
      id: hlsId,
      title: "Название",
      isSerial: false,
      episodeNum: null,
      seasonNum: null,
      resolution: resolution,
      audioTracks: audioTracks,
    );

    try {
      await ref.read(hlsDownloaderProvider.notifier).prepareAndDownloadOrQueue(
            masterPlaylist: master,
            hlsDetails: localHlsDetails,
            posterLink: poster,
            onError: null,
            onDownloadComplete: (hls, ref) async {
              await Future.delayed(
                const Duration(seconds: 2),
              );
              print("some print");
            },
          );
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  void showSnackBar(String title) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
        ),
      ),
    );
  }

  Future<void> prepareForWatching() async {
    try {
      await ref.read(hlsRepositoryProvider).prepareDataForWatching(
            url: link,
            token: token,
            key: key,
            hlsId: hlsId,
          );
    } catch (e) {
      showSnackBar('Просмотр невозможен');
    }
  }

  Future<void> prepareForDownload() async {
    resetAll();

    try {
      final master = await ref.read(hlsRepositoryProvider).fetchMasterPlaylist(
            url: link,
            key: key,
            token: token,
            hlsId: hlsId,
            forWatching: false,
          );
      setState(() {
        resolutions = master.resolutions;
        trackGroups = master.audioTrackGroups;
        masterPlaylist = master;
      });
    } catch (e) {
      showSnackBar("Скачивание невозможно");
    }
  }

  bool get canDownload =>
      selectedGroups.isNotEmpty && selectedResolution != null;

  String getStatusBy(LocalHlsState hlsState) {
    switch (hlsState.runtimeType) {
      case LocalHlsDownloadingState:
        return 'Загрузка';
      case LocalHlsDeletedState:
        return 'Удалено';
      case LocalHlsCompleteState:
        return 'Завершено';
      case LocalHlsNotExistState:
        return 'Отсутствует';
      case LocalHlsInQueueState:
        return 'В очереди';
      case LocalHlsPauseState:
        return 'Приостановлен';
      case LocalHlsErrorState:
        return 'Ошибка';
      default:
        return 'Неизвестно';
    }
  }

  IconData? iconByStatus(LocalHlsState hlsState) {
    if (hlsState is LocalHlsPauseState || hlsState is LocalHlsErrorState) {
      return Icons.play_circle_fill;
    } else if (hlsState is LocalHlsDownloadingState) {
      return Icons.pause_circle;
    } else if (hlsState is LocalHlsInQueueState) {
      return Icons.download;
    } else {
      return null;
    }
  }

  void onIconPressed(LocalHlsState hlsState) {
    final movieContoller = ref.read(localHlsMovieProvider(hlsId).notifier);
    if (hlsState is LocalHlsPauseState || hlsState is LocalHlsErrorState) {
      movieContoller.tryContinueDownload(
        onDownloadComplete: null,
        onError: null,
      );
    } else if (hlsState is LocalHlsDownloadingState ||
        hlsState is LocalHlsInQueueState) {
      movieContoller.pauseDownload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        actions: [
          IconButton(
            onPressed: () async {
              final dir = await getApplicationDocumentsDirectory();
              if (context.mounted) {
                SystemFilesViewer.openDirectoryPage(
                  context: context,
                  directory: dir,
                  onHlsPlayPressed: (master) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoPage(
                            master: master,
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.folder),
          ),
        ],
      ),
      body: ref.watch(localHlsMoviesProvider).when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) {
              final movieState = ref.watch(localHlsMovieProvider(hlsId));
              final movieController =
                  ref.watch(localHlsMovieProvider(hlsId).notifier);
              return RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(localHlsMoviesProvider.notifier)
                      .refreshMovies();
                  ref.invalidate(localHlsMovieProvider);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomScrollView(
                    slivers: [
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
                                    final resolution =
                                        resolutions.elementAt(index);
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
                                        setState(
                                          () {
                                            if (selectedGroups
                                                .contains(group)) {
                                              selectedGroups.remove(group);
                                            } else {
                                              selectedGroups.add(group);
                                            }
                                          },
                                        );
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
                        onPressed: canDownload ? onDownload : null,
                        child: const Text('Скачать'),
                      ),
                      // if (movieState.progress != 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (iconByStatus(movieState) != null)
                                  SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () =>
                                          onIconPressed(movieState),
                                      icon: Icon(iconByStatus(movieState)!),
                                    ),
                                  ),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: movieState.progresss,
                                  ),
                                ),
                                if (movieState is! LocalHlsCompleteState)
                                  SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: IconButton(
                                      icon: const Icon(Icons.cancel),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        movieController.cancelDownload();
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getStatusBy(movieState),
                                ),
                                if (movieState is! LocalHlsCompleteState)
                                  Text(
                                    '${(movieState.progresss * 100).toStringAsFixed(1)}%',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ].toSlivers.toList(),
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  "Error: $error",
                  textAlign: TextAlign.center,
                ),
              );
            },
            loading: () {
              return const CircularProgressIndicator();
            },
          ),
    );
  }
}
