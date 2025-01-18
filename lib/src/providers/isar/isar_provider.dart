import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../download_manager.dart';

final isarProvider = NotifierProvider<IsarNotifierr, Isar>(
  () {
    throw UnimplementedError();
  },
);

class IsarNotifierr extends Notifier<Isar> {
  final Isar _isar;

  IsarNotifierr({required Isar isar}) : _isar = isar;

  @override
  Isar build() {
    ref.listen(
      networkConnectionProvider,
      (previous, next) {
        next.whenData((value) {
          log("Network connection status: $value");
          if (value == InternetConnectionStatus.connected) {
            ref.read(remoteStatRepositoryProvider).checkHlsStats();
          }
        });
      },
    );
    return _isar;
  }
}
