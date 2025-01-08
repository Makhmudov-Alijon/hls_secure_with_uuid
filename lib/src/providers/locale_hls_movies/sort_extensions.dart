import 'package:download_manager/download_manager.dart';

extension Dibiding on List<LocalHlsModelObj> {
  List<LocalHlsModelObj> get getItemsInQueueExt {
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
            return b.downloadStatus.target!.creationDate.compareTo(
              a.downloadStatus.target!.creationDate,
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
    final groupMap = <int, List<LocalHlsModelObj>>{};

    // final start = DateTime.now();
    if (isEmpty) {
      return [];
    }

    for (final hls in this) {
      final key = hls.hlsDetails.target!.localHlsId.target!.contentId;
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
      if (items.first.hlsDetails.target!.isSerial) {
        items = items
          ..sort(
            (a, b) {
              final aDetail = a.hlsDetails.target!;
              final bDetail = b.hlsDetails.target!;

              if (aDetail.seasonNum == null ||
                  bDetail.seasonNum == null ||
                  aDetail.episodeNum == null ||
                  bDetail.episodeNum == null) {
                return 1;
              } else if (aDetail.seasonNum == bDetail.seasonNum) {
                return aDetail.episodeNum!.compareTo(
                  bDetail.episodeNum!,
                );
              }
              return aDetail.seasonNum!.compareTo(bDetail.seasonNum!);
            },
          );
      }
      final details = items.first.hlsDetails.target!;
      return LocalHlsGroupModel(
        id: details.localHlsId.target!.contentId,
        title: details.title,
        season: details.seasonNum,
        isSerial: details.isSerial,
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
