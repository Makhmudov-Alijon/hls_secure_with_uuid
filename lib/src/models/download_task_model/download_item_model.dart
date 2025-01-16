// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

class DownloadItemm extends Equatable {
  const DownloadItemm({
    required this.url,
    required this.saveDir,
    required this.fileName,
    this.groupId,
  });

  final String url;
  final String? groupId;
  final Directory saveDir;
  final String fileName;

  String get absolutePath => '${saveDir.path}/$fileName';

  bool get isDownloaded {
    // final file = File(absolutePath);
    // file.length().then((v) {
    //   print('>< >< the segment size : ${v}');
    // });
    return File(absolutePath).existsSync();
  }

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

  factory DownloadItemm.fromMap(Map<String, dynamic> map) {
    return DownloadItemm(
      url: map['url'] as String,
      groupId: map['groupId'] != null ? map['groupId'] as String : null,
      saveDir: Directory(map['saveDir'] as String),
      fileName: map['fileName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  ({
    String url,
    String absPath,
  }) get getForIsolate => (
        url: url,
        absPath: absolutePath,
      );

  factory DownloadItemm.fromJson(String source) =>
      DownloadItemm.fromMap(json.decode(source) as Map<String, dynamic>);
}
