import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/providers/locale_hls_movies/sort_extensions.dart';
import 'package:download_manager/src/repository/hls_local_repository.dart';
import 'package:download_manager/src/repository/isar/locale_hls_store/locale_hls_store_repository.dart';
import 'package:download_manager/src/repository/isar/locale_hls_store/locale_hls_store_repository_impl.dart';
import 'package:download_manager/src/utils/app_debouncer/app_debouncer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

part 'locale_hls_movies_state.dart';

final localHlsMoviesProvider =
    NotifierProvider<LocalHlsMoviesNotifier, LocaleHlsMoviesState>(
  LocalHlsMoviesNotifier.new,
);

class LocalHlsMoviesNotifier extends Notifier<LocaleHlsMoviesState> {
  bool isInitial = true;

  LocaleHlsStoreRepository get hlsIsarRepo => ref.read(localeHlsIsarProvider);

  LocalHlsMovieNotifier movieController(LocalHlsId hlsId) {
    return ref.read(localHlsMovieProvider(hlsId).notifier);
  }

  LocalHlsGroupModel? getGroupById(int contentId) {
    final groups = state.downloadedS;
    for (final group in groups) {
      if (contentId == group.id) {
        return group;
      }
    }
    return null;
  }

  Future<void> checkWaitingForNetworkQueue() async {
    final total = await ref.read(localeHlsIsarProvider).getAll();
    final loading = Prefs.getWaitingForNetworkDownloadingHlsId();

    for (final hls in total) {

      final localeState = hls.localHlsState();
      if (localeState is LocalHlsDeletedState || !hls.validate()) {
        await hlsIsarRepo.delete(hls);

        ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);

        continue;
      }

      if (localeState is LocalHlsWaitingForNetworkState) {
        final isDownload = loading != null && loading == hls.id;

        if (isDownload) {
          movieController(hls.iD).tryContinueDownload(
            onError: (error) {
              // ShowSnackBar.errorText(
              //     '${error.statusCode}: ${LocaleKeys.somethingWentWrong.tr()}');
            },
            onDownloadComplete: (hls, ref) {
              return ref
                  .read(remoteStatRepositoryProvider)
                  .sendDownloadedHlsStat(
                    downloadedHlsStat: HlsDownloadedStatModel.fromHlsId(
                      id: hls.iD,
                    ),
                  );
            },
          );
          continue;
        }
        final updatedHls = await hlsIsarRepo.updateDownloadStatus(
            hlsId: hls.id,
            status: LocalHlsInQueueState().toLocalHlsStatus(),
            where: 'local_hls_movies_provider.dart 65');
        if (updatedHls != null) {
          movieController(hls.iD).refresh();
        }
      } else {
        // print('<>< ><> elese : ${localeState.runtimeType}');
      }
    }
  }

  Future<void> setNoNetworkQueuee() async {
    final total = await ref.read(localeHlsIsarProvider).getAll();
    final inQueue = total.getItemsInQueueExt;
    for (final hls in inQueue) {
      final localeState = hls.localHlsState();
      if (localeState is LocalHlsDeletedState || !hls.validate()) {
        await hlsIsarRepo.delete(hls);

        ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
        continue;
      }

      if (localeState is LocalHlsDownloadingState ||
          localeState is LocalHlsInQueueState) {
        final updatedHls = await hlsIsarRepo.updateDownloadStatus(
            hlsId: hls.id,
            status: LocalHlsWaitingForNetworkState().toLocalHlsStatus(),
            where: 'local_hls_movies_provider.dart 65');
        if (localeState is LocalHlsDownloadingState) {
          await movieController(hls.iD).pauseDownload(isUpdate: false);

          await Prefs.setWaitingForNetwork(hls.id);
        }
        if (updatedHls != null) {
          movieController(hls.iD).refresh();
        }
      }
    }
  }

  bool _checkInitial() {
    final temp = isInitial;
    if (isInitial) {
      isInitial = false;
    }
    return temp;
  }

  final AppDeBouncer deBouncer = AppDeBouncer(
    milliseconds: 300,
  );
  Future<void> refreshMovies() async {
    deBouncer.run(
      () => loadMoviesIsar(false),
    );
  }

  Future<LocalHlsModelIsar?> findNextInQueue({required String where}) async {
    final total = await ref.read(localeHlsIsarProvider).getAll();

    final moviesInQueue = total
        .where((element) => element.localHlsState() is LocalHlsInQueueState)
        .toList()
      ..sort(
        (a, b) {
          return a.downloadStatus!.creationDate.compareTo(
            b.downloadStatus!.creationDate,
          );
        },
      );

    if (moviesInQueue.isEmpty) {
      return null;
    } else {
      return moviesInQueue.first;
    }
  }

  Future<void> deleteHlsByLocalHlsId(LocalHlsId id) async {
    try {
      final hls = await hlsById(id);
      if (hls != null) {
        await deleteHls(hls: hls);
      }
    } catch (e) {
      print('<>< ><>  deleteHlsByLocalHlsId exception : ${e}');
    }
  }

  void deleteGroupOfHls({
    required LocalHlsGroupModel hlsGroup,
    FutureOr<void> Function(LocalHlsGroupModel group, Ref ref)? onDelete,
  }) {
    for (final item in hlsGroup.movies) {
      deleteHls(hls: item, isRefresh: false);
    }
    refreshMovies();
    onDelete?.call(hlsGroup, ref);
  }

  Future<void> deleteHls({
    required LocalHlsModelIsar hls,
    FutureOr<void> Function(LocalHlsModelIsar hls, Ref ref)? onDeletee,
    bool isRefresh = true,
  }) async {
    await ref.read(localeHlsIsarProvider).delete(hls);
    try {
      ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
    } catch (e) {
      print('<>< ><> the delete hls directory exception : ${e}');
    }
    movieController(hls.iD).refresh();
    if (isRefresh) {
      await refreshMovies();
    }
    onDeletee?.call(hls, ref);
  }

  Future<LocalHlsModelIsar?> updateHlsStatus(
    Id hlsId,
    LocalHlsState hlsState, {
    required String where,
  }) async {
    final result = await ref.read(localeHlsIsarProvider).updateDownloadStatus(
          hlsId: hlsId,
          status: hlsState.toLocalHlsStatus(),
          where: 'locale hls movies 105 => $where',
        );
    if (result != null) {
      await refreshMovies();
      movieController(result.iD).refresh();
    }
    return result;
  }

  Future<LocalHlsModelIsar?> hlsById(LocalHlsId id) async {
    return ref.read(localeHlsIsarProvider).getByLocaleHlsId(id: id);
  }

  /// Load the movies thread
  Future<void> loadMoviesIsar(bool isInitial) async {
    if (isInitial) {
      await Prefs.clear();
    }
    final total = await ref.read(localeHlsIsarProvider).getAll();
    final hlsMovies = <LocalHlsModelIsar>[];

    for (var hls in total) {
      final localeState = hls.localHlsState();

      final cond1 = localeState is LocalHlsDeletedState;
      final cond2 = !hls.validate();
      if (cond1 || cond2) {
        await hlsIsarRepo.delete(hls);

        ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);

        continue;
      }
      if (isInitial) {
        if (localeState is LocalHlsCompleteState && hls.timeLeft.inHours <= 0) {
          ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
          continue;
        } else if (localeState is LocalHlsDownloadingState ||
            localeState is LocalHlsInQueueState ||
            localeState is LocalHlsDownloadingState ||
            localeState is LocalHlsWaitingForNetworkState) {
          final updatedHls = await hlsIsarRepo.updateDownloadStatus(
              hlsId: hls.id,
              status: LocalHlsPauseState().toLocalHlsStatus(),
              where: 'local_hls_movies_provider.dart 180');
          if (updatedHls != null) {
            hls = updatedHls;
          } else {
            continue;
          }
        }
      }
      hlsMovies.add(hls);
    }

    unawaited(sort(hlsMovies));
  }

  /// Sorting threads
  Future<void> sort(List<LocalHlsModelIsar> total) async {
    final receivePort = ReceivePort();
    final appDir = await getApplicationDocumentsDirectory();
    await Isolate.spawn<SortIsolateParams>(
      _sortWorker,
      SortIsolateParams(
        appDirPath: appDir.path,
        sendPort: receivePort.sendPort,
        data: total,
      ),
    );
    receivePort.listen(
      (v) {
        if (v is LocaleHlsMoviesState) {
          updateState(
            v.copyWith(
              trigger: !v.trigger,
            ),
          );
        }
      },
    );
  }

  void updateState(LocaleHlsMoviesState v) {
    state = v;
  }

  @override
  LocaleHlsMoviesState build() {
    Prefs.initt().then((v) {
      loadMoviesIsar(_checkInitial());
    });

    return const LocaleHlsMoviesState();
  }
}

/// SORT
void _sortWorker(SortIsolateParams params) {
  try {
    final rawItems = params.data.getItemsInQueueExt;
    final downloadeds =
        params.data.getGroupedItemsExt(appDirPath: params.appDirPath);

    Isolate.exit(
      params.sendPort,
      LocaleHlsMoviesState(
        downloadedS: downloadeds,
        rawItems: rawItems,
        total: params.data,
      ),
    );
  } catch (e) {
    Isolate.exit(params.sendPort, e);
  }
}
