import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';
import 'package:hls_secure_with_uuid/src/utils/app_debouncer/app_debouncer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
final downloadButtonSafetyProvider =
    NotifierProvider<DownloadButtonSafetyNotifier, LocalHlsId?>(() {
  return DownloadButtonSafetyNotifier();
});

class DownloadButtonSafetyNotifier extends Notifier<LocalHlsId?> {
  DownloadButtonSafetyNotifier();

  void activate(LocalHlsId id, {required String where}) {

    state = id;
  }

  AppDeBouncer deBouncer = AppDeBouncer(milliseconds: 2000);

  void deActivate() {
    deBouncer.run(() {
      ref.invalidate(diskSpaceInfoProvider);
      state = null;
    });
  }

  @override
  LocalHlsId? build() {
    return null;
  }
}
