import 'package:flexible_internet_checker/flexible_internet_checker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class DownloadManagerProviders {
  static final internetChecker = Provider<FlexibleInternetChecker>(
    (ref) {
      return FlexibleInternetChecker.createInstance(
        interval: const Duration(seconds: 2),
      );
    },
  );

  static final connectionStream = StreamProvider<InternetStatus>(
    (ref) {
      final connectionChecker = ref.read(internetChecker);
      return connectionChecker.status;
    },
  );
}
