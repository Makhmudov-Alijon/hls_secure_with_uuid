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

  void changeState(HlsDownloaderState state) {
    this.state = state;
  }

  void addToQueue(LocalHlsModel localHls) {
    ref.read(localHlsMoviesProvider.notifier).updateHlsStatus(
          localHls.id,
          LocalHlsInQueueState(),
        );
  }

  Future<void> downloadOrEnqueue({
    required MasterPlaylistModel masterPlaylist,
    required LocalHlsDetailsModel hlsDetails,
    FutureOr<void> Function(LocalHlsModel hls)? onDownloadComplete,
    String? posterLink,
  }) async {
    final downloadTask =
        await ref.read(hlsRepositoryProvider).downloadPlaylists(
              isSomeHlsIsLoading: () => state == HlsDownloaderState.downloading,
              master: masterPlaylist,
              hlsDetails: hlsDetails,
              posterLink: posterLink,
            );
    await ref.read(localHlsMoviesProvider.notifier).refreshMovies();
    ref.invalidate(localHlsMovieProvider(hlsDetails.id));
    final hls =
        ref.read(localHlsMoviesProvider.notifier).hlsById(hlsDetails.id);
    if (downloadTask == null || hls == null) {
      throw Exception('Something went wrong!');
    } else {
      if (state == HlsDownloaderState.downloading) {
        addToQueue(hls);
      } else {
        changeState(HlsDownloaderState.downloading);
        await downloadOrContinue(
          downloadTask: downloadTask,
          hls: hls,
          onDownloadComplete: onDownloadComplete,
        );
      }
    }
  }

  Future<void> pauseDownload(LocalHlsModel hls) async {
    changeState(HlsDownloaderState.notDownloading);
    ref.read(localHlsMoviesProvider.notifier).updateHlsStatus(
          hls.id,
          LocalHlsPauseState(
            progress: hls.downloadProgress,
          ),
        );
  }

  Future<void> cancelDownloadAndDelete(LocalHlsModel hls) async {
    changeState(HlsDownloaderState.notDownloading);
    ref.read(localHlsMoviesProvider.notifier).updateHlsStatus(
          hls.id,
          LocalHlsDeletedState(),
        );
  }

  Future<void> checkForNextQueue() async {
    final nextHls =
        await ref.read(localHlsMoviesProvider.notifier).findNextInQueue();
    if (nextHls != null) {
      if (nextHls.downloadTasksFile.existsSync()) {
        final downloadTask = DownloadTask.fromFile(nextHls.downloadTasksFile);
        unawaited(
          downloadOrContinue(downloadTask: downloadTask, hls: nextHls),
        );
      }
    }
  }

  Future<void> downloadOrContinue({
    required DownloadTask downloadTask,
    required LocalHlsModel hls,
    FutureOr<void> Function(LocalHlsModel hls)? onDownloadComplete,
  }) async {
    changeState(HlsDownloaderState.downloading);
    ref.read(localHlsMoviesProvider.notifier).updateHlsStatus(
          hls.id,
          LocalHlsDownloadingState(
            progress: hls.downloadProgress,
          ),
        );
    final resultState = await Isolate.run<LocalHlsState>(
      () {
        return downloadStart(
          downloadTask,
          hls,
        );
      },
    );
    changeState(HlsDownloaderState.notDownloading);
    ref
        .read(localHlsMoviesProvider.notifier)
        .updateHlsStatus(hls.id, resultState);
    if (resultState is LocalHlsErrorState) {
      throw Exception('Something went wrong!');
    } else if (resultState is LocalHlsDeletedState) {
      ref.read(localHlsMoviesProvider.notifier).deleteHls(hls: hls);
    } else if (resultState is LocalHlsCompleteState) {
      onDownloadComplete?.call(hls);
    }
    await ref.read(localHlsMoviesProvider.notifier).refreshMovies();
    unawaited(checkForNextQueue());
  }

  static Future<LocalHlsState> downloadStart(
      DownloadTask task, LocalHlsModel hls,
      [void Function(double progress)? onProgressChanges]) async {
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
