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

class LocalHlsDisableState extends LocalHlsState {
  LocalHlsDisableState({super.progress});
}

class LocalHlsCompleteState extends LocalHlsState {
  LocalHlsCompleteState({super.progress});
}

class LocalHlsDeletedState extends LocalHlsState {
  LocalHlsDeletedState({super.progress});
}

final localHlsMovieProvider = AutoDisposeNotifierProviderFamily<
    LocalHlsMovieNotifier, LocalHlsState, LocalHlsId>(
  LocalHlsMovieNotifier.new,
);

class LocalHlsMovieNotifier
    extends AutoDisposeFamilyNotifier<LocalHlsState, LocalHlsId> {
  DirectoryWatcher? masterStream;
  StreamSubscription<WatchEvent>? masterStreamSub;
  LocalHlsModel? currentHls;

  void onFileEvent(WatchEvent event) {
    final newProgress = currentHls!.downloadProgress;
    if (state is LocalHlsDownloadingState) {
      final oldProgress = (state as LocalHlsDownloadingState).progress;
      if (newProgress != oldProgress) {
        state = LocalHlsDownloadingState(progress: newProgress);
      }
    }
  }

  void resetAll() {
    masterStream = null;
  }

  void onDispose() {
    stopListenToChanges();
  }

  void startListenToChanges() {
    log('start listen to ${currentHls?.hlsDetails.id} hls');

    masterStream = DirectoryWatcher(currentHls!.masterDir.path);

    masterStreamSub = masterStream?.events.listen(onFileEvent);
  }

  void stopListenToChanges() {
    log('stop listen to ${currentHls?.hlsDetails.id} hls');
    masterStreamSub?.cancel();
    resetAll();
  }

  LocalHlsState checkState() {
    ref.onDispose(onDispose);
    final foundHls = ref.read(localHlsMoviesProvider.notifier).hlsById(arg);
    currentHls = foundHls;
    if (foundHls == null) {
      stopListenToChanges();
      return LocalHlsDisableState();
    } else if (foundHls.localHlsState is LocalHlsDownloadingState) {
      startListenToChanges();
    } else {
      stopListenToChanges();
    }
    return foundHls.localHlsState;
  }

  Future<void> pauseDownload() async {
    if (currentHls != null) {
      stopListenToChanges();
      await ref.read(hlsDownloaderProvider.notifier).pauseDownload(currentHls!);
    }
  }

  Future<void> continueDownload() async {
    if (currentHls != null) {
      if (ref.read(hlsDownloaderProvider) != HlsDownloaderState.downloading) {
        startListenToChanges();
        final downloadTask =
            DownloadTask.fromFile(currentHls!.downloadTasksFile);
        ref.read(localHlsMoviesProvider.notifier).updateHlsStatus(
              currentHls!.id,
              LocalHlsDownloadingState(
                progress: currentHls!.downloadProgress,
              ),
            );
        ref.invalidateSelf();
        await ref.read(hlsDownloaderProvider.notifier).downloadOrContinue(
              downloadTask: downloadTask,
              hls: currentHls!,
            );
      }
    } else {
      ref
          .read(localHlsMoviesProvider.notifier)
          .updateHlsStatus(currentHls!.id, LocalHlsInQueueState());
    }
  }

  Future<void> cancelDownload() async {
    if (currentHls != null) {
      stopListenToChanges();
      final currentState = currentHls!.localHlsState;
      if (currentState is LocalHlsDownloadingState) {
        await ref
            .read(hlsDownloaderProvider.notifier)
            .cancelDownloadAndDelete(currentHls!);
      } else if (currentState is LocalHlsPauseState ||
          currentState is LocalHlsErrorState ||
          currentState is LocalHlsInQueueState) {
        ref.read(localHlsMoviesProvider.notifier).deleteHls(currentHls!);
      }
    }
  }

  @override
  LocalHlsState build(LocalHlsId arg) {
    return checkState();
  }
}
