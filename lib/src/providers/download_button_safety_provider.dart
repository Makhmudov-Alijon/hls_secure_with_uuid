import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/utils/app_debouncer/app_debouncer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
final downloadButtonSafetyProvider =
    NotifierProvider<DownloadButtonSafetyNotifier, LocalHlsId?>(() {
  return DownloadButtonSafetyNotifier();
});

class DownloadButtonSafetyNotifier extends Notifier<LocalHlsId?> {
  DownloadButtonSafetyNotifier();

  void activate(LocalHlsId id, {required String where}) {
    // if (state == null) {
    //   Future.delayed(const Duration(milliseconds: 3000), deActivate);
    // }

    print('>< >< activated from : ${where}');
    state = id;
  }

  AppDeBouncer deBouncer = AppDeBouncer(milliseconds: 2000);

  void deActivate() {
    deBouncer.run(() {
      print('>< >< deactivate : ${state}');
      ref.invalidate(diskSpaceInfoProvider);
      state = null;
    });
  }

  @override
  LocalHlsId? build() {
    return null;
  }
}
