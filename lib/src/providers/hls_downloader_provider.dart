import 'dart:async';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:download_manager/download_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
    moviesController.updateHlsStatus(hls.id, LocalHlsInQueueState());
  }

  void pauseDownload(LocalHlsModel hls) {
    if (hls.id == _downloadingHls) {
      _stopDownloading();
    }
    moviesController.updateHlsStatus(hls.id, LocalHlsPauseState());
  }

  void cancelDownload(LocalHlsModel hls) {
    moviesController.updateHlsStatus(hls.id, LocalHlsDeletedState());
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

  Future<void> downloadOrContinue({
    required DownloadTask downloadTask,
    required LocalHlsModel hls,
    required Future<void> Function(LocalHlsModel hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    _startDownloading();
    _downloadingHls = hls.id;
    moviesController.updateHlsStatus(hls.id, LocalHlsDownloadingState());
    try {
      _isolateRunning = true;

      final DateTime startTime = DateTime.now();

      List<DownloadItem> tasks = [
        ...downloadTask.items.where((e) => !e.isDownloaded),
      ];
      List<MapEntry<String, dynamic>> failedTasks = [];

      final hlsLocalRepository = HlsLocalRepository();
      if (tasks.isNotEmpty) {
        final int maxIsolates = Platform.isIOS ? 2 : 8;
        final List<Isolate> isolates = [];
        final List<StreamQueue<dynamic>> streamQueues = [];
        final Completer<void> allTasksCompleted = Completer<void>();
        LocalHlsState? localHlsState;

        int activeTasks = 0;

        // Create the isolates
        for (var i = 0; i < maxIsolates; i++) {
          final receivePort = ReceivePort();
          // final isolate = await Isolate.spawn(downloadFile, receivePort.sendPort);
          final isolate =
              await Isolate.spawn(downloadFileHttp, receivePort.sendPort);
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
                if (message == 'done') {
                  final state = hlsLocalRepository.fetchHlsState(hls);
                  if (state is LocalHlsPauseState ||
                      state is LocalHlsDeletedState) {
                    localHlsState = state;
                    sendPort.send(null);
                    activeTasks--;
                  }
                  if (tasks.isNotEmpty) {
                    localHlsMovieController(hls.id).updateProgress(
                      calculateProgress(
                        downloadTask.items.length,
                        tasks.length + failedTasks.length,
                      ),
                    );

                    final nextTask =
                        tasks.removeAt(0); // Get the next URL from the list
                    sendPort.send(nextTask);
                  } else {
                    sendPort.send(null); // Signal the isolate to terminate
                    activeTasks--;
                  } // Send the next URL to the isolate
                }

                if (activeTasks == 0) {
                  moviesController.updateHlsStatus(
                    hls.id,
                    // hlsState,
                    localHlsState ??
                        (failedTasks.isEmpty
                            ? LocalHlsCompleteState()
                            : LocalHlsErrorState(
                                message:
                                    '${failedTasks.length} segments are not downloaded',
                              )),
                  );
                  allTasksCompleted.complete();
                }
              } else if (message is MapEntry<String, dynamic>) {
                failedTasks.add(message);
                if (tasks.isNotEmpty) {
                  final nextTask =
                      tasks.removeAt(0); // Get the next URL from the list
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
        moviesController.updateHlsStatus(
          hls.id,
          LocalHlsCompleteState(),
        );
      }

      final resultState = hlsLocalRepository.fetchHlsState(hls);

      final spentTime = DateTime.now().difference(startTime).inMilliseconds;

      final v = 0;

      // /// ////////////////////////////////////
      _downloadingHls = null;
      _isolateRunning = false;
      if (resultState is LocalHlsErrorState) {
        moviesController.updateHlsStatus(hls.id, resultState);
        _stopDownloading();
        onError?.call(resultState);
      } else if (resultState is LocalHlsDeletedState) {
        _stopDownloading();
        moviesController.deleteHls(hls: hls);
      } else {
        _stopDownloading();
        moviesController.updateHlsStatus(hls.id, resultState);
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
              progress: progress,
            );
          }
          return LocalHlsErrorState(
            progress: progress,
          );
        }
      }
    }
    return LocalHlsCompleteState(
      progress: progress,
    );
  }
}

// Function that will be run in each isolate to download a file
Future<void> downloadFileDio(SendPort sendPort) async {
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

    // print(' *** started for: ${item.url.split(".")[2].split("/").last}');
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

    // print(' *** done for: ${item.url.split(".")[2].split("/").last}');
    sendPort.send('done');
  }
}

Future<void> downloadFileHttp(SendPort sendPort) async {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  await for (final item in receivePort) {
    if (item is! DownloadItem) {
      break; // Exit loop and isolate when receiving a null value
    }

    // print(' *** started for: ${item.url.split(".")[2].split("/").last}');

    try {
      final response = await http.get(Uri.parse(item.url));

      if (response.statusCode == 200) {
        // final file = File(item.absolutePath as String);
        // await file.writeAsBytes(response.bodyBytes);
        // print(' *** done for: ${item.url.split(".")[2].split("/").last}');
        final file = File(item.absolutePath);

        // Open the file for writing
        final randomAccessFile = await file.open(mode: FileMode.write);

        // Write the downloaded bytes to the file
        await randomAccessFile.writeFrom(response.bodyBytes);

        // Close the file
        await randomAccessFile.close();
      } else {
        // print('Failed to download ${item.url}: ${response.statusCode}');
        sendPort.send(MapEntry(response.reasonPhrase ?? 'Reason is null',
            item)); // Re-send the item for retry
      }
    } catch (e) {
      // print('Error downloading ${item.url}: $e');
      sendPort.send(MapEntry(e.toString(), item)); // Re-send the item for retry
    }

    // Notify the main isolate that this task is done
    sendPort.send('done');
  }
}
