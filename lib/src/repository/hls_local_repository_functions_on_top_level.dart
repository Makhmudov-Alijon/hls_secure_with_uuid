import 'package:download_manager/download_manager.dart';

/// **Warning** This function throws exception if hls not exists
Future<void> updateHls(LocalHlsModelIsar hls) async {
  /// todo: locale hls update top
  final hlsFile = hls.localHlsFilee;
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

Future<LocalHlsModelIsar?> updateHlsStatusTop(
  LocalHlsModelIsar hls,
  LocalHlsState state,
) async {
  try {
    final newHls = hls.copyWith(
      downloadStatus: state.toLocalHlsStatus(),
    );
    await updateHls(newHls);
    return newHls;
  } catch (e) {
    return null;
  }
}

void deleteHlsDirectory(LocalHlsModelIsar hls) {
  if (hls.masterDir.existsSync()) {
    hls.masterDir.delete(recursive: true);
  } else {
    print('>< >< hls master der not exists : ${hls.id}');
  }
}

LocalHlsState fetchHlsState(LocalHlsModelIsar hls) {
  /// point
  /// todo: locale hls fetch top
  final hlsFile = hls.localHlsFilee;
  if (!hlsFile.existsSync()) {
    return LocalHlsDeletedState();
  }
  final fileContent = hlsFile.readAsStringSync();
  if (fileContent.isEmpty) {
    return LocalHlsDeletedState();
  }
  return LocalHlsModelIsar.fromJson(fileContent).localHlsState;
}
