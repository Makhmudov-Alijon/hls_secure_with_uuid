import 'dart:async';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:watcher/watcher.dart';

final localHlsMovieProvider = AutoDisposeNotifierProviderFamily<
    LocalHlsMovieNotifier, LocalHlsState, LocalHlsId>(
  LocalHlsMovieNotifier.new,
  dependencies: [
    // localHlsMoviesProvider,
  ],
);

class LocalHlsMovieNotifier
    extends AutoDisposeFamilyNotifier<LocalHlsState, LocalHlsId> {
  DirectoryWatcher? masterStream;
  StreamSubscription<WatchEvent>? masterStreamSub;
  LocalHlsModelIsar? currentHls;
  DownloadTask? downloadTask;
  int? sizeToDownload;

  HlsDownloaderNotifier get downloaderController => ref.read(
        hlsDownloaderProvider.notifier,
      );

  LocalHlsMoviesNotifier get moviesController => ref.read(
        localHlsMoviesProvider.notifier,
      );

  HlsDownloaderState get downloaderState => ref.read(hlsDownloaderProvider);

  void updateProgress(double progress, int threadsCount) {
    state = LocalHlsDownloadingState(
      // progress: 33
      threadsCount: threadsCount,
      progress: progress > 99 ? 99 : progress,
    );
  }

  void refresh() {
    state = checkState();
  }

  LocalHlsState checkState() {
    final foundHls = ref.read(localHlsMoviesProvider.notifier).hlsByIdd(arg);
    currentHls = foundHls;
    sizeToDownload ??= foundHls?.hlsDetails.sizeBytes;
    if (foundHls == null) {
      return LocalHlsNotExistState();
    }
    final r = foundHls.localHlsState;

    return r;
  }

  void pauseDownload() {
    if (currentHls != null) {
      downloaderController.pauseDownload(currentHls!);
    }
  }

  void cancelDownload() {
    if (currentHls != null) {
      if (state is LocalHlsDownloadingState) {
        downloaderController.cancelDownload(currentHls!);
      } else {
        moviesController.deleteHls(hls: currentHls!);
      }
    }
  }

  void tryContinueDownload({
    required Future<void> Function(LocalHlsModelIsar, Ref<Object?>)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) {
    if (currentHls != null) {
      downloaderController.tryToDownload(
        hls: currentHls!,
        onError: onError,
        downloadTask: downloadTask,
        onDownloadComplete: onDownloadComplete,
      );
    } else {
      final v = 0;
    }
  }

  @override
  LocalHlsState build(LocalHlsId arg) {
    return checkState();
  }
}
