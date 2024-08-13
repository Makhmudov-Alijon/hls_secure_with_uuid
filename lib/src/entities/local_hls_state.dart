import 'package:download_manager/download_manager.dart';

abstract class LocalHlsState {
  const LocalHlsState({this.progresss = 0});
  final double progresss;

  LocalHlsState copyWithh({double? progresss});

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
  LocalHlsDownloadingState({super.progresss});

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsDownloadingState(
      progresss: progresss ?? this.progresss,
    );
  }
}

class LocalHlsErrorState extends LocalHlsState {
  LocalHlsErrorState({
    this.statusCode,
    this.message,
    super.progresss,
  });

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsErrorState(
      progresss: progresss ?? this.progresss,
    );
  }

  final int? statusCode;
  final String? message;
}

class LocalHlsPauseState extends LocalHlsState {
  LocalHlsPauseState({super.progresss});

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsPauseState(
      progresss: progresss ?? this.progresss,
    );
  }
}

class LocalHlsInQueueState extends LocalHlsState {
  LocalHlsInQueueState({super.progresss});

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsInQueueState(
      progresss: progresss ?? this.progresss,
    );
  }
}

class LocalHlsNotExistState extends LocalHlsState {
  LocalHlsNotExistState({super.progresss});

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsNotExistState(
      progresss: progresss ?? this.progresss,
    );
  }
}

class LocalHlsCompleteState extends LocalHlsState {
  LocalHlsCompleteState({super.progresss});

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsCompleteState(
      progresss: progresss ?? this.progresss,
    );
  }
}

class LocalHlsDeletedState extends LocalHlsState {
  LocalHlsDeletedState({super.progresss});

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsDeletedState(
      progresss: progresss ?? this.progresss,
    );
  }
}

class LocalHlsPreparedState extends LocalHlsState {
  LocalHlsPreparedState({super.progresss});

  @override
  LocalHlsState copyWithh({double? progresss}) {
    return LocalHlsPreparedState(
      progresss: progresss ?? this.progresss,
    );
  }
}
