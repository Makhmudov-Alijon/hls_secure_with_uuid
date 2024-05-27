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
      if (isInitial) {
        if (hls.localHlsState is LocalHlsCompleteState &&
            hls.timeLeft.inHours < 0) {
          deleteHlsDirectory(hls);
          continue;
        } else if (hls.localHlsState is LocalHlsDownloadingState) {
          hls = updateHlsStatus(hls, LocalHlsErrorState());
        } else if (hls.localHlsState is LocalHlsInQueueState) {
          hls = updateHlsStatus(hls, LocalHlsPauseState());
        }
      }
      hlsMovies.add(hls);
    }

    return hlsMovies;
  }

  void updateHls(LocalHlsModel hls) {
    final hlsFile = hls.localHlsFile;
    if (hlsFile.existsSync()) {
      hlsFile.writeAsStringSync(
        hls.toJson(),
      );
    }
  }

  LocalHlsModel updateHlsStatus(LocalHlsModel hls, LocalHlsState state) {
    final newHls = hls.copyWith(
      downloadStatus: state.toLocalHlsStatus(),
    );
    updateHls(newHls);
    return newHls;
  }

  void deleteHlsDirectory(LocalHlsModel hls) {
    hls.masterDir.delete(recursive: true);
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
