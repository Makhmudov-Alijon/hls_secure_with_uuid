import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'download_item_model.g.dart';

@Embedded(inheritance: false)
class DownloadItem extends Equatable {
  DownloadItem({
    this.url = '',
    this.saveDirPath = '',
    this.fileName = '',
    this.groupId = '',
  });

  String url;
  String groupId;
  String saveDirPath;
  String fileName;

  @ignore
  String get absolutePath => '$saveDirPath/$fileName';

  @ignore
  Directory get saveDir => Directory(saveDirPath);

  set saveDir(Directory dir) => saveDirPath = dir.path;

  @ignore
  bool get isDownloaded {

    return File(absolutePath).existsSync();
  }

  @ignore
  @override
  List<Object?> get props => [url, saveDirPath, fileName, groupId];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'groupId': groupId,
      'saveDir': saveDirPath,
      'fileName': fileName,
    };
  }

  factory DownloadItem.fromMap(Map<String, dynamic> map) {
    return DownloadItem(
      url: map['url'] as String,
      // groupId: map['groupId'] != null ? map['groupId'] as String : '-1',
      saveDirPath: map['saveDir'] as String,
      fileName: map['fileName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @ignore
  ({
    String url,
    String absPath,
  }) get getForIsolate => (
        url: url,
        absPath: absolutePath,
      );

  @ignore
  MapEntry<String, String> get getForIsolateMap => MapEntry(
        absolutePath,
        url,
      );

  factory DownloadItem.fromJson(String source) =>
      DownloadItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
