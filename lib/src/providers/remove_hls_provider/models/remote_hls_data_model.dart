import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_hls_data_model.freezed.dart';

part 'remote_hls_data_model.g.dart';

@freezed
class RemoteHlsDataModel with _$RemoteHlsDataModel {
  const factory RemoteHlsDataModel({
    required String master,
    required List<String> videoPlaylists,
    required List<String> audioPlaylists,
  }) = _RemoteHlsDataModel;

  factory RemoteHlsDataModel.fromJson(Map<String, Object?> json) =>
      _$RemoteHlsDataModelFromJson(json);
}
