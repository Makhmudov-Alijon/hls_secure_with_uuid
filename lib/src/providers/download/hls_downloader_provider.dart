import 'dart:async';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/providers/download/top_level_functions/cancelable_http.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'datas/datas.dart';

enum HlsDownloaderState {
  downloading,
  notDownloading,
}

final hlsDownloaderProvider =
    NotifierProvider<HlsDownloaderNotifier, HlsDownloaderState>(
  HlsDownloaderNotifier.new,
);

class HlsDownloaderNotifier extends Notifier<HlsDownloaderState> {
  @override
  HlsDownloaderState build() {
    return HlsDownloaderState.notDownloading;
  }

  bool _isolateRunning = false;

  LocalHlsId? _downloadingHls;

  LocalHlsMoviesNotifier get moviesController => ref.read(
        localHlsMoviesProvider.notifier,
      );

  LocalHlsMovieNotifier localHlsMovieController(LocalHlsId hlsId) => ref.read(
        localHlsMovieProviderr(hlsId).notifier,
      );

  void _startDownloading({required String where}) {
    _retry = 0;
    if (state == HlsDownloaderState.notDownloading) {
      state = HlsDownloaderState.downloading;
    } else {
      final v = 0;
    }
  }

  void _stopDownloading({required String where}) {
    if (state == HlsDownloaderState.downloading) {
      state = HlsDownloaderState.notDownloading;
    } else {
      final v = 0;
    }
  }

  void addToQueue(LocalHlsModelIsar hls) {
    moviesController.updateHlsStatus(
      hls.iD,
      LocalHlsInQueueState(),
      where: 'add to queue 53',
    );
  }

  void pauseDownload(LocalHlsModelIsar hls) {
    if (hls.iD == _downloadingHls) {
      _stopDownloading(where: 'pause download');
    }
    moviesController.updateHlsStatus(
      hls.iD,
      LocalHlsPauseState(),
      where: 'pause download 60',
    );
  }

  void cancelDownload(LocalHlsModelIsar hls) {
    moviesController.updateHlsStatus(
      hls.iD,
      LocalHlsDeletedState(),
      where: 'cancel download 64',
    );
  }

  void tryToDownload({
    required LocalHlsModelIsar hls,
    required DownloadTask? downloadTask,
    required void Function(LocalHlsErrorState error)? onError,
    required Future<void> Function(LocalHlsModelIsar hls, Ref<Object?> ref)?
        onDownloadComplete,
  }) {
    if (state == HlsDownloaderState.downloading) {
      addToQueue(hls);
    } else {
      if (hls.downloadTasksFile.existsSync()) {
        downloadOrContinue(
          downloadTask:
              downloadTask ?? DownloadTask.fromFile(hls.downloadTasksFile),
          hls: hls,
          onDownloadComplete: onDownloadComplete,
          onError: onError,
        );
      } else {
        /// hls download task file does not exists
        final v = 0;
      }
    }
  }

  /// point
  Future<void> prepareAndDownloadOrQueuee({
    required MasterPlaylistModel masterPlaylist,
    required LocalHlsDetailsModel hlsDetails,
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
    String? posterLink,
  }) async {
    final downloadTask = await ref.read(hlsRepositoryProvider).preparePlaylistss(
          master: masterPlaylist,
          hlsDetails: hlsDetails,
          posterLink: posterLink,
        );
    if (downloadTask != null) {
      await moviesController.refreshMovies();
      var hls = await moviesController.hlsById(
        hlsDetails.localHlsId,
      );

      hls = await moviesController.hlsById(hlsDetails.localHlsId);

      if (hls != null) {
        if (state == HlsDownloaderState.downloading) {
          addToQueue(hls);
        } else {
          if (!_isolateRunning) {
            await downloadOrContinue(
              downloadTask: downloadTask,
              hls: hls,
              onDownloadComplete: onDownloadComplete,
              onError: onError,
            );
          } else {
            final v = 0;
          }
        }
      }
    }
  }

  Future<void> checkForNextQueue({
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
    required String where,
  }) async {
    final nextHls = await moviesController.findNextInQueue(where: where);

    if (nextHls != null) {
      if (nextHls.downloadTasksFile.existsSync()) {
        final downloadTask = DownloadTask.fromFile(nextHls.downloadTasksFile);
        await downloadOrContinue(
          downloadTask: downloadTask,
          hls: nextHls,
          onDownloadComplete: onDownloadComplete,
          onError: onError,
        );
      }
    }
  }

  double calculateDownloadSpeed({
    required DateTime startTime,
    required double mbPerSegment,
    required int downloadedSegments,
  }) {
    if (downloadedSegments == 0) {
      return 0.0; // No segments downloaded yet
    }

    // Calculate the elapsed time in seconds
    final elapsedTime = DateTime.now().difference(startTime).inSeconds;

    if (elapsedTime <= 0) {
      return 0.0; // Avoid division by zero
    }

    final segmentPerSecond = downloadedSegments / elapsedTime;

    return segmentPerSecond * mbPerSegment;
  }

  double calculateProgress({
    required int totalLength,
    required int doneLength,
  }) {
    if (totalLength == 0) {
      return 0.0; // Avoid division by zero
    }

    // Calculate the progress as a percentage
    final progress = doneLength / totalLength;

    return progress;
  }

  int _retry = 0;

  bool canRetry() {
    _retry++;
    return _retry <= 3;
  }

  Future<void> downloadOrContinue({
    // required double estimatedTaskSize,
    required DownloadTask downloadTask,
    required LocalHlsModelIsar hls,
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    var lastCheckForPauseOrDeletedd = DateTime.now();

    final startTime = DateTime.now();
    _startDownloading(where: 'line 222');
    _downloadingHls = hls.iD;
    LocalHlsModelIsar? theTarget;

    theTarget = await moviesController.updateHlsStatus(
      hls.iD,
      LocalHlsDownloadingState(),
      where: 'start downloading 168 ',
    );
    Isolate? theIsolate;
    ReceivePort? thePort;
    Timer? progressUpdateTimer;
    int? countUpdatedForLast;
    void dispose() {
      countUpdatedForLast = null;
      progressUpdateTimer?.cancel();
      progressUpdateTimer = null;
      thePort?.close();
      thePort = null;
      theIsolate?.kill(priority: Isolate.immediate);
      theIsolate = null;
    }

    try {
      Future<LocalHlsState> func() async {
        final tasks = <({String url, String absPath})>[
          ...downloadTask.items
              .where((e) => !e.isDownloaded)
              .map((e) => e.getForIsolate),
        ];
        final preloadedTasksCount = downloadTask.items.length - tasks.length;
        final allTasksCompleted = Completer<void>();
        if (tasks.isNotEmpty) {
          thePort = ReceivePort();
          var count = 0;
          countUpdatedForLast = count + preloadedTasksCount;
          void updateLastCountUpdatedFor() {
            countUpdatedForLast = count + preloadedTasksCount;
          }

          progressUpdateTimer = Timer.periodic(
            const Duration(milliseconds: 300),
            (timer) {
              if (state == HlsDownloaderState.downloading &&
                  (countUpdatedForLast! < count + preloadedTasksCount)) {
                updateLastCountUpdatedFor();
                final progress = calculateProgress(
                  totalLength: downloadTask.items.length,
                  doneLength: count + preloadedTasksCount,
                  // + failedTasks.length,
                );
                final speed = calculateDownloadSpeed(
                  startTime: startTime,
                  mbPerSegment: downloadTask.mbPerSegment,
                  downloadedSegments: count,
                );
                // This code runs every half a second and updates the UI

                localHlsMovieController(hls.iD).updateProgress(
                  progress: progress,
                  speed: speed,
                );
              } else {
                final v = 0;
              }
            },
          );

          theIsolate = await Isolate.spawn(
            // downloadDio,
            cancellableHttp,
            DownloadFullTask(
              tasks: tasks,
              sendPort: thePort!.sendPort,
            ),
          );
          late SendPort isolateSendPort;
          LocalHlsState? hlsState;

          thePort!.listen(
            (v) async {
              if (v is SendPort) {
                isolateSendPort = v;
              }
              if (v is int) {
                switch (v) {
                  case DM.gottenBack:
                    {

                      hlsState = count + preloadedTasksCount ==
                              downloadTask.items.length
                          ? LocalHlsCompleteState()
                          : LocalHlsPauseState();
                      print(
                          '>< >< gotten back : ${theTarget?.downloadStatus.statusType.name}');
                      try {
                        if (!allTasksCompleted.isCompleted) {
                          allTasksCompleted.complete();
                        }
                      } catch (e) {
                        print('>< >< complete exception : $e');
                      }

                      break;
                    }
                  case DM.doneFor:
                    {
                      count++;

                      if (DateTime.now()
                              .difference(lastCheckForPauseOrDeletedd)
                              .inMilliseconds >
                          300) {
                        final check = ref
                            .read(localeHlsIsarProvider)
                            .getHlsDownloadStatusType(
                              hlsId: hls.id,
                            );

                        if (check is LocalHlsPauseState ||
                            check is LocalHlsDeletedState) {
                          isolateSendPort.send(DM.goBack);
                        }

                        lastCheckForPauseOrDeletedd = DateTime.now();
                      }

                      break;
                    }
                  case DM.doneFull:
                    {
                      hlsState = count + preloadedTasksCount ==
                              downloadTask.items.length
                          ? LocalHlsCompleteState()
                          : LocalHlsErrorState();
                      print(
                        '''>< >< ${hlsState.runtimeType} done full => count: $count, pre: $preloadedTasksCount, total: ${downloadTask.items.length}''',
                      );
                      try {
                        if (!allTasksCompleted.isCompleted) {
                          allTasksCompleted.complete();
                        } else {
                          final v = 0;
                        }
                      } catch (e) {
                        print('>< >< complete exception doneFull : $e');
                      }

                      break;
                    }
                }
              }
            },
          );
          await allTasksCompleted.future;

          dispose();
          if (hlsState is LocalHlsErrorState) {
            if (canRetry()) {
              print('>< >< can retry : ');

              return func();
            }
          }

          return hlsState ??
              ref.read(localeHlsIsarProvider).getHlsDownloadStatusType(
                    hlsId: hls.id,
                  );
        } else {
          theTarget = await moviesController.updateHlsStatus(
            hls.iD,
            LocalHlsCompleteState(),
            where: 'download completed 318',
          );
          final result =
              ref.read(localeHlsIsarProvider).getHlsDownloadStatusType(
                    hlsId: hls.id,
                  );
          return result;
        }
      }

      final resultState = await func();
      theTarget = await moviesController.updateHlsStatus(
        hls.iD,
        resultState,
        where: 'after download complete 402',
      );

      print('>< >< result : ${resultState.runtimeType}');

      /// ////////////////////////////////////
      _downloadingHls = null;
      _isolateRunning = false;
      if (resultState is LocalHlsErrorState) {
        _stopDownloading(where: 'line 411');
        onError?.call(resultState);
      } else if (resultState is LocalHlsDeletedState) {
        _stopDownloading(where: 'line 414');
        moviesController.deleteHls(hls: hls);
      } else {
        _stopDownloading(where: 'line 417');
      }

      if (onDownloadComplete != null &&
          resultState is LocalHlsCompleteState &&
          theTarget != null) {
        await onDownloadComplete.call(theTarget!, ref);
      } else {
        final v = 0;
      }
      await checkForNextQueue(
        where: ' after complete: 373',
        onDownloadComplete: onDownloadComplete,
        onError: onError,
      );
    } catch (e) {
      theTarget = await moviesController.updateHlsStatus(
        hls.iD,
        LocalHlsErrorState(),
        where: 'after download complete 402',
      );
      dispose();
      _stopDownloading(where: 'catch line 421');
    }
  }


}
