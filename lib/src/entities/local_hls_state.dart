import 'package:hls_secure_with_uuid/hls_secure_with_uuid.dart';

extension LocaleHlsStateExtension on LocalHlsState {
  int get getOrder {
    switch (runtimeType) {
      case LocalHlsDownloadingState:
        {
          return 0;
        }
      case LocalHlsWaitingForNetworkState:
        {
          return 1;
        }
      case LocalHlsInQueueState:
        {
          return 2;
        }
      case LocalHlsPauseState:
        {
          return 3;
        }
      case LocalHlsErrorState:
        {
          return 4;
        }
      default:
        return 5;
    }
  }
}

abstract class LocalHlsState {
  const LocalHlsState({
    this.progress = 0,
  });

  final double progress;

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
      case LocalHlsWaitingForNetworkState:
        return LocalHlsStatus(
          statusType: LocalHlsStatusType.waitingForNetwork,
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
  LocalHlsDownloadingState({
    this.speed,
    double? progress,
  }) : super(progress: progress ?? 0.0);

  double? speed;
}

class LocalHlsErrorState extends LocalHlsState {
  LocalHlsErrorState({
    this.statusCode,
    this.message,
    super.progress,
  });

  final int? statusCode;
  final String? message;
}

class LocalHlsPauseState extends LocalHlsState {
  LocalHlsPauseState({super.progress});
}

class LocalHlsWaitingForNetworkState extends LocalHlsState {
  LocalHlsWaitingForNetworkState({super.progress});
}

class LocalHlsInQueueState extends LocalHlsState {
  LocalHlsInQueueState({super.progress});
}

class LocalHlsNotExistState extends LocalHlsState {
  LocalHlsNotExistState({super.progress});
}

class LocalHlsCompleteState extends LocalHlsState {
  LocalHlsCompleteState({super.progress});
}

class LocalHlsDeletedState extends LocalHlsState {
  LocalHlsDeletedState({super.progress});
}

class LocalHlsPreparedState extends LocalHlsState {
  LocalHlsPreparedState({super.progress});
}
