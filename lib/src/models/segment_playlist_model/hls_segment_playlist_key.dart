import 'package:equatable/equatable.dart';

class HlsSegmentsPlaylistKey extends Equatable {
  const HlsSegmentsPlaylistKey({
    required this.encKeyUrl,
    required this.salt,
  });

  final String encKeyUrl;
  final String salt;

  @override
  List<Object?> get props => [encKeyUrl, salt];
}
