import 'dart:async';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:download_manager/download_manager.dart';
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

  void addToQueue(LocalHlsModel hls) {
    moviesController.updateHlsStatuss(hls.id, LocalHlsInQueueState());
  }

  void pauseDownload(LocalHlsModel hls) {
    if (hls.id == _downloadingHls) {
      _stopDownloading();
    }
    moviesController.updateHlsStatuss(hls.id, LocalHlsPauseState());
  }

  void cancelDownload(LocalHlsModel hls) {
    moviesController.updateHlsStatuss(hls.id, LocalHlsDeletedState());
  }

  void tryToDownload({
    required LocalHlsModel hls,
    required DownloadTask? downloadTask,
    required void Function(LocalHlsErrorState error)? onError,
    required Future<void> Function(LocalHlsModel hls, Ref<Object?> ref)?
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
      }
    }
  }

  Future<void> prepareAndDownloadOrQueue({
    required MasterPlaylistModel masterPlaylist,
    required LocalHlsDetailsModel hlsDetails,
    required Future<void> Function(LocalHlsModel hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
    String? posterLink,
  }) async {
    final downloadTask = await ref.read(hlsRepositoryProvider).preparePlaylists(
          master: masterPlaylist,
          hlsDetails: hlsDetails,
          posterLink: posterLink,
        );
    final v = 0;
    if (downloadTask != null) {
      await moviesController.refreshMovies();
      final hls = moviesController.hlsById(hlsDetails.id);
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
          }
        }
      }
    }
  }

  Future<void> checkForNextQueue({
    required Future<void> Function(LocalHlsModel hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    final nextHls = await moviesController.findNextInQueue();
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

  double unDownloadedLength(int totalLength, int unDownloadedLength) {
    if (totalLength == 0) {
      return 0.0; // Avoid division by zero
    }

    // Calculate the downloaded length
    int downloadedLength = totalLength - unDownloadedLength;

    // Calculate the progress as a percentage
    double progress = (downloadedLength / totalLength);

    return progress;
  }

  Future<void> downloadOrContinue({
    required DownloadTask downloadTask,
    required LocalHlsModel hls,
    required Future<void> Function(LocalHlsModel hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    _startDownloading();
    _downloadingHls = hls.id;
    moviesController.updateHlsStatuss(hls.id, LocalHlsDownloadingState());
    try {
      _isolateRunning = true;

      final DateTime startTime = DateTime.now();
      // final resultState = await Isolate.run<LocalHlsState>(
      //   () {
      //     return downloadStartOldVersionn(
      //       downloadTask,
      //       hls,
      //
      //     );
      //     // return downloadStart(
      //     //   downloadTask,
      //     //   hls,
      //     // );
      //   },
      // );

      /// //////////////////////////////////////
      final tasks = [...downloadTask.items];
      List<DownloadItem> failedTasks = [];
      final int maxIsolates = 16;
      final List<Isolate> isolates = [];
      final List<StreamQueue<dynamic>> streamQueues = [];
      final Completer<void> allTasksCompleted = Completer<void>();

      int activeTasks = 0;

      // Create the isolates
      for (var i = 0; i < maxIsolates; i++) {
        final receivePort = ReceivePort();
        final isolate = await Isolate.spawn(downloadFile, receivePort.sendPort);
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

        // Listen for completion messages from each isolate
        streamQueue.rest.listen(
          (message) {
            if (message is String) {
              if (message == 'done' && tasks.isNotEmpty) {
                localHlsMovieController(hls.id).updateProgress(
                  unDownloadedLength(
                    downloadTask.items.length,
                    tasks.length + failedTasks.length,
                  ),
                );
                final nextTask =
                    tasks.removeAt(0); // Get the next URL from the list
                sendPort.send(nextTask); // Send the next URL to the isolate
              } else if (tasks.isEmpty) {
                sendPort.send(null); // Signal the isolate to terminate
                activeTasks--;

                if (activeTasks == 0) {
                  allTasksCompleted.complete();
                }
              }
            } else if (message is DownloadItem) {
              failedTasks.add(message);
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

      /// //////////////////////////////////////
      // final threadLimit = 8;
      // for (int i = 0; i < downloadTask.items.length; i += threadLimit) {
      //   final Iterable<DownloadItem> chunk =
      //   downloadTask.items.safeGetLimit(i, threadLimit);
      //   // await Future.delayed(Duration(milliseconds: 500));
      //   await Future.wait([
      //     for (final item in chunk) ...[
      //       Isolate.run<dynamic>(
      //             () {
      //           /// //////////////////////////////
      //           // return downloadItemHttp(
      //           //   (
      //           //     item: item,
      //           //     hls: hls,
      //           //   ),
      //           // );
      //           /// ///////////////////////////
      //           return downloadItem(
      //             (
      //             item: item,
      //             hls: hls,
      //             sendPort: receivePort.sendPort,
      //             ),
      //           );
      //
      //           /// /////////////////////////////
      //         },
      //       ),
      //     ],
      //   ]);
      // }
      /// /////////////////////////////////////////////////////
      moviesController.updateHlsStatuss(
          hls.id,
          failedTasks.isEmpty
              ? LocalHlsCompleteState()
              : LocalHlsErrorState(
                  message:
                      '${failedTasks.length} segments are not downloaded'));

      final hlsLocalRepository = HlsLocalRepository();
      final resultState = hlsLocalRepository.fetchHlsState(hls);

      final spentTime = DateTime.now().difference(startTime).inMilliseconds;
      final v = 0;

      // /// ////////////////////////////////////
      _downloadingHls = null;
      _isolateRunning = false;
      if (resultState is LocalHlsErrorState) {
        moviesController.updateHlsStatuss(hls.id, resultState);
        _stopDownloading();
        onError?.call(resultState);
      } else if (resultState is LocalHlsDeletedState) {
        _stopDownloading();
        moviesController.deleteHls(hls: hls);
      } else {
        _stopDownloading();
        moviesController.updateHlsStatuss(hls.id, resultState);
      }

      if (onDownloadComplete != null && resultState is LocalHlsCompleteState) {
        await onDownloadComplete.call(hls, ref);
      }
      await checkForNextQueue(
        onDownloadComplete: onDownloadComplete,
        onError: onError,
      );
    } catch (e) {
      _isolateRunning = false;
      _stopDownloading();
    }
  }

  static Future<LocalHlsState> downloadStart(
    DownloadTask task,
    LocalHlsModel hls, [
    void Function(double progress)? onProgressChanges,
  ]) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    final cancelToken = CancelToken();
    final hlsLocalRepository = HlsLocalRepository();

    var progress = 0.0;
    for (var i = 0; i < task.items.length; i++) {
      final item = task.items[i];
      final vv = !item.isDownloaded;
      final v = 0;
      if (!item.isDownloaded) {
        final receivePort = ReceivePort();
        await Isolate.spawn(
          downloadItem,
          (
            item: item,
            hls: hls,
            sendPort: receivePort.sendPort,
          ),
        );
        receivePort.listen((state) {
          print('//// dididing: $state ///////');
          final v = 0;
          if (state is LocalHlsState) {
            // return state as LocalHlsState;
          }
        });
      }
    }
    return LocalHlsCompleteState(
      progresss: progress,
    );
  }

  static Future<LocalHlsState> downloadStartOldVersionn(
    DownloadTask task,
    LocalHlsModel hlss, [
    void Function(double progress)? onProgressChanges,
  ]) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    final cancelToken = CancelToken();
    final hlsLocalRepository = HlsLocalRepository();

    var progress = 0.0;
    for (var i = 0; i < task.items.length; i++) {
      final item = task.items[i];
      if (!item.isDownloaded) {
        try {
          await dio.download(
            item.url,
            item.absolutePath,
            cancelToken: cancelToken,
            onReceiveProgress: (count, total) {
              progress = count / total;
              onProgressChanges?.call(progress);
              final state = hlsLocalRepository.fetchHlsState(hlss);
              if (state is LocalHlsPauseState ||
                  state is LocalHlsDeletedState) {
                cancelToken.cancel();
              }
            },
          );
        } catch (e) {
          if (e is DioException) {
            if (e.type == DioExceptionType.cancel) {
              final hlsState = hlsLocalRepository.fetchHlsState(hlss);
              return hlsState;
            }
            return LocalHlsErrorState(
              message: e.message,
              statusCode: e.response?.statusCode,
              progresss: progress,
            );
          }
          return LocalHlsErrorState(
            progresss: progress,
          );
        }
      }
    }
    return LocalHlsCompleteState(
      progresss: progress,
    );
  }
}

dynamic downloadItem(
    ({
      DownloadItem item,
      LocalHlsModel hls,
      SendPort sendPort,
    }) data) async {
  print('download started for: ${data.item.url.split(".")[2].split("/").last}');
  bool idf = true;
  do {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    final cancelToken = CancelToken();
    final hlsLocalRepositoryy = HlsLocalRepository();

    var progress = 0.0;
    final item = data.item;

    try {
      await dio.download(
        item.url,
        item.absolutePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          progress = count / total;
          final state = hlsLocalRepositoryy.fetchHlsState(data.hls);
          final v = 0;
          if (state is LocalHlsPauseState || state is LocalHlsDeletedState) {
            // closeFile(item.absolutePath);
            // cancelToken.cancel();
          }
        },
      );
      // closeFile(item.absolutePath);
      print(
          'download completed for: ${data.item.url.split(".")[2].split("/").last}');
      idf = false;
    } on DioException catch (e) {
      // Dio errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        idf = true;
      } else if (e.type == DioExceptionType.badResponse ||
          e.type == DioExceptionType.unknown) {
        print('Unexpected error occurred');
      } else if (e.type == DioExceptionType.cancel) {
        idf = false;
      } else {
        print('Unhandled DioException: ${e.message}');
      }
    } catch (e) {
      data.sendPort.send(item);
    }
  } while (idf);
}

// Function that will be run in each isolate to download a file
Future<void> downloadFile(SendPort sendPort) async {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  await for (var item in receivePort) {
    final v = item;
    final vv = 0;
    if (item == null) {
      break; // Exit loop and isolate when receiving a null value
    }
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    final cancelToken = CancelToken();
    final hlsLocalRepositoryy = HlsLocalRepository();

    print(' *** started for: ${item.url.split(".")[2].split("/").last}');
    try {
      await dio.download(
        item.url as String,
        item.absolutePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          // progress = count / total;
          // final state = hlsLocalRepositoryy.fetchHlsState(data.hls);
          // final v = 0;
          // if (state is LocalHlsPauseState || state is LocalHlsDeletedState) {
          //   closeFile(item.absolutePath);
          //   // cancelToken.cancel();
          // }
        },
      );
    } catch (e) {
      sendPort.send(item);
    }

    // Notify the main isolate that this task is done

    print(' *** done for: ${item.url.split(".")[2].split("/").last}');
    sendPort.send('done');
  }
}
