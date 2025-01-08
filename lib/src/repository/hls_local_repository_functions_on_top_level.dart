import 'package:download_manager/download_manager.dart';

/// **Warning** This function throws exception if hls not exists
Future<void> updateHlss(LocalHlsModel hls) async {
  final hlsFile = hls.localHlsFile;
  if (hlsFile.existsSync()) {
    final statusName = hls.downloadStatus.statusType.name;
    await Prefs.putLocalHlsStatusName(hls.getStatusKey, statusName).then((v) {
      hlsFile.writeAsStringSync(
        hls.toJson(),
      );
    });
  } else {
    throw UnimplementedError('Hls file not exist');
  }
}

Future<LocalHlsModel?> updateHlsStatusTopp(
  LocalHlsModel hls,
  LocalHlsState state,
) async {
  try {
    final newHls = hls.copyWith(
      downloadStatus: state.toLocalHlsStatus(),
    );
    await updateHlss(newHls);
    return newHls;
  } catch (e) {
    return null;
  }
}

void deleteHlsDirectory(LocalHlsModel hls) {
  if (hls.masterDir.existsSync()) {
    hls.masterDir.delete(recursive: true);
  } else {
    print('>< >< hls master der not exists : ${hls.id}');
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
  return LocalHlsModel.fromJson(fileContent).localHlsState;
}
