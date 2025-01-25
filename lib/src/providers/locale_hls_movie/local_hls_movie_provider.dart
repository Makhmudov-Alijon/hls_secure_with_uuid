import 'dart:async';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/isar/download_task/download_task_repository_impl.dart';

final localHlsMovieProviderr = AutoDisposeAsyncNotifierProviderFamily<
    LocalHlsMovieNotifier, LocalHlsState, LocalHlsId>(
  LocalHlsMovieNotifier.new,
  dependencies: [
    localHlsMoviesProvider,
  ],
);

class LocalHlsMovieNotifier
    extends AutoDisposeFamilyAsyncNotifier<LocalHlsState, LocalHlsId> {
  LocalHlsModelIsar? currentHls;
  int? sizeToDownloadd;

  HlsDownloaderNotifier get downloaderController => ref.read(
        hlsDownloaderProvider.notifier,
      );

  LocalHlsMoviesNotifier get moviesController => ref.read(
        localHlsMoviesProvider.notifier,
      );

  HlsDownloaderState get downloaderState => ref.read(hlsDownloaderProvider);



  void updateProgress({required double progress, required double speed}) {
    state =  AsyncData(
      LocalHlsDownloadingState(
        speed: speed,
        progress: progress > 99 ? 99 : progress,
      ),
    );
  }

  void refresh() {
    checkState().then((v) {
      state = AsyncData(v);
    });
  }

  Future<LocalHlsState> checkState() async {
    final foundHls =
        await ref.read(localHlsMoviesProvider.notifier).hlsById(arg);
    currentHls = foundHls;
    sizeToDownloadd ??= foundHls?.hlsDetails.sizeBytes;

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

  Future<void> pauseDownload( {bool isUpdate = true})async {
    if (currentHls != null) {
     await downloaderController.pauseDownload(currentHls!,isUpdate: isUpdate);
    } else {
      final v = 0;
    }
  }

  void cancelDownload() {
    if (currentHls != null) {
      if (state.value is LocalHlsDownloadingState) {
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
    } else {
      final v = 0;
    }
  }

  @override
  FutureOr<LocalHlsState> build(LocalHlsId arg) {
    return checkState();
  }

// @override
// LocalHlsState build(LocalHlsId arg) {
//   // return checkState();
// }
}
