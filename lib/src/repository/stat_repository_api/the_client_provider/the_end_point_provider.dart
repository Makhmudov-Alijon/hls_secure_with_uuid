import 'package:hooks_riverpod/hooks_riverpod.dart';

final theEndPointsProvider = Provider((ref) {
  return const TheEndPoints();
});

class TheEndPoints {
  const TheEndPoints({
    this.addDownloadedStat = '',
    this.removeDownloadedHlsState = '',
  });

  final String addDownloadedStat;
  final String removeDownloadedHlsState;
}
