import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';
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

  static final client = Provider<Dio>(
    (ref) {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          receiveDataWhenStatusError: true,
        ),
      );

      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;

      return dio;
    },
  );

  static final endpoints = Provider<DownloadManagerEndPoints>(
    (ref) {
      return DownloadManagerEndPoints(
        addDownloadedStat: '',
        removeDownloadedHlsState: '',
      );
    },
  );

  static final isar = NotifierProvider<IsarNotifier, Isar>(
    () {
      throw UnimplementedError();
    },
  );
}

class DownloadManagerEndPoints with EquatableMixin {
  const DownloadManagerEndPoints({
    required this.addDownloadedStat,
    required this.removeDownloadedHlsState,
  });

  final String addDownloadedStat;
  final String removeDownloadedHlsState;

  @override
  List<Object?> get props => [addDownloadedStat, removeDownloadedHlsState];
}
