// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

class DownloadItem extends Equatable {
  const DownloadItem({
    required this.url,
    this.groupId,
    required this.saveDir,
    required this.fileName,
  });

  final String url;
  final String? groupId;
  final Directory saveDir;
  final String fileName;

  String get absolutePath => '${saveDir.path}/$fileName';

  bool get isDownloaded => File(absolutePath).existsSync();

  @override
  List<Object?> get props => [url, saveDir, fileName, groupId];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'groupId': groupId,
      'saveDir': saveDir.path,
      'fileName': fileName,
    };
  }

  factory DownloadItem.fromMap(Map<String, dynamic> map) {
    return DownloadItem(
      url: map['url'] as String,
      groupId: map['groupId'] != null ? map['groupId'] as String : null,
      saveDir: Directory(map['saveDir'] as String),
      fileName: map['fileName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadItem.fromJson(String source) =>
      DownloadItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
