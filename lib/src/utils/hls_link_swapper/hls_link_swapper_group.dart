import 'package:download_manager/download_manager.dart';

class HlsLinkSwapperGroup {
  HlsLinkSwapperGroup({required this.swappers});

  final List<HlsLinkSwapper> swappers;

  String? operator [](String key) {
    for (final swapper in swappers) {
      if (swapper[key] != null) {
        return swapper[key];
      }
    }
    return null;
  }

  bool get isEmpty {
    for (final swapper in swappers) {
      if (!swapper.isEmpty) {
        return false;
      }
    }
    return true;
  }
}
