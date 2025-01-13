import 'dart:async';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'locale_hls_store/locale_hls_store_repository.dart';

final hlsLocalRepositoryProvider = Provider(
  (ref) => HlsLocalRepository(
    localeHlsStorage: ref.read(localeHlsStoreRepositoryProvider),
  ),
);

class HlsLocalRepository {
  const HlsLocalRepository({
    required this.localeHlsStorage,
  });

  final LocaleHlsStoreRepository localeHlsStorage;

  /// point
  Future<List<LocalHlsModelIsar>> fetchLocalHlsMovies({
    bool isInitial = false,
  }) async {
    final mediaDir = await HlsPathConstants.mediaDir;
    final hlsFiles = await HlsUtils.searchFilesByNameInDirectory(
      mediaDir,
      HlsFilenames.localHlsJson,
    );
    final hlsMovies = <LocalHlsModelIsar>[];

    for (final file in hlsFiles) {
      if (!file.existsSync()) continue;
      final content = file.readAsStringSync();
      var hls = LocalHlsModelIsar.fromJson(content);

      if (hls.localHlsState is LocalHlsDeletedState || !hls.validate()) {
        deleteHlsDirectory(hls);
        continue;
      }
      if (isInitial) {
        if (hls.localHlsState is LocalHlsCompleteState &&
            hls.timeLeft.inHours <= 0) {
          deleteHlsDirectory(hls);
          continue;
        } else if (hls.localHlsState is LocalHlsDownloadingState ||
            hls.localHlsState is LocalHlsInQueueState) {
          final updatedHls = await updateHlsStatus(hls, LocalHlsPauseState(),
              where: 'hls local repository 51');
          if (updatedHls != null) {
            hls = updatedHls;
          } else {
            continue;
          }
        }
      }
      hlsMovies.add(hls);
    }

    return hlsMovies;
  }

  /// **Warning** This function throws exception if hls not exists
  Future<void> updateHls(LocalHlsModelIsar hls) async {
    try {
      final statusName = hls.downloadStatus.statusType.name;
      await Prefs.putLocalHlsStatusNamee(hls.getStatusKey, statusName);
    } catch (e) {
      final v = 0;
    }
  }

  Future<LocalHlsModelIsar?> updateHlsStatus(
    LocalHlsModelIsar hls,
    LocalHlsState state, {
    required String where,
  }) async {
    try {
      final v = await localeHlsStorage.updateDownloadStatuss(
        hls: hls.id,
        status: state.toLocalHlsStatus(),
      );

      return v;
    } catch (e) {
      return null;
    }
  }

  void deleteHlsDirectory(LocalHlsModelIsar hls) {
    if (hls.masterDir.existsSync()) {
      hls.masterDir.delete(recursive: true);
    } else {
      final v = 0;
    }
  }


}
