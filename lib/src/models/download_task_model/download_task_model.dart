// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:equatable/equatable.dart';

class DownloadTask extends Equatable {
  const DownloadTask({
    required this.items,
    this.mbPerSegment = 0,
  });

  final List<DownloadItemm> items;
  final double mbPerSegment;

  @override
  List<Object?> get props => [items,mbPerSegment,];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
      'mb_per_segment': mbPerSegment,
    };
  }

  factory DownloadTask.fromFile(File file) {
    final content = file.readAsStringSync();
    return DownloadTask.fromJson(content);
  }

  factory DownloadTask.fromMap(Map<String, dynamic> map) {
    return DownloadTask(
      items: List<DownloadItemm>.from(
        (map['items'] as List<dynamic>).map<DownloadItemm>(
          (item) => DownloadItemm.fromMap(
            Map.from(
              item as Map<String, dynamic>,
            ),
          ),
        ),
      ),
      mbPerSegment: map['mb_per_segment'] as double? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadTask.fromJson(String source) => DownloadTask.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
