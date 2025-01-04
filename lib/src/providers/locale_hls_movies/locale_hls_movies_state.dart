part of 'local_hls_movies_provider.dart';

class LocaleHlsMoviesState extends Equatable {
  const LocaleHlsMoviesState({
    this.downloadedS = const [],
    this.rawItems = const [],
    this.total = const [],
    this.trigger = false,
  });

  LocaleHlsMoviesState copyWith({
    List<LocalHlsGroupModel>? downloadedS,
    List<LocalHlsModel>? rawItems,
    List<LocalHlsModel>? total,
    bool? trigger,
  }) =>
      LocaleHlsMoviesState(
        rawItems: rawItems ?? this.rawItems,
        downloadedS: downloadedS ?? this.downloadedS,
        total: total ?? this.total,
        trigger: trigger ?? this.trigger,
      );

  final List<LocalHlsGroupModel> downloadedS;
  final List<LocalHlsModel> rawItems;
  final List<LocalHlsModel> total;
  final bool trigger;

  bool get isEmpty => total.isEmpty;

  int get itemCountForListView => rawItems.length + downloadedS.length + 1;

  @override
  List<Object?> get props => [
        downloadedS,
        rawItems,
        trigger,
      ];
}

class SortIsolateParams {
  const SortIsolateParams({
    required this.data,
    required this.sendPort,
  });

  final SendPort sendPort;
  final List<LocalHlsModel> data;
}

class LoadMoviesParams {
  const LoadMoviesParams({
    required this.isInitial,
    required this.sendPort,
    required this.mediaDir,
  });

  final SendPort sendPort;
  final bool isInitial;
  final Directory mediaDir;
}
