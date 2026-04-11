import 'package:flexible_internet_checker/flexible_internet_checker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../download_manager.dart';

class IsarNotifier extends Notifier<Isar> {
  IsarNotifier({required Isar isar}) : _isar = isar;

  final Isar _isar;

  @override
  Isar build() {
    void check(InternetStatus status) {
      if (status == InternetStatus.connected) {
        ref.read(localHlsMoviesProvider.notifier).checkWaitingForNetworkQueue();
      } else {
        ref.read(localHlsMoviesProvider.notifier).setNoNetworkQueuee();
      }
    }

    ref.listen(
      DownloadManagerProviders.connectionStream,
      (previous, next) {
        next.whenData((value) {
          if (Prefs.initialized) {
            check(value);
          } else {
            Prefs.initt().then((v) {
              check(value);
            });
          }
          if (value == InternetStatus.connected) {
            ref.read(remoteStatRepositoryProvider).checkHlsStats();
          }
        });
      },
    );
    return _isar;
  }
}
