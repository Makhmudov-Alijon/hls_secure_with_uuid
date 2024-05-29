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
    moviesController.updateHlsStatus(hls.id, LocalHlsDownloadingState());
    try {
      _isolateRunning = true;
      final resultState = await Isolate.run<LocalHlsState>(
        () {
          return downloadStart(
            downloadTask,
            hls,
          );
        },
      );
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
      if (!item.isDownloaded) {
        try {
          await dio.download(
            item.url,
            item.absolutePath,
            cancelToken: cancelToken,
            onReceiveProgress: (count, total) {
              progress = count / total;
              onProgressChanges?.call(progress);
              final state = hlsLocalRepository.fetchHlsState(hls);
              if (state is LocalHlsPauseState ||
                  state is LocalHlsDeletedState) {
                cancelToken.cancel();
              }
            },
          );
        } catch (e) {
          if (e is DioException) {
            if (e.type == DioExceptionType.cancel) {
              final hlsState = hlsLocalRepository.fetchHlsState(hls);
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
