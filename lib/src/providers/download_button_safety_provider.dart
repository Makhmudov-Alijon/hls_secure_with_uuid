import 'package:download_manager/download_manager.dart';
import 'package:download_manager/src/utils/app_debouncer/app_debouncer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final downloadButtonSafetyProvider =
    StateNotifierProvider<DownloadButtonSafetyNotifier, LocalHlsId?>((ref) {
  return DownloadButtonSafetyNotifier(null);
});

class DownloadButtonSafetyNotifier extends StateNotifier<LocalHlsId?> {
  DownloadButtonSafetyNotifier(super.state);

  void activate(LocalHlsId id) {
    // if (state == null) {
    //   Future.delayed(const Duration(milliseconds: 3000), deActivate);
    // }
    state = id;
  }

  AppDeBouncer deBouncer = AppDeBouncer(milliseconds: 1200);

  void deActivate() {
    deBouncer.run(() {
      print('>< >< deactivate : ${state}');
      state = null;
    });
  }
}
