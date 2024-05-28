import 'dart:async';
import 'dart:developer';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:watcher/watcher.dart';

final localHlsMovieProvider = AutoDisposeNotifierProviderFamily<
    LocalHlsMovieNotifier, LocalHlsState, LocalHlsId>(
  LocalHlsMovieNotifier.new,
  dependencies: [
    localHlsMoviesProvider,
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

  void onFileEvent(WatchEvent event) {
    if (currentHls != null && sizeToDownload != null) {
      HlsUtils.getTotalDirectorySize(currentHls!.masterDir).then(
        (value) {
          if (state is LocalHlsDownloadingState) {
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
    state = checkState(state);
  }

  void _startListenToProgress() {
    log('start listen to ${currentHls?.hlsDetails.id} hls progress');
    masterStream = DirectoryWatcher(currentHls!.masterDir.path);
    masterStreamSub = masterStream?.events.listen(onFileEvent);
  }

  void _stopListenToProgress() {
    if (masterStreamSub != null) {
      log('stop listen to ${currentHls?.hlsDetails.id} hls progress');
    }
    masterStreamSub?.cancel();
    masterStreamSub = null;
    masterStream = null;
  }

  LocalHlsState checkState(LocalHlsState? oldState) {
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
    if (oldState != null) {
      return foundHls.localHlsState.copyWith(
        progress: oldState.progress,
      );
    }
    return foundHls.localHlsState;
  }

  void pauseDownload() {
    if (currentHls != null) {
      downloaderController.pauseDownload(currentHls!);
    }
  }

  void tryToContinue({
    required Future<void> Function(LocalHlsModel hls, Ref ref)?
        onDownloadComplete,
  }) {
    if (currentHls != null) {
      log('current downloader state: $downloaderState');
      if (downloaderState == HlsDownloaderState.downloading) {
        downloaderController.addToQueue(currentHls!);
      } else {
        _continueDownload(onDownloadComplete: onDownloadComplete);
      }
    }
  }

  Future<void> _continueDownload({
    required Future<void> Function(LocalHlsModel hls, Ref ref)?
        onDownloadComplete,
  }) async {
    if (currentHls != null) {
      final downloadTaskFile = currentHls!.downloadTasksFile;
      if (downloadTask == null && downloadTaskFile.existsSync()) {
        downloadTask = DownloadTask.fromFile(downloadTaskFile);
      }
      if (downloadTask != null) {
        await downloaderController.downloadOrContinue(
          downloadTask: downloadTask!,
          hls: currentHls!,
          onDownloadComplete: onDownloadComplete,
        );
      }
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

  @override
  LocalHlsState build(LocalHlsId arg) {
    return checkState(null);
  }
}
