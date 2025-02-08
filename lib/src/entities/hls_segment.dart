import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

class HlsSegment extends Equatable {
  const HlsSegment({
    required this.link,
    required this.isVideo,
    required this.duration,
    required this.saveFile,
  });

  factory HlsSegment.fromMap(Map<String, dynamic> map) {
    return HlsSegment(
      link: map['link'] as String,
      isVideo: map['isVideo'] as bool,
      duration: double.parse(map['duration'] as String),
      saveFile: File(map['saveFile'] as String),
    );
  }

  factory HlsSegment.fromJson(String source) =>
      HlsSegment.fromMap(json.decode(source) as Map<String, dynamic>);

  final String link;

  final File saveFile;

  final bool isVideo;

  final double duration;

  Map<String, String> get queryParams {
    final temp = link.split('?');
    final queries = <String, String>{};
    if (temp.length > 1) {
      final queryParams = temp[1];
      final splittedParams = queryParams.split('&');
      for (final param in splittedParams) {
        final temp = param.split('=');
        final paramKey = temp.first;
        final paramValue = temp.last;
        queries[paramKey] = paramValue;
      }
    }
    return queries;
  }

  @override
  List<Object?> get props => [link, isVideo, saveFile, duration];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'link': link,
      'isVideo': isVideo,
      'duration': duration,
      'saveFile': saveFile.path,
    };
  }

  String toJson() => json.encode(toMap());
}
