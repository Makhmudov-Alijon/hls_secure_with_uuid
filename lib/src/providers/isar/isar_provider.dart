import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../hls_secure_with_uuid.dart';

final isarProviderr = NotifierProvider<IsarNotifier, Isar>(
  () {
    throw UnimplementedError();
  },
);

class IsarNotifier extends Notifier<Isar> {
  final Isar _isar;

  IsarNotifier({required Isar isar}) : _isar = isar;

  @override
  Isar build() {
    void check(InternetConnectionStatus status) {
      if (status == InternetConnectionStatus.connected) {
        ref.read(localHlsMoviesProvider.notifier).checkWaitingForNetworkQueue();
      } else {
        ref.read(localHlsMoviesProvider.notifier).setNoNetworkQueuee();
      }
    }

    ref.listen(
      networkConnectionProvider,
      (previous, next) {
        next.whenData((value) {
          log("Network connection status: $value");
          if (Prefs.initialized) {
            check(value);
          } else {
            Prefs.initt().then((v) {
              check(value);
            });
          }
          if (value == InternetConnectionStatus.connected) {
            ref.read(remoteStatRepositoryProvider).checkHlsStats();
          }


        });
      },
    );
    return _isar;
  }
}
