import 'dart:async';
import 'dart:isolate';

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

      // final DateTime startTime = DateTime.now();
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
      final hlsLocalRepository = HlsLocalRepository();
      await Future.wait([
        for (final item in downloadTask.items) ...[
          // final receivePort = ReceivePort();
          Isolate.run<dynamic>(
            () {
              return downloadItem(
                (
                  item: item,
                  hls: hls,
                  // sendPort: receivePort.sendPort,
                ),
              );
            },
          ),
          // receivePort.listen((state) {
          //   print('//// dididing: $state ///////');
          //   final v = 0;
          //   if (state is LocalHlsState) {
          //     // return state as LocalHlsState;
          //   }
          // });
        ],
      ]);
      moviesController.updateHlsStatuss(hls.id, LocalHlsCompleteState());
      final resultState = hlsLocalRepository.fetchHlsState(hls);

      // final spentTime = DateTime.now().difference(startTime).inMilliseconds;
      // final v = 0;

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
            // sendPort: receivePort.sendPort,
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
      progress: progress,
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

dynamic downloadItem(
    ({
      DownloadItem item,
      LocalHlsModel hls,
// SendPort sendPort,
    }) data) async {
  print('download started for: ${data.item.url.split(".")[2].split("/").last}');
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
          cancelToken.cancel();
        }
      },
    );

    print(
        'download completed for: ${data.item.url.split(".")[2].split("/").last}');
  } catch (e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.cancel) {
        final hlsState = hlsLocalRepositoryy.fetchHlsState(data.hls);
        // data.sendPort.send(hlsState);
      }
      // data.sendPort.send(
      //   LocalHlsErrorState(
      //     message: e.message,
      //     statusCode: e.response?.statusCode,
      //     progress: progress,
      //   ),
      // );
    }
    // data.sendPort.send(
    //   LocalHlsErrorState(
    //     progress: progress,
    //   ),
    // );
  }
}
