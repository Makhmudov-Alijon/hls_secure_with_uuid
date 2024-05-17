import 'package:equatable/equatable.dart';

class HlsEncryptionKey extends Equatable{
  const HlsEncryptionKey({required this.url});

  final String url;
  
  @override
  List<Object?> get props => [url];
}
