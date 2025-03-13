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
        x: double.parse(splitted[0]),
        y: double.parse(splitted[1]),
        w: double.parse(splitted[2]),
        h: double.parse(splitted[3]),
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

  final double x;
  final double y;
  final double w;
  final double h;

  @override
  List<Object?> get props => [x, y, w, h];
}
