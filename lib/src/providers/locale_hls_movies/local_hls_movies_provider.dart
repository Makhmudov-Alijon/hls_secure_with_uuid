import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/providers/locale_hls_movies/sort_extensions.dart';
import 'package:download_manager/src/repository/hls_local_repository.dart';
import 'package:download_manager/src/repository/hls_local_repository_functions_on_top_level.dart';
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
    loadMovies();
  }

  Future<LocalHlsModelObj?> findNextInQueue({required String where}) async {
    if (state.total.isEmpty) {
      return null;
    }
    final moviesInQueue = state.total
        .where((element) => element.localHlsState is LocalHlsInQueueState)
        .toList()
      ..sort(
        (a, b) {
          return a.downloadStatus.target!.creationDate.millisecondsSinceEpoch
              .compareTo(
            b.downloadStatus.target!.creationDate.millisecondsSinceEpoch,
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
    required LocalHlsModelObj hls,
    FutureOr<void> Function(LocalHlsModelObj hls, Ref ref)? onDelete,
  }) {
    final hlsIndex = _hlsIndex(hls.hlsDetails.target!.localHlsId.target!);
    if (hlsIndex != null) {
      _removeHlsAtt(hlsIndex);
      movieController(hls.iD).refresh(); // TODO: check without it
      ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
      onDelete?.call(hls, ref);
    }
  }

  Future<LocalHlsState?> updateHlsStatus(
    LocalHlsId id,
    LocalHlsState hlsState, {
    required String where,
  }) async {
    if (state.total.isEmpty) {
      return null;
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
      return hlsState;
    } else {
      return null;
    }
  }

  void _replaceHlsAt(int index, LocalHlsModelObj updatedHls) {
    if (state.total.isNotEmpty) {
      final oldItems = [...state.total];
      final newItems = oldItems
        ..removeAt(index)
        ..insert(index, updatedHls);
      updateState(state.copyWith(total: newItems));
      sort('_replaceHlsAt');
    }
  }

  void _removeHlsAtt(int index) {
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
        final result = element.hlsDetails.target == id;
        return result;
      });
      return index < 0 ? null : index;
    } catch (e) {
      return null;
    }
  }

  LocalHlsModelObj? hlsByIdd(LocalHlsId id) {
    if (state.isEmpty) {
      return null;
    }
    final index = _hlsIndex(id);
    return index == null ? null : state.total[index];
  }

  /// Load the movies thread
  Future<void> loadMovies() async {
    final token = RootIsolateToken.instance!;
    final mediaDir = await HlsPathConstants.mediaDir;
    final receivePort = ReceivePort();
    await Isolate.spawn<LoadMoviesParams>(
      _loadMoviesWorker,
      LoadMoviesParams(
        token: token,
        sendPort: receivePort.sendPort,
        isInitial: _checkInitial(),
        mediaDir: mediaDir,
      ),
    );
    receivePort.listen(
      (v) async {
        if (v is List<LocalHlsModelObj>) {
          updateState(
            state.copyWith(total: v, trigger: !state.trigger),
          );
          unawaited(sort('load and sort'));
        } else if (v is List<dynamic>) {
          final port = v[1] as SendPort;
          final hls = v[0] as LocalHlsModelObj;
          final updatedHls = await updateHlsStatusTopp(
            hls,
            LocalHlsPauseState(),
          );
          if (updatedHls != null) {
            port.send(updatedHls);
          } else {
            final v = 0;
          }
        } else {
          final v = 0;
        }
      },
    );
  }

  /// Sorting threads
  Future<void> sort(String where) async {
    print('>< >< SORT FOR : $where');
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
        } else {
          final v = 0;
        }
      },
    );
  }

  void updateState(LocaleHlsMoviesState v) {
    state = v;
  }

  @override
  LocaleHlsMoviesState build() {
    loadMovies();

    return const LocaleHlsMoviesState();
  }
}

void _loadMoviesWorker(LoadMoviesParams params) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(params.token);
  final DateTime start = DateTime.now();
  final mediaDir = params.mediaDir;
  final hlsFiles = await HlsUtils.searchFilesByNameInDirectory(
    mediaDir,
    HlsFilenames.localHlsJson,
  );
  final hlsMovies = <LocalHlsModelObj>[];

  for (final file in hlsFiles) {
    if (!file.existsSync()) {
      continue;
    }
    final content = file.readAsStringSync();
    final hls = LocalHlsModelObj.fromJson(content);
    final localeState = hls.localHlsState;

    if (localeState is LocalHlsDeletedState || !hls.validate()) {
      deleteHlsDirectory(hls);
      continue;
    }
    if (params.isInitial) {
      if (localeState is LocalHlsCompleteState && hls.timeLeft.inHours <= 0) {
        deleteHlsDirectory(hls);
        continue;
      } else if (localeState is LocalHlsDownloadingState ||
          localeState is LocalHlsInQueueState) {
        final receivePort = ReceivePort();
        params.sendPort.send([hls, receivePort.sendPort]);

        receivePort.listen((v) {
          if (v is LocalHlsModelObj) {
            hlsMovies.add(v);
            receivePort.close();
          }
        });
        continue;
      } else {
        print(
            '>< >< is initial but else : name => ${localeState.toLocalHlsStatus().statusType.name}  ');
        print('progress:${localeState.progress}  ');
      }
    }
    hlsMovies.add(hls);
  }

  print(
      '>< >< spent time to load from file : ${DateTime.now().difference(start).inMilliseconds}');

  params.sendPort.send(hlsMovies);
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
