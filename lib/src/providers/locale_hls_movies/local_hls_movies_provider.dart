import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/providers/locale_hls_movies/sort_extensions.dart';
import 'package:download_manager/src/repository/hls_local_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/locale_hls_store/locale_hls_store_repository.dart';

part 'locale_hls_movies_state.dart';
final localHlsMoviesProvider =
NotifierProvider<LocalHlsMoviesNotifier, LocaleHlsMoviesState>(
  LocalHlsMoviesNotifier.new,
);

class LocalHlsMoviesNotifier extends Notifier<LocaleHlsMoviesState> {
  bool isInitial = true;

  LocaleHlsStoreRepository get hlsIsarRepo =>
      ref.read(localeHlsStoreRepositoryProvider);

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

  Future<void> refreshMovies() async {
    await loadMoviesIsar(false);
  }

  Future<LocalHlsModelIsar?> findNextInQueue({required String where}) async {
    if (state.total.isEmpty) {
      return null;
    }
    final moviesInQueue = state.total
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
      deleteHls(hls: item);
    }
    onDelete?.call(hlsGroup, ref);
  }

  void deleteHls({
    required LocalHlsModelIsar hls,
    FutureOr<void> Function(LocalHlsModelIsar hls, Ref ref)? onDelete,
  }) {
    final hlsIndex = _hlsIndex(hls.hlsDetails.localHlsId);
    if (hlsIndex != null) {
      _removeHlsAt(hlsIndex);
      ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
      ref.read(localeHlsStoreRepositoryProvider).delete(hls);
      movieController(hls.iD).refresh(); // TODO: check without it
      onDelete?.call(hls, ref);
    } else {
      final v = 0;
    }
  }

  Future<LocalHlsModelIsar?> updateHlsStatus(
    LocalHlsId id,
    LocalHlsState hlsState, {
    required String where,
  }) async {
    final hlsIndex = _hlsIndex(id);
    if (hlsIndex != null) {
      final oldHls = state.total[hlsIndex];
      final newHls = await ref.read(hlsLocalRepositoryProvider).updateHlsStatus(
            oldHls,
            hlsState,
            where: 'local_hls_movies_provider 110 $where',
          );
      if (newHls != null) {
        await refreshMovies();
        movieController(id).refresh(); // TODO: check without it
      }
      return newHls;
    } else {
      return null;
    }
  }

  void _removeHlsAt(int index) {
    if (state.total.isNotEmpty) {
      final oldState = [...state.total];
      final newState = oldState..removeAt(index);
      updateState(
        state.copyWith(
          total: newState,
        ),
      );
      sort('_removeHlsAtt');
    }
  }

  int? _hlsIndex(LocalHlsId id) {
    try {
      final index = state.total.indexWhere((element) {
        final result = element.hlsDetails.localHlsId == id;

        return result;
      });
      return index < 0 ? null : index;
    } catch (e) {
      return null;
    }
  }

  Future<LocalHlsModelIsar?> hlsById(LocalHlsId id) async {
    return ref.read(localeHlsStoreRepositoryProvider).getByLocaleHlsId(id: id);
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

            hls: hls,
            status: LocalHlsPauseState().toLocalHlsStatus(),where: 'local_hls_movies_provider.dart 180'
          );
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
    loadMoviesIsar(_checkInitial());

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
