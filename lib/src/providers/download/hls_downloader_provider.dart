import 'dart:async';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/providers/download/top_level_functions/retry_without_exiting.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/isar/download_task/download_task_repository_impl.dart';
import '../../repository/isar/locale_hls_store/locale_hls_store_repository_impl.dart';
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

  LocalHlsId? _downloadingHlss;

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

  Future<void> addToQueuee(LocalHlsModelIsar hls) async {
    await moviesController.updateHlsStatus(
      hls.id,
      LocalHlsInQueueState(),
      where: 'add to queue 53',
    );
  }

  Future<void> pauseDownload(LocalHlsModelIsar hls,
      {bool isUpdate = true}) async {
    if (hls.iD == _downloadingHlss) {
      _stopDownloading(where: 'pause download');
    }
    if (isUpdate) {
      await moviesController.updateHlsStatus(
        hls.id,
        LocalHlsPauseState(),
        where: 'pause download 60',
      );
    }
  }

  void cancelDownload(LocalHlsModelIsar hls) {
    moviesController.updateHlsStatus(
      hls.id,
      LocalHlsDeletedState(),
      where: 'cancel download 64',
    );
  }

  void tryToDownloadd({
    required LocalHlsModelIsar hls,
    required void Function(LocalHlsErrorState error)? onError,
    required Future<void> Function(LocalHlsModelIsar hls, Ref<Object?> ref)?
        onDownloadComplete,
  }) async {
    if (state == HlsDownloaderState.downloading) {
      await addToQueuee(hls);
    } else {
      final downloadTask = await ref.read(downloadTaskIsarProvider).getById(
            hls.id,
          );
      if (downloadTask != null) {
        await downloadOrContinue(
          downloadTask: downloadTask,
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
  Future<void> prepareAndDownloadOrQueue({
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
          await addToQueuee(hls);
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
      final downloadTask = await ref.read(downloadTaskIsarProvider).getById(
            nextHls.id,
          );
      if (downloadTask != null) {
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

  /// ///////////////////////
  /// ///////////////////////
  ///     DOWNLOAD OR CONTINUE /////
  /// ///////////////////////
  /// ///////////////////////

  Timer? progressUpdateTimer;

  Future<void> downloadOrContinue({
    required DownloadTask downloadTask,
    required LocalHlsModelIsar hls,
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    var lastCheckForPauseOrDeleted = DateTime.now();

    final startTimee = DateTime.now();
    _startDownloading(where: 'line 222 ${startTimee}');
    _downloadingHlss = hls.iD;
    LocalHlsModelIsar? theTarget = await moviesController.updateHlsStatus(
      hls.id,
      LocalHlsDownloadingState(),
      where: 'start downloading 168 ',
    );
    Isolate? theIsolate;
    ReceivePort? thePort;
    late LocalHlsState resultState;
    int lastUpdatedFor = 0;
    void dispose() {
      lastUpdatedFor = 0;
      progressUpdateTimer?.cancel();
      progressUpdateTimer = null;
      thePort?.close();
      thePort = null;
      theIsolate?.kill(priority: Isolate.immediate);
      theIsolate = null;
    }

    try {
      final tasks = Map<String, String>.fromEntries(
        downloadTask.items.where((e) => !e.isDownloaded).map(
              (e) => e.getForIsolateMap,
            ),
      );


      final preloadedTasksCount = downloadTask.items.length - tasks.length;
      final allTasksCompleted = Completer<void>();
      if (tasks.isNotEmpty) {
        thePort = ReceivePort();
        var count = 0;

        void _timer(timer) {
          if (state == HlsDownloaderState.downloading) {
            final progress = calculateProgress(
              totalLength: downloadTask.items.length,
              doneLength: count + preloadedTasksCount,
              // + failedTasks.length,
            );
            final speed = lastUpdatedFor == count
                ? 0.0
                : calculateDownloadSpeed(
                    startTime: startTimee,
                    mbPerSegment: downloadTask.mbPerSegment,
                    downloadedSegments: count,
                  );

            // This code runs every half a second and updates the UI
            lastUpdatedFor = count;
            localHlsMovieController(hls.iD).updateProgress(
              progress: progress,
              speed: speed,
            );
          } else {
            timer.cancel();
          }
        }

        progressUpdateTimer = Timer.periodic(
          const Duration(milliseconds: 300),
          _timer,
        );

        theIsolate = await Isolate.spawn(
          retryWithoutExiting,
          DownloadFullTask2(
            tasks: tasks,
            sendPort: thePort!.sendPort,
          ),
        );
        late SendPort isolateSendPort;

        thePort!.listen(
          (message) async {
            if (message is SendPort) {
              isolateSendPort = message;
            }
            if (message is int) {
              switch (message) {
                case DM.waitForNetwork:
                  {
                     resultState = LocalHlsWaitingForNetworkState();
                    try {
                      if (!allTasksCompleted.isCompleted) {
                        allTasksCompleted.complete();
                      } else {
                        final v = 0;
                      }
                    } catch (e) {
                      print('<>< ><> complete exception doneFull : $e');
                    }

                    break;
                  }
                case DM.error:
                  {
                    final retry = canRetry();
                    if (retry) {
                      isolateSendPort.send(DM.error);
                    } else {
                      isolateSendPort.send(DM.goBack);
                    }
                    break;
                  }
                case DM.gottenBack:
                case DM.goBackWithError:
                  {
                    resultState =
                        count + preloadedTasksCount == downloadTask.items.length
                            ? LocalHlsCompleteState()
                            : message == DM.goBackWithError
                                ? LocalHlsErrorState()
                                : LocalHlsPauseState();

                    try {
                      if (!allTasksCompleted.isCompleted) {
                        allTasksCompleted.complete();
                      }
                    } catch (e) {
                      print('<>< ><> complete exception : $e');
                    }

                    break;
                  }
                case DM.doneFor:
                  {
                    count++;

                    if (DateTime.now()
                            .difference(lastCheckForPauseOrDeleted)
                            .inMilliseconds >
                        300) {
                      final check = ref
                          .read(localeHlsIsarProvider)
                          .getHlsDownloadStatusTypee(
                            hlsId: hls.id,
                          );

                      if (check is LocalHlsWaitingForNetworkState) {
                         isolateSendPort.send(DM.waitForNetwork);
                      } else if (check is LocalHlsPauseState ||
                          check is LocalHlsDeletedState) {
                        isolateSendPort.send(DM.goBack);
                      }

                      lastCheckForPauseOrDeleted = DateTime.now();
                    }

                    break;
                  }
                case DM.doneFull:
                  {
                    resultState =
                        count + preloadedTasksCount == downloadTask.items.length
                            ? LocalHlsCompleteState()
                            : LocalHlsErrorState();

                    try {
                      if (!allTasksCompleted.isCompleted) {
                        allTasksCompleted.complete();
                      } else {
                        final v = 0;
                      }
                    } catch (e) {
                      print('<>< ><> complete exception doneFull : $e');
                    }

                    break;
                  }
              }
            }
          },
        );
      } else {
        resultState = LocalHlsCompleteState();
        allTasksCompleted.complete();
      }
      await allTasksCompleted.future;



      dispose();

      theTarget = await moviesController.updateHlsStatus(
        hls.id,
        resultState,
        where: 'after download complete 402',
      );

      _downloadingHlss = null;
      _isolateRunning = false;
      if (resultState is LocalHlsErrorState) {
        _stopDownloading(where: 'line 411');
        onError?.call(LocalHlsErrorState());
      } else if (resultState is LocalHlsDeletedState) {
        _stopDownloading(where: 'line 414');
        await moviesController.deleteHls(hls: hls);
      } else if (resultState is LocalHlsWaitingForNetworkState) {
        _stopDownloading(where: 'waiting for network');
        return;
      } else {
        _stopDownloading(where: 'line 417');
      }

      if (onDownloadComplete != null &&
          resultState is LocalHlsCompleteState &&
          theTarget != null) {
        await onDownloadComplete.call(theTarget, ref);
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
        hls.id,
        LocalHlsErrorState(),
        where: 'after download complete 402',
      );
      dispose();
      _stopDownloading(where: 'catch line 421');
    }
  }
}
