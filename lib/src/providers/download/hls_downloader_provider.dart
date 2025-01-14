import 'dart:async';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/providers/download/top_level_functions/download.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  void _startDownloading() {
    if (state == HlsDownloaderState.notDownloading) {
      state = HlsDownloaderState.downloading;
    }
  }

  void _stopDownloading() {
    if (state == HlsDownloaderState.downloading) {
      state = HlsDownloaderState.notDownloading;
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
      _stopDownloading();
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
  Future<void> prepareAndDownloadOrQueue({
    required MasterPlaylistModel masterPlaylist,
    required LocalHlsDetailsModel hlsDetails,
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
    String? posterLink,
  }) async {
    final downloadTask = await ref.read(hlsRepositoryProvider).preparePlaylists(
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
    required int totalSegments,
    required int totalBytes,
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
    final sizeInMegaBytes = totalBytes / (1024 * 1024);

    final megabytePerSegmentProximate = sizeInMegaBytes / totalSegments;

    return segmentPerSecond * megabytePerSegmentProximate;
  }

  double calculateProgressNew({
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

  Future<void> downloadOrContinue({
    // required double estimatedTaskSize,
    required DownloadTask downloadTask,
    required LocalHlsModelIsar hls,
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    final startTime = DateTime.now();
    _startDownloading();
    _downloadingHls = hls.iD;
    LocalHlsModelIsar? theTarget;

    theTarget = await moviesController.updateHlsStatus(
      hls.iD,
      LocalHlsDownloadingState(),
      where: 'start downloading 168 ',
    );

    print(
        '>< >< update hls to downloading : ${DateTime.now().difference(startTime).inMilliseconds}');

    try {

      final allTasksCompleted = Completer<void>();
      LocalHlsState? localHlsState;

      final tasks = <(String url, String absPath)>[
        ...downloadTask.items
            .where((e) => !e.isDownloaded)
            .map((e) => e.getForIsolate),
      ];
      final preloadedTasksCount = downloadTask.items.length - tasks.length;
      var count = preloadedTasksCount;

      if (tasks.isNotEmpty) {
        Timer? progressUpdateTimer;

        progressUpdateTimer = Timer.periodic(
          const Duration(milliseconds: 500),
          (timer) {
            final progress = calculateProgressNew(
              totalLength: downloadTask.items.length, doneLength: count,
              // + failedTasks.length,
            );
            final speed = calculateDownloadSpeed(
              startTime: startTime,
              totalSegments: downloadTask.items.length,
              totalBytes: downloadTask.size,
              downloadedSegments: count - preloadedTasksCount,
            );
            // This code runs every second and updates the UI
            if (state == HlsDownloaderState.downloading) {
              localHlsMovieController(hls.iD).updateProgress(
                progress: progress,
                speed: speed,
              );
            }
          },
        );
        final thePort = ReceivePort();
        final theIsolate = await Isolate.spawn(
          download,
          DownloadFullTask(
            tasks: tasks,
            sendPort: thePort.sendPort,
          ),
        );
        var lastCheckForPauseOrDeleted = DateTime.now();

        thePort.listen(
          (v) async {
            if (v is int) {
              if ((count - preloadedTasksCount) == 0) {
                print(
                    '>< >< got the first task message : ${DateTime.now().difference(startTime).inMilliseconds} pre: $preloadedTasksCount count: $count');
              }
              final hint = DownloadFullHintEnum.values[v];
              switch (hint) {
                case DownloadFullHintEnum.doneFor:
                  {
                    count++;
                    if (DateTime.now()
                            .difference(lastCheckForPauseOrDeleted)
                            .inMilliseconds >
                        300) {
                      final state = await ref
                          .read(localeHlsStoreRepositoryProvider)
                          .getHlsDownloadStatusType(
                            hlsId: hls.id,
                          );
                      final v = 0;

                      if (state is LocalHlsPauseState ||
                          state is LocalHlsDeletedState) {
                        localHlsState = state;
                        allTasksCompleted.complete();
                      }
                      lastCheckForPauseOrDeleted = DateTime.now();
                    }

                    break;
                  }
                case DownloadFullHintEnum.doneFull:
                  {
                    SchedulerBinding.instance.addPostFrameCallback((_) async {
                      // Update the UI here
                      theTarget = await moviesController.updateHlsStatus(
                        hls.iD,
                        localHlsState ??
                            (count == downloadTask.items.length
                                ? LocalHlsCompleteState()
                                : LocalHlsErrorState()),
                        where: 'downloader 273',
                      );
                    });
                    progressUpdateTimer?.cancel();
                    progressUpdateTimer = null;
                    allTasksCompleted.complete();
                    break;
                  }
                case DownloadFullHintEnum.failFor:
                  {
                    break;
                  }
                case DownloadFullHintEnum.startingTaskCompleted:
                  {
                    break;
                  }
              }
            }
          },
        );
        await allTasksCompleted.future;
        theIsolate.kill(priority: Isolate.immediate);
        thePort.close();
      } else {
        theTarget = await moviesController.updateHlsStatus(
          hls.iD,
          LocalHlsCompleteState(),
          where: 'download completed 318',
        );
      }

      late LocalHlsState resultState;

      resultState = theTarget?.localHlsState ?? LocalHlsDeletedState();

      // print(
      //     '>< >< spend to download >> : ${DateTime.now().difference(startTime).inMilliseconds} milliseconds');

      final v = 0;

      /// ////////////////////////////////////
      _downloadingHls = null;
      _isolateRunning = false;
      if (resultState is LocalHlsErrorState) {
        theTarget = await moviesController.updateHlsStatus(
          hls.iD,
          resultState,
          where: 'error state 332',
        );
        _stopDownloading();
        onError?.call(resultState);
      } else if (resultState is LocalHlsDeletedState) {
        _stopDownloading();
        moviesController.deleteHls(hls: hls);
      } else {
        _stopDownloading();
        theTarget = await moviesController.updateHlsStatus(
          hls.iD,
          resultState,
          where: 'download provider 340',
        );
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
      _isolateRunning = false;
      _stopDownloading();
    }
  }


}
