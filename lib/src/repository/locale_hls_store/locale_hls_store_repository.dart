import 'package:download_manager/download_manager.dart';

abstract class LocaleHlsStoreRepository {
  Future<void> add(LocalHlsModelIsar hls);
  Future<void> update(LocalHlsModelIsar hls);
  Future<void> delete(LocalHlsModelIsar hls);


}
