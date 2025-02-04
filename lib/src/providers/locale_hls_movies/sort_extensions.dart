import 'package:download_manager/download_manager.dart';

extension Dibiding on List<LocalHlsModelIsar> {
  List<LocalHlsModelIsar> get getItemsInQueueExt {
    if (isEmpty) {
      return [];
    }

    final result = where(
      (hls) {
        final state = hls.localHlsState();
        return state is LocalHlsDownloadingState ||
            state is LocalHlsInQueueState ||
            state is LocalHlsPauseState ||
            state is LocalHlsErrorState ||
            state is LocalHlsWaitingForNetworkState;
      },
    ).toList()
      ..sort(
        (a, b) {
          final aOrder = a.localHlsState().getOrder;
          final bOrder = b.localHlsState().getOrder;
          if (aOrder != bOrder) {
            return aOrder.compareTo(
              bOrder,
            );
          } else {
            return b.downloadStatus!.creationDate.compareTo(
              a.downloadStatus!.creationDate,
            );
          }
        },
      );
    return result;
  }

  List<LocalHlsGroupModel> getGroupedItemsExt({
    required String appDirPath,
  }) {
    // return [];
    final groupMap = <int, List<LocalHlsModelIsar>>{};

    // final start = DateTime.now();
    if (isEmpty) {
      return [];
    }

    for (final hls in this) {
      final key = hls.hlsDetails.localHlsId.contentId;
      if (hls.localHlsState() is LocalHlsCompleteState) {
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
              final aDetail = a.hlsDetails;
              final bDetail = b.hlsDetails;

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
      final details = items.first.hlsDetails;
      return LocalHlsGroupModel(
        id: details.localHlsId.contentId,
        title: details.title,
        season: details.seasonNum,
        isSerial: details.isSerial,
        posterFile: items.first.posterFileForIsolate(appDirPath),
        movies: items,
      );
    }).toList();

    return groups;
  }
}
