import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hlsLocalRepositoryProvider = Provider(
  (ref) => HlsLocalRepository(),
);

class HlsLocalRepository {
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
          final updatedHls = updateHlsStatus(
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
  void updateHls(LocalHlsModel hls) {
    final hlsFile = hls.localHlsFile;
    if (hlsFile.existsSync()) {
      hlsFile.writeAsStringSync(
        hls.toJson(),
      );
    } else {
      throw UnimplementedError('Hls file not exist');
    }
  }

  LocalHlsModel? updateHlsStatus(LocalHlsModel hls, LocalHlsState state) {
    try {
      final newHls = hls.copyWithh(
        downloadStatus: state.toLocalHlsStatus(),
      );
      updateHls(newHls);
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
    final hlsFile = hls.localHlsFile;
    if (!hlsFile.existsSync()) {
      return LocalHlsDeletedState();
    }
    final fileContent = hlsFile.readAsStringSync();
    if (fileContent.isEmpty) {
      return LocalHlsDeletedState();
    }
    return LocalHlsModel.fromJson(fileContent).localHlsState;
  }
}
