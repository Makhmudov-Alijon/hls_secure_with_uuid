import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class DownloadManagerProviders {
  static final dmConnectionCheckerProvider = Provider<InternetConnectionChecker>(
    (ref) {
      return InternetConnectionChecker.createInstance(
        checkInterval: const Duration(seconds: 2),
      );
    },
  );

  static final networkConnectionProvider = StreamProvider<InternetConnectionStatus>(
    (ref) {
      final connectionChecker = ref.read(dmConnectionCheckerProvider);
      return connectionChecker.onStatusChange;
    },
  );
}
