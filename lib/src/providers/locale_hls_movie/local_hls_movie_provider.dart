import 'dart:async';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/isar/download_task/download_task_repository_impl.dart';

final localHlsMovieProvider = AutoDisposeNotifierProviderFamily<
    LocalHlsMovieNotifier, LocalHlsState?, LocalHlsId>(
  LocalHlsMovieNotifier.new,
  dependencies: [
    localHlsMoviesProvider,
  ],
);

class LocalHlsMovieNotifier
    extends AutoDisposeFamilyNotifier<LocalHlsState?, LocalHlsId> {
  LocalHlsModelIsar? currentHls;
  int? sizeToDownload;

  HlsDownloaderNotifier get downloaderController => ref.read(
        hlsDownloaderProvider.notifier,
      );

  LocalHlsMoviesNotifier get moviesController => ref.read(
        localHlsMoviesProvider.notifier,
      );

  HlsDownloaderStatus get downloaderState =>
      ref.read(hlsDownloaderProvider).status;

  LocalHlsState? updateProgress(
      {required double progress, required double speed}) {
    if (state is LocalHlsDownloadingState) {
      state = LocalHlsDownloadingState(
        speed: speed,
        progress: progress > 99 ? 99 : progress,
      );
      return null;
    } else {
      return state;
    }
  }

  void refresh() {
    checkState().then((v) {
      _deactivate();
      state = v;
    }).onError((error, s) {
      _deactivate();
    });
  }

  Future<LocalHlsState> checkState() async {
    final foundHls =
        await ref.read(localHlsMoviesProvider.notifier).hlsById(arg);
    currentHls = foundHls;
    sizeToDownload ??= foundHls?.hlsDetails.sizeBytes;

    if (foundHls == null) {
      return LocalHlsNotExistState();
    }
    final downloadTask =
        await ref.read(downloadTaskIsarProvider).getById(foundHls.id);
    if (downloadTask == null) {
      return LocalHlsNotExistState();
    }
    final r = foundHls.localHlsState(progresss: downloadTask.getProgress);

    return r;
  }

  void _deactivate() {
    ref.read(downloadButtonSafetyProvider.notifier).deActivate();
  }

  Future<void> pauseDownload({bool isUpdate = true}) async {
    if (currentHls != null) {
      await downloaderController.pauseDownload(currentHls!, isUpdate: isUpdate);
      _deactivate();
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
        onDownloadComplete: onDownloadComplete,
      );
    }
  }

  @override
  LocalHlsState? build(LocalHlsId arg) {
    checkState().then((v) {
      state ??= v;
    });
    return null;
  }
}
