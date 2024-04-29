import 'dart:async';
import 'dart:developer';


import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:watcher/watcher.dart';

import '../models/download_task_model/download_task_model.dart';
import '../models/local_hls_model/local_hls_id.dart';
import '../models/local_hls_model/local_hls_model.dart';
import '../models/local_hls_model/local_hls_status.dart';
import 'hls_downloader_provider.dart';
import 'local_hls_movies_provider.dart';

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
  LocalHlsPauseState({double progress = 0}) : super(progress: progress);
}

class LocalHlsInQueueState extends LocalHlsState {
  LocalHlsInQueueState({double progress = 0}) : super(progress: progress);
}

class LocalHlsDisableState extends LocalHlsState {
  LocalHlsDisableState({double progress = 0}) : super(progress: progress);
}

class LocalHlsCompleteState extends LocalHlsState {
  LocalHlsCompleteState({double progress = 0}) : super(progress: progress);
}

class LocalHlsDeletedState extends LocalHlsState {
  LocalHlsDeletedState({double progress = 0}) : super(progress: progress);
}

final localHlsMovieProvider = AutoDisposeNotifierProviderFamily<
    LocalHlsMovieNotifier, LocalHlsState, LocalHlsId>(
  () => LocalHlsMovieNotifier(),
);

class LocalHlsMovieNotifier
    extends AutoDisposeFamilyNotifier<LocalHlsState, LocalHlsId> {
  DirectoryWatcher? videoStream;
  DirectoryWatcher? audioStream;
  StreamSubscription<WatchEvent>? videoStreamSub;
  StreamSubscription<WatchEvent>? audioStreamSub;
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
    videoStream = null;
    audioStream = null;
  }

  void startListenToChanges() {
    log("start listen to ${currentHls?.hlsDetails.id} hls");

    videoStream = DirectoryWatcher(currentHls!.videoDir.path);
    audioStream = DirectoryWatcher(currentHls!.audioDir.path);

    videoStreamSub = videoStream?.events.listen(onFileEvent);
    audioStreamSub = audioStream?.events.listen(onFileEvent);
  }

  void stopListenToChanges() {
    log("stop listen to ${currentHls?.hlsDetails.id} hls");
    videoStreamSub?.cancel();
    audioStreamSub?.cancel();
    resetAll();
  }

  LocalHlsState checkState() {
    ref.onDispose(stopListenToChanges);
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

  Future<void> pauseDownload([double progress = 0]) async {
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
        ref
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
