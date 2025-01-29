import 'dart:async';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../repository/isar/download_task/download_task_repository_impl.dart';
import '../../../repository/isar/locale_hls_store/locale_hls_store_repository_impl.dart';
import '../datas/datas.dart';
import '../top_level_functions/download.dart';

part 'hls_dowloader_state.dart';

final hlsDownloaderProvider =
    NotifierProvider<HlsDownloaderNotifier, HlsDownloaderState>(
  HlsDownloaderNotifier.new,
);

class HlsDownloaderNotifier extends Notifier<HlsDownloaderState> {
  void updateState(HlsDownloaderState v) {
    state = v;
  }

  @override
  HlsDownloaderState build() {
    return const HlsDownloaderState();
  }

  bool _isolateRunning = false;

  LocalHlsId? _downloadingHls;

  LocalHlsMoviesNotifier get moviesController => ref.read(
        localHlsMoviesProvider.notifier,
      );

  LocalHlsMovieNotifier localHlsMovieController(LocalHlsId hlsId) => ref.read(
        localHlsMovieProvider(hlsId).notifier,
      );

  Future<bool> isSpaceAvailablee(int bytes) async {
    final info = await ref.read(diskSpaceInfoProvider.notifier).checkState();
    return info.isAvailable(bytes);
  }

  void _startDownloading({required String where}) {
    if (state.status == HlsDownloaderStatus.notDownloading) {
      updateState(state.copyWith(status: HlsDownloaderStatus.downloading));
    }
  }

  void _stopDownloading({required String where}) {
    if (state.status == HlsDownloaderStatus.downloading) {
      updateState(
        state.copyWith(
          status: HlsDownloaderStatus.notDownloading,
        ),
      );
    }
  }

  Future<void> addToQueue(LocalHlsModelIsar hls) async {
    await moviesController.updateHlsStatus(
      hls.id,
      LocalHlsInQueueState(),
      where: 'add to queue 53',
    );
  }

  Future<void> pauseDownload(
    LocalHlsModelIsar hls, {
    bool isUpdate = true,
  }) async {
    if (hls.iD == _downloadingHls) {
      _stopDownloading(where: 'pause download');
    }
    if (isUpdate) {
      await moviesController.updateHlsStatus(
        hls.id,
        LocalHlsPauseState(),
        where: 'pause download 60',
      );
    }
  }

  void cancelDownload(LocalHlsModelIsar hls) {
    moviesController.updateHlsStatus(
      hls.id,
      LocalHlsDeletedState(),
      where: 'cancel download 64',
    );
  }

  void tryToDownload({
    required LocalHlsModelIsar hls,
    required void Function(LocalHlsErrorState error)? onError,
    required Future<void> Function(LocalHlsModelIsar hls, Ref<Object?> ref)?
        onDownloadComplete,
  }) async {
    if (state.status == HlsDownloaderStatus.downloading) {
      await addToQueue(hls);
    } else {
      final downloadTask = await ref.read(downloadTaskIsarProvider).getById(
            hls.id,
          );
      if (downloadTask != null) {
        final available = await isSpaceAvailablee(downloadTask.remainingBytes);
        if (available) {
          await downloadOrContinue(
            downloadTask: downloadTask,
            hls: hls,
            onDownloadComplete: onDownloadComplete,
            onError: onError,
          );
        } else {
          updateState(
            state.copyWith(
              noSpace: hls.iD,
            ),
          );
        }
      }
    }
  }

  /// point
  Future<void> prepareAndDownloadOrQueue({
    required MasterPlaylistModel masterPlaylist,
    required LocalHlsDetailsModel hlsDetails,
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
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
      var hls = await moviesController.hlsById(
        hlsDetails.localHlsId,
      );


      if (hls != null) {
        if (state.status == HlsDownloaderStatus.downloading ||
            _isolateRunning) {
          await addToQueue(hls);
        } else {
          if (!_isolateRunning) {
            final available =
                await isSpaceAvailablee(downloadTask.remainingBytes);
            if (available) {
              await downloadOrContinue(
                downloadTask: downloadTask,
                hls: hls,
                onDownloadComplete: onDownloadComplete,
                onError: onError,
              );
            } else {
              updateState(
                state.copyWith(
                  noSpace: hls.iD,
                ),
              );
              return;
            }
          }
        }
      }
    }
  }

  Future<void> checkForNextQueue({
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
    required String where,
  }) async {
    final nextHls = await moviesController.findNextInQueue(where: where);

    if (nextHls != null) {
      final downloadTask = await ref.read(downloadTaskIsarProvider).getById(
            nextHls.id,
          );

      if (downloadTask != null) {
        final available = await isSpaceAvailablee(downloadTask.remainingBytes);
        if (available) {
          await downloadOrContinue(
            downloadTask: downloadTask,
            hls: nextHls,
            onDownloadComplete: onDownloadComplete,
            onError: onError,
          );
        } else {
          updateState(
            state.copyWith(
              noSpace: nextHls.iD,
            ),
          );
        }
      } else {
        ref.read(downloadButtonSafetyProvider.notifier).deActivate();
      }
    }
  }

  /// ///////////////////////
  /// ///////////////////////
  ///     DOWNLOAD OR CONTINUE /////
  /// ///////////////////////
  /// ///////////////////////

  Timer? progressUpdateTimer;

  Future<void> downloadOrContinue({
    required DownloadTask downloadTask,
    required LocalHlsModelIsar hls,
    required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
        onDownloadComplete,
    required void Function(LocalHlsErrorState error)? onError,
  }) async {
    DateTime startTime = DateTime.now();
    _startDownloading(where: 'line 222 ${startTime}');
    _downloadingHls = hls.iD;
    LocalHlsModelIsar? theTarget = await moviesController.updateHlsStatus(
      hls.id,
      LocalHlsDownloadingState(),
      where: 'start downloading 168 ',
    );
    SendPort? isolateSendPort;
    Isolate? theIsolate;
    ReceivePort? thePort;
    late LocalHlsState resultState;
    int? downloadedBytes;
    void dispose() {
      progressUpdateTimer?.cancel();
      progressUpdateTimer = null;

      _downloadingHls = null;
      _isolateRunning = false;
      thePort?.close();
      thePort = null;
      theIsolate?.kill(priority: Isolate.immediate);
      theIsolate = null;
    }

    try {
      final tasks = Map<String, String>.fromEntries(
        downloadTask.items.where((e) => !e.isDownloaded).map(
              (e) => e.getForIsolateMap,
            ),
      );

      final preloadedTasksCount = downloadTask.items.length - tasks.length;

      final allTasksCompleted = Completer<void>();
      if (tasks.isNotEmpty) {
        thePort = ReceivePort();
        var count = 0;

        void checkState() {
          final check =
              ref.read(localeHlsIsarProvider).getHlsDownloadStatusType(
                    hlsId: hls.id,
                  );

          if (check is LocalHlsWaitingForNetworkState) {
            isolateSendPort?.send(DM.waitForNetwork);
          } else if (check is LocalHlsPauseState) {
            isolateSendPort?.send(DM.goBack);
          } else if (check is LocalHlsDeletedState) {
            isolateSendPort?.send(DM.deleted);
          }
        }

        void updateProgressAndSpeed((int, double) data) {
          if (state.status != HlsDownloaderStatus.downloading) {
            print(
                '>< >< not downloading : ${hls.iD} isolate port is null ${isolateSendPort == null}');

            isolateSendPort?.send(LocalHlsPauseState());

            return;
          }
          var progress = (downloadTask.downloadedBytes + data.$1) /
              downloadTask.totalBytes;

          if (progress > .98) {
            final theCount = count + preloadedTasksCount;
            if (theCount < downloadTask.items.length) {
              progress = .98;
            } else if (theCount == downloadTask.items.length) {
              progress = 1;
            }
          }
          final result = localHlsMovieController(hls.iD).updateProgress(
            progress: progress,
            speed: data.$2,
          );
          if (result != null) {
            print('>< >< update progress : ${result.runtimeType}');
            isolateSendPort?.send(result);
          }

          downloadedBytes = data.$1;
        }

        void _timer(Timer timer) {
          checkState();
          if (state.status != HlsDownloaderStatus.downloading) {
            timer.cancel();
            progressUpdateTimer?.cancel();
            progressUpdateTimer = null;
          }
        }

        progressUpdateTimer = Timer.periodic(
          const Duration(milliseconds: 300),
          _timer,
        );

        theIsolate = await Isolate.spawn(
          downloadWithDioAndWatchTheProgress,
          DownloadFullTask2(
            tasks: tasks,
            sendPort: thePort!.sendPort,
          ),
        );

        thePort!.listen(
          (message) async {
            if (message is LocalHlsState) {
              resultState =
                  count + preloadedTasksCount == downloadTask.items.length
                      ? LocalHlsCompleteState()
                      : message;
              try {
                if (!allTasksCompleted.isCompleted) {
                  allTasksCompleted.complete();
                } else {
                  final v = 0;
                }
              } catch (e) {
                print('<>< ><> complete exception doneFull : $e ');
              }
              return;
            }
            if (message is (int, int)) {
              downloadedBytes = message.$2;
              resultState =
                  count + preloadedTasksCount == downloadTask.items.length
                      ? LocalHlsCompleteState()
                      : LocalHlsErrorState();
              try {
                if (!allTasksCompleted.isCompleted) {
                  allTasksCompleted.complete();
                } else {
                  final v = 0;
                }
              } catch (e) {
                print('<>< ><> complete exception doneFull : $e ');
              }
              return;
            }
            if (message is SendPort) {
              isolateSendPort = message;
              return;
            }
            if (message is (int, double)) {
              updateProgressAndSpeed(message);
              return;
            }
            if (message is int) {
              switch (message) {
                case DM.deleted:
                case DM.error:
                case DM.goBack:
                case DM.waitForNetwork:
                  {
                    if (message == DM.deleted) {
                      resultState = LocalHlsDeletedState();
                    } else {
                      resultState = count + preloadedTasksCount ==
                              downloadTask.items.length
                          ? LocalHlsCompleteState()
                          : message == DM.waitForNetwork
                              ? LocalHlsWaitingForNetworkState()
                              : (message == DM.error
                                  ? LocalHlsErrorState()
                                  : LocalHlsPauseState());
                    }

                    try {
                      if (!allTasksCompleted.isCompleted) {
                        allTasksCompleted.complete();
                      }
                    } catch (e) {
                      print('<>< ><> complete exception : $e');
                    }

                    break;
                  }
                case DM.doneFor:
                  {
                    count++;
                    if(count + preloadedTasksCount == downloadTask.items.length){
                      isolateSendPort?.send(DM.doneFull);
                    }



                    break;
                  }
              }
            }
          },
        );
      } else {
        resultState = LocalHlsCompleteState();
        allTasksCompleted.complete();
      }

      await allTasksCompleted.future;
      ref
          .read(downloadButtonSafetyProvider.notifier)
          .activate(hls.iD, where: 'download provider 416');
      dispose();
      _stopDownloading(where: 'line 414');
      if (downloadedBytes != null) {
         await ref.read(downloadTaskIsarProvider).updateDownloadedSize(hls.id,
            downloadedSize: downloadedBytes! + downloadTask.downloadedBytes);
      } else {
        print('>< >< downloadedBytes is null : ${downloadedBytes}');
      }

      theTarget = await moviesController.updateHlsStatus(
        hls.id,
        resultState,
        where: 'after download complete 402',
      );

      if (resultState is LocalHlsErrorState) {
        onError?.call(LocalHlsErrorState());
      } else if (resultState is LocalHlsDeletedState) {
        await moviesController.deleteHls(hls: hls);
      } else if (resultState is LocalHlsWaitingForNetworkState) {
        return;
      } else {
        _stopDownloading(where: 'line 417');
      }

      if (onDownloadComplete != null &&
          resultState is LocalHlsCompleteState &&
          theTarget != null) {
        await onDownloadComplete.call(theTarget, ref);
      }

      await checkForNextQueue(
        where: ' after complete: 373',
        onDownloadComplete: onDownloadComplete,
        onError: onError,
      );
    } catch (e) {
      theTarget = await moviesController.updateHlsStatus(
        hls.id,
        LocalHlsErrorState(),
        where: 'after download complete 402',
      );
      dispose();
      _stopDownloading(where: 'catch line 421');
    }
  }
}
