import 'dart:async';

import 'package:download_manager/download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'locale_hls_store/locale_hls_store_repository.dart';

final hlsLocalRepositoryProvider = Provider(
  (ref) => HlsLocalRepository(
    localeHlsStorage: ref.read(localeHlsIsarProvider),
  ),
);

class HlsLocalRepository {
  const HlsLocalRepository({
    required this.localeHlsStorage,
  });

  final LocaleHlsStoreRepository localeHlsStorage;

  Future<LocalHlsModelIsar?> updateHlsStatus(Id hlsId,
    LocalHlsState state, {
    required String where,
  }) async {
    try {
      final v = await localeHlsStorage.updateDownloadStatus(
        hlsId: hlsId,
        status: state.toLocalHlsStatus(),
        where: 'hls_local_repository.dart 72 from: $where',
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
