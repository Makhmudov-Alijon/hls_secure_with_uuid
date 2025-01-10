import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/models/locale_hls/locale_hls_obj/locale_hls_model_obj.dart';
import 'package:download_manager/src/providers/download/top_level_functions/download.dart';
import 'package:download_manager/src/providers/download/top_level_functions/store_to_file.dart';
import 'package:download_manager/src/repository/hls_local_repository.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/locale_hls/local_hls_model/local_hls_id.dart';

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
        localHlsMovieProvider(hlsId).notifier,
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

  void addToQueue(LocalHlsModelObj hls) {
    moviesController.updateHlsStatus(hls.iD, LocalHlsInQueueState(),
      where: 'add to queue 53',
    );
  }

  void pauseDownload(LocalHlsModelObj hls) {
    if (hls.id == _downloadingHls) {
      _stopDownloading();
    }
    moviesController.updateHlsStatus(hls.iD, LocalHlsPauseState(),
      where: 'pause download 60',
    );
  }

  void cancelDownload(LocalHlsModelObj hls) {
    moviesController.updateHlsStatus(hls.iD, LocalHlsDeletedState(),
      where: 'cancel download 64',
    );
  }

  void tryToDownload({
    required LocalHlsModelObj hls,
    required DownloadTask? downloadTask,
    required void Function(LocalHlsErrorState error)? onError,
    required Future<void> Function(LocalHlsModelObj hls, Ref<Object?> ref)?
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
      }
    }
  }

  /// point
  Future<void> prepareAndDownloadOrQueue({
    required MasterPlaylistModel masterPlaylist,
    required LocalHlsDetailsModel hlsDetails,
    required Future<void> Function(LocalHlsModelObj hls, Ref ref)?
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
      LocalHlsModelObj? hls = moviesController.hlsByIdd(
        hlsDetails.localHlsId.target!,
      );

      final int time = 10;

      for (int i = 0; i < time && hls == null; i++) {
        await Future.delayed(const Duration(milliseconds: 300), () {});
        hls = moviesController.hlsByIdd(hlsDetails.localHlsId.target!);
      }

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
      } else {
        final int time = 3;
        var dibiding;
        for (int i = 0; i < time && dibiding == null; i++) {
          await Future.delayed(const Duration(milliseconds: 300), () {});
          dibiding = moviesController.hlsByIdd(hlsDetails.localHlsId.target!);
        }
        if (dibiding != null) {
          return prepareAndDownloadOrQueue(
            masterPlaylist: masterPlaylist,
            onDownloadComplete: onDownloadComplete,
            onError: onError,
            hlsDetails: hlsDetails,
            posterLink: posterLink,
          );
        }
        final v = 0;
      }
    }
  }

  Future<void> checkForNextQueue({
    required Future<void> Function(LocalHlsModelObj hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
    required String where,
  }) async {
    var nextHls = await moviesController.findNextInQueue(where: where);

    if (nextHls == null) {
      const time = 3;
      for (var i = 0; i < time && nextHls == null; i++) {
        await Future.delayed(const Duration(milliseconds: 300), () {});
        nextHls = await moviesController.findNextInQueue(where: where);
        final v = 0;
      }
    }
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

  double calculateProgress(int totalLength, int unDownloadedLength) {
    if (totalLength == 0) {
      return 0.0; // Avoid division by zero
    }

    // Calculate the downloaded length
    int downloadedLength = totalLength - unDownloadedLength;

    // Calculate the progress as a percentage
    double progress = (downloadedLength / totalLength);

    return progress;
  }

  Future<void> storeToFile(StoreFileData data, ReceivePort receivePort) async {
    await Isolate.spawn(
      storeToFileWorker,
      data.copyWith(sendPort: receivePort.sendPort),
    );
  }

  Future<void> downloadOrContinue({
    required DownloadTask downloadTask,
    required LocalHlsModelObj hls,
    required Future<void> Function(LocalHlsModelObj hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    final DateTime start = DateTime.now();
    _startDownloading();
    _downloadingHls = hls.iD;

    LocalHlsState? theState = await moviesController.updateHlsStatus(
      hls.iD,
      LocalHlsDownloadingState(),
      where: 'start downloading 168 ',
    );
    try {
      _isolateRunning = true;

      // final DateTime startTime = DateTime.now();

      List<(String url, String absPath)> tasks = [
        ...downloadTask.items
            .where((e) => !e.isDownloaded)
            .map((e) => e.getForIsolate),
      ];
      List<MapEntry<String, dynamic>> failedTasks = [];

      final hlsLocalRepository = HlsLocalRepository();

      print('>< >< TOTAL TASKS  : ${tasks.length}');
      if (tasks.isNotEmpty) {
        final ReceivePort storeToFileReceivePort = ReceivePort();
        final int maxIsolates = Platform.isIOS ? 2 : 8;
        final List<Isolate> isolates = [];
        final List<StreamQueue<dynamic>> streamQueues = [];
        final Completer<void> allTasksCompleted = Completer<void>();
        LocalHlsState? localHlsState;

        int activeTasks = 0;
        Timer? progressUpdateTimer;

        progressUpdateTimer = Timer.periodic(
          const Duration(milliseconds: 1000),
          (timer) {
            final v = calculateProgress(
              downloadTask.items.length, tasks.length,
              // + failedTasks.length,
            );
            // This code runs every second and updates the UI
            if (state == HlsDownloaderState.downloading) {
              localHlsMovieController(hls.iD).updateProgress(v, activeTasks);
            }
          },
        );
        int count = 0;
        storeToFileReceivePort.listen((v) {
          if (v is bool && v) {
            print('>< >< storeFile : ${count++}');
            ;
          } else {
            print('>< >< store file isNot bool : ${count++}');
          }
        });

        // Create the isolates
        for (var i = 0; i < maxIsolates; i++) {
          final receivePort = ReceivePort();
          final isolate =
              await Isolate.spawn(downloadFileHttp, receivePort.sendPort);
          // await Isolate.spawn(
          //     downloadWithFlutterDownloaderr, receivePort.sendPort);
          isolates.add(isolate);

          final streamQueue = StreamQueue(receivePort);
          streamQueues.add(streamQueue);

          // Get the SendPort from each isolate
          final sendPort = await streamQueue.next as SendPort;

          // Distribute the initial tasks to the isolates
          if (tasks.isNotEmpty) {
            sendPort.send(tasks.removeAt(0));
            activeTasks++;
          }

          DateTime lastCheckForPauseOrDeleted = DateTime.now();
          // Listen for completion messages from each isolate
          streamQueue.rest.listen(
            (message) async {
              if (message is StoreFileData) {
                if (message.bytes.isNotEmpty) {
                  unawaited(storeToFile(message, storeToFileReceivePort));
                  if (DateTime.now()
                          .difference(lastCheckForPauseOrDeleted)
                          .inMilliseconds >
                      300) {
                    // final state = hlsLocalRepository.fetchHlsState(hls);
                    final state = await getHlsDownloadStatusType(
                      statusStoreKey: hls.getStatusKey,
                      progress: calculateProgress(
                        downloadTask.items.length,
                        tasks.length,
                      ),
                    );

                    if (state is LocalHlsPauseState ||
                        state is LocalHlsDeletedState) {
                      localHlsState = state;
                      sendPort.send(null);
                      activeTasks--;
                    }
                    lastCheckForPauseOrDeleted = DateTime.now();
                  }
                  if (tasks.isNotEmpty) {
                    final nextTask =
                        tasks.removeAt(0); // Get the next URL from the list
                    sendPort.send(nextTask);
                  } else {
                    sendPort.send(null); // Signal the isolate to terminate
                    activeTasks--;
                  } // Send the next URL to the isolate
                }

                if (activeTasks == 0) {
                  // Exit loop and isolate when receiving a null value
                  SchedulerBinding.instance.addPostFrameCallback((_) async {
                    // Update the UI here
                    theState = await moviesController.updateHlsStatus(
                      hls.iD,
                      localHlsState ??
                          (failedTasks.isEmpty
                              ? LocalHlsCompleteState()
                              : LocalHlsErrorState(
                                  message:
                                      '${failedTasks.length} segments are not downloaded',
                                  )),
                      where: 'downloader 273',
                    );
                  });
                  print(
                      '>< >< downloading ended in: ${DateTime.now().difference(start).inMilliseconds} millisseconds');
                  progressUpdateTimer?.cancel();
                  progressUpdateTimer = null;
                  allTasksCompleted.complete();
                }
              } else if (message is MapEntry<String, dynamic>) {
                // final t = [...tasks];
                // final v = 0;
                // failedTasks.add(message);
                tasks.add(message.value as (String url, String absPath));
                // final tt = [...tasks];
                // final vv = 0;
                if (tasks.isNotEmpty) {
                  final nextTask = tasks.removeAt(0);
                  // final e = message.key;
                  //
                  // final vvv = 0;
                  // Get the next URL from the list
                  sendPort.send(nextTask);
                }
              }
            },
          );
        }

        // Wait until all tasks are completed
        await allTasksCompleted.future;

        // Clean up all isolates
        for (final isolate in isolates) {
          isolate.kill(priority: Isolate.immediate);
        }

        // Close all stream queues
        for (final queue in streamQueues) {
          try {
            await queue.cancel(immediate: true);
          } catch (e) {}
        }
      } else {
        theState = await moviesController.updateHlsStatus(
          hls.iD,
          LocalHlsCompleteState(),
          where: 'download completed 318',
        );
      }
      late LocalHlsState resultState;
      if (theState == null) {
        for (var i = 0; i < 5 && theState == null; i++) {
          await Future.delayed(const Duration(milliseconds: 300), () {});
          resultState = hlsLocalRepository.fetchHlsState(hls);
          final v = 0;
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 1000), () {});
        resultState = hlsLocalRepository.fetchHlsState(hls);
        final v = 0;
      }

      // final spentTime = DateTime.now().difference(startTime).inMilliseconds;
      //
      // final v = 0;

      // /// ////////////////////////////////////
      _downloadingHls = null;
      _isolateRunning = false;
      if (resultState is LocalHlsErrorState) {
        await moviesController.updateHlsStatus(hls.iD, resultState,
          where: 'error state 332',
        );
        _stopDownloading();
        onError?.call(resultState);
      } else if (resultState is LocalHlsDeletedState) {
        _stopDownloading();
        moviesController.deleteHls(hls: hls);
      } else {
        _stopDownloading();
        await moviesController.updateHlsStatus(hls.iD, resultState,
          where: 'download provider 340',
        );
      }

      if (onDownloadComplete != null && resultState is LocalHlsCompleteState) {
        await onDownloadComplete.call(hls, ref);
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

  Future<LocalHlsState> getHlsDownloadStatusType({
    required String statusStoreKey,
    required double progress,
  }) async {
    final target = (await Prefs.getLocalHlsStatusNamee(statusStoreKey) ?? '')
        .getLocalHlsStatus!;

    switch (target) {
      case LocalHlsStatusType.error:
        return LocalHlsErrorState(
          progress: progress,
        );
      case LocalHlsStatusType.inQueue:
        return LocalHlsInQueueState(
          progress: progress,
        );
      case LocalHlsStatusType.paused:
        return LocalHlsPauseState(
          progress: progress,
        );
      case LocalHlsStatusType.complete:
        return LocalHlsCompleteState(
          progress: progress,
        );
      case LocalHlsStatusType.notExist:
        return LocalHlsNotExistState(
          progress: progress,
        );
      case LocalHlsStatusType.downloading:
        return LocalHlsDownloadingState(
          progress: progress,
        );
      case LocalHlsStatusType.deleted:
        return LocalHlsDeletedState(
          progress: progress,
        );
      case LocalHlsStatusType.prepared:
        return LocalHlsPreparedState(
          progress: progress,
        );
    }
  }
}


