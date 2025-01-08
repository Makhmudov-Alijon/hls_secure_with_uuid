import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hlsLocalRepositoryProvider = Provider(
  (ref) => HlsLocalRepository(),
);

class HlsLocalRepository {
  /// point
  Future<List<LocalHlsModel>> fetchLocalHlsMovies({
    bool isInitial = false,
  }) async {
    final mediaDir = await HlsPathConstants.mediaDir;
    final hlsFiles = await HlsUtils.searchFilesByNameInDirectory(
      mediaDir,
      HlsFilenames.localHlsJson,
    );
    final hlsMovies = <LocalHlsModel>[];

    for (final file in hlsFiles) {
      if (!file.existsSync()) continue;
      final content = file.readAsStringSync();
      var hls = LocalHlsModel.fromJson(content);

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
          final updatedHls = await updateHlsStatus(
            hls,
            LocalHlsPauseState(),
          );
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
  Future<void> updateHls(LocalHlsModel hls) async {
    final hlsFile = hls.localHlsFile;
    if (hlsFile.existsSync()) {
      final statusName = hls.downloadStatus.statusType.name;
      await Prefs.putLocalHlsStatusName(hls.getStatusKey, statusName).then((v) {
        final content = hls.toJson();
        hlsFile.writeAsStringSync(
          hls.toJson(),
        );
      });
    } else {
      throw UnimplementedError('Hls file not exist');
    }
  }

  Future<LocalHlsModel?> updateHlsStatus(
      LocalHlsModel hls, LocalHlsState state) async {
    try {
      final status = state.toLocalHlsStatus();
      final newHls = hls.copyWith(
        downloadStatus: status,
      );
      await updateHls(newHls);
      return newHls;
    } catch (e) {
      return null;
    }
  }

  void deleteHlsDirectory(LocalHlsModel hls) {
    if (hls.masterDir.existsSync()) {
      hls.masterDir.delete(recursive: true);
    }
  }

  LocalHlsState fetchHlsState(LocalHlsModel hls) {
    /// point
    final hlsFile = hls.localHlsFile;
    if (!hlsFile.existsSync()) {
      return LocalHlsDeletedState();
    }
    final fileContent = hlsFile.readAsStringSync();
    if (fileContent.isEmpty) {
      return LocalHlsDeletedState();
    }
    final state = LocalHlsModel.fromJson(fileContent).localHlsState;
    return state;
  }
}
