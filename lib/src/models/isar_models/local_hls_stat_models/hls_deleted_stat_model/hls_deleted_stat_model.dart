import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/unique_id_generator.dart';

part 'hls_deleted_stat_model.g.dart';

@Collection(inheritance: false)
class HlsDeletedStatModel extends Equatable {
  const HlsDeletedStatModel({
    required this.id,
    required this.contentId,
    required this.episodeId,
    this.entireContent = false,
  });

  factory HlsDeletedStatModel.fromHlsId({
    required LocalHlsId hlsId,
    required bool entireContent,
  }) {
    return HlsDeletedStatModel(
      id: hlsId.toStringId(),
      contentId: hlsId.contentId,
      episodeId: hlsId.episodeId,
      entireContent: entireContent,
    );
  }
  
  Id get isarId => fastHash(id);

  final String id;

  final int contentId;

  final int? episodeId;

  final bool entireContent;

  Map<String, dynamic> toJson() {
    return {
      'content_id': contentId,
      if (episodeId != null && !entireContent) 'episode_id': episodeId,
    };
  }

  @override
  @ignore
  List<Object?> get props => [id, contentId, episodeId, entireContent];
}
