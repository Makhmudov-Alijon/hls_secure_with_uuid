import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final networkConnectionProvider = StreamProvider(
  (ref) {
    final connectionChecker = InternetConnectionChecker.createInstance();

    return connectionChecker.onStatusChange;
  },
);
