import 'package:download_manager/download_manager.dart';

abstract class LocalHlsState {
  const LocalHlsState({this.progress = 0});
  final double progress;

  LocalHlsState copyWith({double? progress});

  LocalHlsStatus toLocalHlsStatus() {
    switch (runtimeType) {
      case LocalHlsDownloadingState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.downloading,
        );
      case LocalHlsPauseState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.paused,
        );
      case LocalHlsDeletedState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.deleted,
        );
      case LocalHlsCompleteState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.complete,
        );
      case LocalHlsInQueueState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.inQueue,
        );
      case LocalHlsPreparedState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.prepared,
        );
      case LocalHlsErrorState:
        final error = this as LocalHlsErrorState;
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.error,
          message: error.message,
          statusCode: error.statusCode,
        );
      default:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.notExist,
        );
    }
  }
}

class LocalHlsDownloadingState extends LocalHlsState {
  LocalHlsDownloadingState({super.progress});

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsDownloadingState(
      progress: progress ?? this.progress,
    );
  }
}

class LocalHlsErrorState extends LocalHlsState {
  LocalHlsErrorState({
    this.statusCode,
    this.message,
    super.progress,
  });

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsErrorState(
      progress: progress ?? this.progress,
    );
  }

  final int? statusCode;
  final String? message;
}

class LocalHlsPauseState extends LocalHlsState {
  LocalHlsPauseState({super.progress});

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsPauseState(
      progress: progress ?? this.progress,
    );
  }
}

class LocalHlsInQueueState extends LocalHlsState {
  LocalHlsInQueueState({super.progress});

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsInQueueState(
      progress: progress ?? this.progress,
    );
  }
}

class LocalHlsNotExistState extends LocalHlsState {
  LocalHlsNotExistState({super.progress});

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsNotExistState(
      progress: progress ?? this.progress,
    );
  }
}

class LocalHlsCompleteState extends LocalHlsState {
  LocalHlsCompleteState({super.progress});

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsCompleteState(
      progress: progress ?? this.progress,
    );
  }
}

class LocalHlsDeletedState extends LocalHlsState {
  LocalHlsDeletedState({super.progress});

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsDeletedState(
      progress: progress ?? this.progress,
    );
  }
}

class LocalHlsPreparedState extends LocalHlsState {
  LocalHlsPreparedState({super.progress});

  @override
  LocalHlsState copyWith({double? progress}) {
    return LocalHlsPreparedState(
      progress: progress ?? this.progress,
    );
  }
}
