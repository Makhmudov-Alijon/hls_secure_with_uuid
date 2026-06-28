import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/unique_id_generator.dart';

part 'hls_downloaded_stat_model.g.dart';

@Collection(inheritance: false)
class HlsDownloadedStatModel extends Equatable {
  final String id;

  Id get isarId => fastHash(id);

  final int contentId;

  final int? episodeId;

  Map<String, dynamic> toJson() {
    return {
      "content_id": contentId,
      if (episodeId != null) "episode_id": episodeId,
    };
  }

  factory HlsDownloadedStatModel.fromHlsId({required LocalHlsId id}) {
    return HlsDownloadedStatModel(
      contentId: id.contentId,
      episodeId: id.episodeId,
      id: id.toStringId(),
    );
  }

  const HlsDownloadedStatModel({
    required this.contentId,
    required this.episodeId,
    required this.id,
  });

  @override
  @ignore
  List<Object?> get props => [id, contentId, episodeId];
}
