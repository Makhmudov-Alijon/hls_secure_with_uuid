import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

class LocalHlsGroupModel extends Equatable {
  const LocalHlsGroupModel({
    required this.title,
    required this.season,
    required this.isSerial,
    required this.movies,
    required this.posterFile,
    required this.id,
  });

  final int id;
  final String title;
  final int? season;
  final bool isSerial;
  final List<LocalHlsModel> movies;
  final File posterFile;

  int get totalSizeInBytes {
    var temp = 0;
    for (final movie in movies) {
      temp += movie.hlsDetails.sizeBytes;
    }
    return temp;
  }

  @override
  List<Object?> get props => [id, title, season, isSerial, movies, posterFile];
}
