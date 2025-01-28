part of 'hls_downloader_provider.dart';

class HlsDownloaderState extends Equatable {
  const HlsDownloaderState({
    this.status = HlsDownloaderStatus.notDownloading,
    this.noSpace = false,
  });

  final HlsDownloaderStatus status;

  final bool noSpace;

  HlsDownloaderState copyWith({
    HlsDownloaderStatus? status,
    bool? noSpace,
  }) =>
      HlsDownloaderState(
        status: status ?? this.status,
        noSpace: noSpace ?? this.noSpace,
      );

  @override
  List<Object?> get props => [
        status,
        noSpace,
      ];
}

enum HlsDownloaderStatus {
  downloading,
  notDownloading,
}
