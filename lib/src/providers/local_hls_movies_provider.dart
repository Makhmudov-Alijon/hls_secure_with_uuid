import 'dart:async';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localHlsMoviesProvider =
    AsyncNotifierProvider<LocalHlsMoviesNotifier, List<LocalHlsModel>>(
  LocalHlsMoviesNotifier.new,
);

class LocalHlsMoviesNotifier extends AsyncNotifier<List<LocalHlsModel>> {
  bool isInitial = true;

  List<LocalHlsGroupModel> getGroupedItems() {
    final groupMap = <int, List<LocalHlsModel>>{};

    if (!state.hasValue) {
      return [];
    }

    for (final hls in state.value!) {
      final key = hls.hlsDetails.id.contentId;
      if (hls.localHlsState is LocalHlsCompleteState) {
        if (groupMap.containsKey(key)) {
          groupMap.update(key, (value) {
            return [...value, hls];
          });
        } else {
          groupMap.addAll({
            key: [hls],
          });
        }
      }
    }

    final groups = groupMap.values.map((items) {
      if (items.first.hlsDetails.isSerial) {
        items = items
          ..sort(
            (a, b) {
              if (a.hlsDetails.seasonNum == null ||
                  b.hlsDetails.seasonNum == null ||
                  a.hlsDetails.episodeNum == null ||
                  b.hlsDetails.episodeNum == null) {
                return 1;
              } else if (a.hlsDetails.seasonNum == b.hlsDetails.seasonNum) {
                return a.hlsDetails.episodeNum!.compareTo(
                  b.hlsDetails.episodeNum!,
                );
              }
              return a.hlsDetails.seasonNum!.compareTo(b.hlsDetails.seasonNum!);
            },
          );
      }

      return LocalHlsGroupModel(
        id: items.first.hlsDetails.id.contentId,
        title: items.first.hlsDetails.title,
        season: items.first.hlsDetails.seasonNum,
        isSerial: items.first.hlsDetails.isSerial,
        posterFile: items.first.posterFile,
        movies: items,
      );
    }).toList();

    return groups;
  }

  LocalHlsGroupModel? getGroupById(int contentId) {
    final groups = getGroupedItems();
    for (final group in groups) {
      if (contentId == group.id) {
        return group;
      }
    }
    return null;
  }

  List<LocalHlsModel> getItemsInQueue() {
    if (!state.hasValue) {
      return [];
    }
    return state.value!.where(
      (hls) {
        return hls.localHlsState is LocalHlsDownloadingState ||
            hls.localHlsState is LocalHlsInQueueState ||
            hls.localHlsState is LocalHlsPauseState ||
            hls.localHlsState is LocalHlsErrorState;
      },
    ).toList()
      ..sort(
        (a, b) {
          if (a.localHlsState is LocalHlsDownloadingState) {
            return -1;
          } else if (a.localHlsState is! LocalHlsInQueueState) {
            return 1;
          } else {
            return a.downloadStatus.creationDate.millisecondsSinceEpoch
                .compareTo(
              b.downloadStatus.creationDate.millisecondsSinceEpoch,
            );
          }
        },
      );
  }

  bool _checkInitial() {
    final temp = isInitial;
    if (isInitial) {
      isInitial = false;
    }
    return temp;
  }

  @override
  FutureOr<List<LocalHlsModel>> build() async {
    return ref
        .read(hlsLocalRepositoryProvider)
        .fetchLocalHlsMovies(isInitial: _checkInitial());
  }

  Future<void> refreshMovies() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(hlsLocalRepositoryProvider).fetchLocalHlsMovies(),
    );
  }

  Future<LocalHlsModel?> findNextInQueue() async {
    if (!state.hasValue) {
      return null;
    }
    final moviesInQueue = state.value!
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

  void deleteGroupOfHls(LocalHlsGroupModel hlsGroup) {
    for (final item in hlsGroup.movies) {
      deleteHls(item);
    }
  }

  void deleteHls(LocalHlsModel hls) {
    final hlsIndex = _hlsIndex(hls.id);
    if (hlsIndex != null) {
      _removeHlsAt(hlsIndex);
      ref.read(hlsLocalRepositoryProvider).updateHlsStatus(
            hls,
            LocalHlsDeletedState(),
          );
      ref.invalidate(localHlsMovieProvider(hls.id));
      ref.read(hlsLocalRepositoryProvider).deleteHlsDirectory(hls);
    }
  }

  void updateHlsStatus(LocalHlsId id, LocalHlsState hlsState) {
    final hlsIndex = _hlsIndex(id);
    if (hlsIndex != null) {
      final oldHls = state.value![hlsIndex];
      final newHls = ref
          .read(hlsLocalRepositoryProvider)
          .updateHlsStatus(oldHls, hlsState);
      _replaceHlsAt(hlsIndex, newHls);
      ref.invalidate(localHlsMovieProvider(id));
    }
  }

  void _replaceHlsAt(int index, LocalHlsModel updatedHls) {
    if (state.hasValue) {
      final oldState = [...state.value!];
      final newState = oldState
        ..removeAt(index)
        ..insert(index, updatedHls);
      state = AsyncData(newState);
    }
  }

  void _removeHlsAt(int index) {
    if (state.hasValue) {
      final oldState = [...state.value!];
      final newState = oldState..removeAt(index);
      state = AsyncData(newState);
    }
  }

  int? _hlsIndex(LocalHlsId id) {
    final index = state.value?.indexWhere((element) => element.id == id);
    return index == null || index < 0 ? null : index;
  }

  LocalHlsModel? hlsById(LocalHlsId id) {
    if (!state.hasValue) {
      return null;
    }
    final index = _hlsIndex(id);
    return index == null ? null : state.value![index];
  }
}
