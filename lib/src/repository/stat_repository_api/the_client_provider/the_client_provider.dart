import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final theClientProvider = Provider((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      baseUrl: 'will update anyway',
    ),
  );

  return dio;
});
