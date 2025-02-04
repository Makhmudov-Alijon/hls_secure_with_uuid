import 'package:equatable/equatable.dart';

class VTTImage extends Equatable {
  const VTTImage({required this.box, required this.imageUrl});

  factory VTTImage.fromStringWithRelativeUrl({
    required String string,
    required String playlistBaseUrl,
    required String baseUrl,
  }) {
    try {
      final splitted = string.split('#');
      return VTTImage(
        box: VTTImageBox.fromString(splitted[1]),
        imageUrl: [baseUrl, playlistBaseUrl, splitted[0]].join('/'),
      );
    } catch (e) {
      throw const FormatException('VTTImage has invalid format');
    }
  }

  factory VTTImage.fromString({
    required String string,
  }) {
    try {
      final splitted = string.split('#');
      return VTTImage(
        box: VTTImageBox.fromString(splitted[1]),
        imageUrl: splitted[0],
      );
    } catch (e) {
      throw const FormatException('VTTImage has invalid format');
    }
  }

  @override
  String toString() {
    return [imageUrl, box.toString()].join('#');
  }

  final VTTImageBox box;
  final String imageUrl;

  @override
  List<Object?> get props => [box, imageUrl];
}

class VTTImageBox extends Equatable {
  const VTTImageBox({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  factory VTTImageBox.fromString(String string) {
    try {
      final temp = string.split('=').last;
      final splitted = temp.split(',');

      return VTTImageBox(
        x: int.parse(splitted[0]),
        y: int.parse(splitted[1]),
        w: int.parse(splitted[2]),
        h: int.parse(splitted[3]),
      );
    } catch (e) {
      throw const FormatException(
        'VTTImageBox has incorrect data',
      );
    }
  }

  @override
  String toString() {
    return 'xywh=$x,$y,$w,$h';
  }

  final int x;
  final int y;
  final int w;
  final int h;

  @override
  List<Object?> get props => [x, y, w, h];
}
