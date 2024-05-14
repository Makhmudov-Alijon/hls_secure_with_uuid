import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path;

// class HlsLinkSwapper extends Equatable {
//   const HlsLinkSwapper({
//     required this.baseLink,
//     required this.relativeLink,
//     required this.absoluteLink,
//   });
//   factory HlsLinkSwapper.fromFileEntity({
//     required String baseLink,
//     required File file,
//     required Directory baseDir,
//   }) {
//     return HlsLinkSwapper(
//       baseLink: baseLink,
//       relativeLink: path.relative(file.path, from: baseDir.path),
//       absoluteLink: 'file://${file.path}',
//     );
//   }

//   final String baseLink;
//   final String relativeLink;
//   final String absoluteLink;

//   @override
//   List<Object?> get props => [baseLink, relativeLink, absoluteLink];
// }

class HlsLink extends Equatable {
  const HlsLink({
    required this.absolute,
    required this.relative,
  });

  factory HlsLink.fromFileEntity({
    required Directory baseDir,
    required File file,
  }) {
    return HlsLink(
      absolute: 'file://${file.path}',
      relative: path.relative(file.path, from: baseDir.path),
    );
  }

  final String absolute;
  final String relative;

  @override
  List<Object?> get props => [absolute, relative];
}

class HlsLinkSwapper {
  HlsLinkSwapper({
    required this.useAbsolute,
  });

  final bool useAbsolute;
  final Map<String, HlsLink> _links = {};

  void addLinkFromFile({
    required String originalLink,
    required File file,
    required Directory baseDir,
  }) {
    _links[originalLink] = HlsLink.fromFileEntity(baseDir: baseDir, file: file);
  }

  bool get isEmpty {
    return _links.isEmpty;
  }

  String? operator [](String key) {
    final value = _links[key];
    return value == null
        ? null
        : useAbsolute
            ? value.absolute
            : value.relative;
  }
}
