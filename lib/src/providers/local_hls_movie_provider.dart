import 'dart:async';
import 'dart:developer';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:watcher/watcher.dart';

abstract class LocalHlsState {
  const LocalHlsState({this.progress = 0});
  final double progress;

  LocalHlsStatus toLocalHlsStatus() {
    switch (runtimeType) {
      case LocalHlsDownloadingState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.downloading,
        );
      case LocalHlsPauseState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.paused,
        );
      case LocalHlsDeletedState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.deleted,
        );
      case LocalHlsCompleteState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.complete,
        );
      case LocalHlsInQueueState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.inQueue,
        );
      case LocalHlsPreparedState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.prepared,
        );
      case LocalHlsErrorState:
        final error = this as LocalHlsErrorState;
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.error,
          message: error.message,
          statusCode: error.statusCode,
        );
      default:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.notExist,
        );
    }
  }
}

class LocalHlsDownloadingState extends LocalHlsState {
  LocalHlsDownloadingState({super.progress});
}

class LocalHlsErrorState extends LocalHlsState {
  LocalHlsErrorState({
    this.statusCode,
    this.message,
    super.progress,
  });

  final int? statusCode;
  final String? message;
}

class LocalHlsPauseState extends LocalHlsState {
  LocalHlsPauseState({super.progress});
}

class LocalHlsInQueueState extends LocalHlsState {
  LocalHlsInQueueState({super.progress});
}

class LocalHlsNotExistState extends LocalHlsState {
  LocalHlsNotExistState({super.progress});
}

class LocalHlsCompleteState extends LocalHlsState {
  LocalHlsCompleteState({super.progress});
}

class LocalHlsDeletedState extends LocalHlsState {
  LocalHlsDeletedState({super.progress});
}

class LocalHlsPreparedState extends LocalHlsState {
  LocalHlsPreparedState({super.progress});
}

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

  HlsDownloaderNotifier get downloaderController => ref.read(
        hlsDownloaderProvider.notifier,
      );

  LocalHlsMoviesNotifier get moviesController => ref.read(
        localHlsMoviesProvider.notifier,
      );

  void onFileEvent(WatchEvent event) {
    final newProgress = currentHls!.downloadProgress;
    if (state is LocalHlsDownloadingState) {
      final oldProgress = (state as LocalHlsDownloadingState).progress;
      if (newProgress != oldProgress) {
        state = LocalHlsDownloadingState(progress: newProgress);
      }
    }
  }

  void refresh() {
    state = checkState();
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

  LocalHlsState checkState() {
    ref.onDispose(_stopListenToProgress);
    final foundHls = ref.read(localHlsMoviesProvider.notifier).hlsById(arg);
    currentHls = foundHls;
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

  Future<void> continueDownload({
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
    return checkState();
  }
}
