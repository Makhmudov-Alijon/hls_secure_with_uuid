// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

import 'download_item_model.dart';

class DownloadTask extends Equatable {
  const DownloadTask({
    required this.items,
  });

  final List<DownloadItem> items;

  @override
  List<Object?> get props => [items];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory DownloadTask.fromFile(File file) {
    final content = file.readAsStringSync();
    return DownloadTask.fromJson(content);
  }

  factory DownloadTask.fromMap(Map<String, dynamic> map) {
    return DownloadTask(
      items: List<DownloadItem>.from(
        (map['items'] as List<dynamic>).map<DownloadItem>(
          (item) => DownloadItem.fromMap(
            Map.from(
              item as Map<String, dynamic>,
            ),
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadTask.fromJson(String source) => DownloadTask.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
