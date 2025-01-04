import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/providers/locale_hls_movies/sort_extensions.dart';
import 'package:download_manager/src/repository/hls_local_repository.dart';
import 'package:download_manager/src/repository/hls_local_repository_functions_on_top_level.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'locale_hls_movies_state.dart';

final localHlsMoviesProvider =
NotifierProvider<LocalHlsMoviesNotifier, LocaleHlsMoviesState>(
  LocalHlsMoviesNotifier.new,
);

class LocalHlsMoviesNotifier extends Notifier<LocaleHlsMoviesState> {
  bool isInitial = true;

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

  bool _checkInitial() {
    final temp = isInitial;
    if (isInitial) {
      isInitial = false;
    }
    return temp;
  }

  Future<void> refreshMovies() async {
    await loadMovies();
  }

  Future<LocalHlsModel?> findNextInQueue() async {
    if (state.rawItems.isEmpty) {
      return null;
    }
    final moviesInQueue = state.rawItems
        .where((element) => element.localHlsState is LocalHlsInQueueState)
        .toList()
      ..sort(
        (a, b) {
          return a.downloadStatus.creationDate.millisecondsSinceEpoch.compareTo(
            b.downloadStatus.creationDate.millisecondsSinceEpoch,
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
    required LocalHlsModel hls,
    FutureOr<void> Function(LocalHlsModel hls, Ref ref)? onDelete,
  }) {
    final hlsIndex = _hlsIndex(hls.id);
    if (hlsIndex != null) {
      _removeHlsAt(hlsIndex);
      movieController(hls.id).refresh(); // TODO: check without it
      ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
      onDelete?.call(hls, ref);
    }
  }

  Future<void> updateHlsStatus(
    LocalHlsId id,
    LocalHlsState hlsState, {
    required String where,
  }) async {
    if (state.total.isEmpty) {
      return;
    }
    final hlsIndex = _hlsIndex(id);
    if (hlsIndex != null) {
      final oldHls = state.total[hlsIndex];
      final newHls = await ref
          .read(hlsLocalRepositoryProvider)
          .updateHlsStatus(oldHls, hlsState);
      if (newHls != null) {
        _replaceHlsAt(hlsIndex, newHls);
        movieController(id).refresh(); // TODO: check without it
      }
    }
  }

  void _replaceHlsAt(int index, LocalHlsModel updatedHls) {
    if (state.total.isNotEmpty) {
      final oldItems = [...state.total];
      final newItems = oldItems
        ..removeAt(index)
        ..insert(index, updatedHls);
      updateState(state.copyWith(total: newItems));
      sort();
    }
  }

  void _removeHlsAt(int index) {
    /// todo: re sort
    if (state.total.isNotEmpty) {
      final oldState = [...state.total];
      final newState = oldState..removeAt(index);
      updateState(state.copyWith(total: newState));
      sort();
    }
  }

  int? _hlsIndex(LocalHlsId id) {
    try {
      final index = state.total.indexWhere((element) => element.id == id);
      return index < 0 ? null : index;
    } catch (e) {
      return null;
    }
  }

  LocalHlsModel? hlsById(LocalHlsId id) {
    if (state.isEmpty) {
      return null;
    }
    final index = _hlsIndex(id);
    return index == null ? null : state.total[index];
  }

  /// Load the movies thread
  Future<void> loadMovies() async {
    final mediaDir = await HlsPathConstants.mediaDir;
    final receivePort = ReceivePort();
    await Isolate.spawn<LoadMoviesParams>(
      _loadMoviesWorker,
      LoadMoviesParams(
        sendPort: receivePort.sendPort,
        isInitial: _checkInitial(),
        mediaDir: mediaDir,
      ),
    );
    receivePort.listen((v) {
      if (v is List<LocalHlsModel>) {
        print('>< >< the length of the loadeds movies ${v.length}');
        updateState(
          state.copyWith(
            total: v,
          ),
        );
        sort();
        receivePort.close();
      } else if (v is int) {
        print('>< >< int object gotten $v');
      } else {
        receivePort.close();
        final v = 0;
      }
    });
  }

  /// Sorting threads
  Future<void> sort() async {
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
          updateState(v);
        } else {
          final v = 0;
        }
      },
    );
  }

  void triggerState() {
    state = state.copyWith(trigger: !state.trigger);
  }

  void updateState(LocaleHlsMoviesState v) {
    state = v;
  }

  @override
  LocaleHlsMoviesState build() {
    Prefs().init().then((v) {
      loadMovies();
    });
    return const LocaleHlsMoviesState();
  }
}

/// todo: write sort thread and use it when the items changed, for example status changed, deleted etc.
/// LOAD MOVIES

void _loadMoviesWorker(LoadMoviesParams params) {
  try {
    fetchLocalHlsMoviesTopp(
      isInitial: params.isInitial,
      mediaDir: params.mediaDir,
    ).then((v) {
      Isolate.exit(params.sendPort, v);
    });
  } catch (e) {
    Isolate.exit(params.sendPort, 45);
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
