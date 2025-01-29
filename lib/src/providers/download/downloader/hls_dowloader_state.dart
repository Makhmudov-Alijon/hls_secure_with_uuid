part of 'hls_downloader_provider.dart';

class HlsDownloaderState extends Equatable {
  const HlsDownloaderState({
    this.status = HlsDownloaderStatus.notDownloading,
    this.noSpace,
  });

  final HlsDownloaderStatus status;

  final LocalHlsId? noSpace;

  HlsDownloaderState copyWith({
    HlsDownloaderStatus? status,
    LocalHlsId? noSpace,
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
