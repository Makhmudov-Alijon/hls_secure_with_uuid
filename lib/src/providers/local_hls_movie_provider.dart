import 'dart:async';
import 'dart:developer';

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
  LocalHlsModel? currentHls;
  DownloadTask? downloadTask;
  int? sizeToDownload;

  HlsDownloaderNotifier get downloaderController => ref.read(
        hlsDownloaderProvider.notifier,
      );

  LocalHlsMoviesNotifier get moviesController => ref.read(
        localHlsMoviesProvider.notifier,
      );

  HlsDownloaderState get downloaderState => ref.read(hlsDownloaderProvider);

  void updateProgress(double progress) {
    state = LocalHlsDownloadingState(
      // progress: 33
      progress: progress > 99 ? 99 : progress,
    );
  }

  void onFileEvent(WatchEvent event) {
    ///  it would be
    if (currentHls != null && sizeToDownload != null) {
      HlsUtils.getTotalDirectorySizee(currentHls!.masterDir).then(
        (value) {
          if (state is LocalHlsDownloadingState && value != null) {
            final progress = value / sizeToDownload!;
            state = LocalHlsDownloadingState(
              progress: progress > 99 ? 99 : progress,
            );
          }
        },
      );
    }
  }

  void refresh() {
    state = checkState();
  }

  void _startListenToProgress() {
    /// progress listener
    // log('start listen to ${currentHls?.hlsDetails.id} hls progress');
    // masterStream = DirectoryWatcher(currentHls!.masterDir.path);
    // masterStreamSub = masterStream?.events.listen(onFileEvent);
  }

  void _stopListenToProgress() {
    // if (masterStreamSub != null) {
    //   log('stop listen to ${currentHls?.hlsDetails.id} hls progress');
    // }
    // masterStreamSub?.cancel();
    // masterStreamSub = null;
    // masterStream = null;
  }

  LocalHlsState checkState() {
    ref.onDispose(_stopListenToProgress);
    final foundHls = ref.read(localHlsMoviesProvider.notifier).hlsById(arg);
    currentHls = foundHls;
    sizeToDownload ??= foundHls?.hlsDetails.sizeBytes;
    if (foundHls == null) {
      _stopListenToProgress();
      return LocalHlsNotExistState();
    } else if (foundHls.localHlsState is LocalHlsDownloadingState) {
      _startListenToProgress();
    } else {
      _stopListenToProgress();
    }
    return foundHls.localHlsState;
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
    required Future<void> Function(LocalHlsModel, Ref<Object?>)?
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
    }
  }

  @override
  LocalHlsState build(LocalHlsId arg) {
    return checkState();
  }
}
