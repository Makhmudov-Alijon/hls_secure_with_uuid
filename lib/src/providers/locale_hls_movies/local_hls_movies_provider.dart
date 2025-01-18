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


part 'locale_hls_movies_state.dart';
final localHlsMoviesProvider =
NotifierProvider<LocalHlsMoviesNotifier, LocaleHlsMoviesState>(
  LocalHlsMoviesNotifier.new,
);

class LocalHlsMoviesNotifier extends Notifier<LocaleHlsMoviesState> {
  bool isInitial = true;

  LocaleHlsStoreRepository get hlsIsarRepo =>
      ref.read(localeHlsIsarProvider);

  LocalHlsMovieNotifier movieController(LocalHlsId hlsId) {
    return ref.read(localHlsMovieProviderr(hlsId).notifier);
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
    if (state.total.isEmpty) {
      return null;
    }
    final total = await ref.read(localeHlsIsarProvider).getAll();

    final moviesInQueue = total
        .where((element) => element.localHlsState is LocalHlsInQueueState)
        .toList()
      ..sort(
        (a, b) {
          return a.downloadStatus.creationDate.compareTo(
            b.downloadStatus.creationDate,
          );
        },
      );

    if (moviesInQueue.isEmpty) {
      return null;
    } else {
      return moviesInQueue.first;
    }
  }

  void deleteGroupOfHls({
    required LocalHlsGroupModel hlsGroup,
    FutureOr<void> Function(LocalHlsGroupModel group, Ref ref)? onDelete,
  }) {
    for (final item in hlsGroup.movies) {
      deleteHlss(hls: item);
    }
    onDelete?.call(hlsGroup, ref);
  }

  Future<void> deleteHlss({
    required LocalHlsModelIsar hls,
    FutureOr<void> Function(LocalHlsModelIsar hls, Ref ref)? onDeletee,
  }) async {
    await ref.read(localeHlsIsarProvider).delete(hls);
    ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
    movieController(hls.iD).refresh();
    await refreshMovies();
    onDeletee?.call(hls, ref);
  }

  Future<LocalHlsModelIsar?> updateHlsStatus(Id hlsId,
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
    final DateTime start = DateTime.now();
    final total =
        await ref.read(isarProvider).localHlsModelIsars.where().findAll();
    final hlsMovies = <LocalHlsModelIsar>[];
    for (var hls in total) {
      final localeState = hls.localHlsState;
      final rtt = localeState.runtimeType;
      final v = localeState is LocalHlsDownloadingState ||
          localeState is LocalHlsInQueueState;
      if (localeState is LocalHlsDeletedState || !hls.validate()) {
        await hlsIsarRepo.delete(hls);

        ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
        continue;
      }
      if (isInitial) {
        final v = 0;
        if (localeState is LocalHlsCompleteState && hls.timeLeft.inHours <= 0) {
          ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
          continue;
        } else if (localeState is LocalHlsDownloadingState ||
            localeState is LocalHlsInQueueState) {
          final updatedHls = await hlsIsarRepo.updateDownloadStatus(
              hlsId: hls.id,
              status: LocalHlsPauseState().toLocalHlsStatus(),
              where: 'local_hls_movies_provider.dart 180');
          final vv = 0;
          if (updatedHls != null) {
            hls = updatedHls;
          } else {
            continue;
          }
        } else {
          // print(
          //     '>< >< is initial but else : name => ${localeState.toLocalHlsStatus().statusType.name}  ');
          // print('progress:${localeState.progress}  ');
        }
      }
      hlsMovies.add(hls);
    }
    updateState(
      state.copyWith(total: hlsMovies),
    );

    unawaited(sort('load and sort'));
  }

  /// Sorting threads
  Future<void> sort(String where) async {
    final total = state.total;
    final receivePort = ReceivePort();
    await Isolate.spawn<SortIsolateParams>(
      _sortWorker,
      SortIsolateParams(
        sendPort: receivePort.sendPort,
        data: total,
      ),
    );
    receivePort.listen(
      (v) {
        if (v is LocaleHlsMoviesState) {
          updateState(v.copyWith(trigger: !v.trigger));
        }
      },
    );
  }

  void updateState(LocaleHlsMoviesState v) {
    state = v;
  }

  @override
  LocaleHlsMoviesState build() {
    Prefs.init().then((v) {
      loadMoviesIsar(_checkInitial());
    });

    return const LocaleHlsMoviesState();
  }
}

/// SORT
void _sortWorker(SortIsolateParams params) {
  try {
    final rawItems = params.data.getItemsInQueueExt;
    final downloadeds = params.data.getGroupedItemsExt;

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
