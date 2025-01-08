import 'package:download_manager/download_manager.dart';

extension Dibiding on List<LocalHlsModel> {
  List<LocalHlsModel> get getItemsInQueueExt {
    // final start = DateTime.now();
    if (isEmpty) {
      return [];
    }

    final result = where(
      (hls) {
        final state = hls.localHlsStateWithoutProgress;
        return state is LocalHlsDownloadingState ||
            state is LocalHlsInQueueState ||
            state is LocalHlsPauseState ||
            state is LocalHlsErrorState;
      },
    ).toList()
      ..sort(
        (a, b) {
          final aOrder = a.localHlsStateWithoutProgress.getOrder;
          final bOrder = b.localHlsStateWithoutProgress.getOrder;
          if (aOrder != bOrder) {
            return aOrder.compareTo(
              bOrder,
            );
          } else {
            return b.downloadStatus.creationDate.compareTo(
              a.downloadStatus.creationDate,
            );
          }
        },
      );
    // final end = DateTime.now();
    //
    // print('>< >< the queue spent : ${end.difference(start).inMilliseconds}');
    return result;
  }

  List<LocalHlsGroupModel> get getGroupedItemsExt {
    // return [];
    final groupMap = <int, List<LocalHlsModel>>{};

    // final start = DateTime.now();
    if (isEmpty) {
      return [];
    }

    for (final hls in this) {
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
    // final end = DateTime.now();
    //
    // print(
    //     '>< >< the downloadeds spent : ${end.difference(start).inMilliseconds}');

    return groups;
  }
}
