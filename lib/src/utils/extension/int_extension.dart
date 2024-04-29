extension IntExtension on int {
  String formatBytes(int decimals) {
    const int oneKB = 1024;
    const int oneMB = 1024 * oneKB;
    const int oneGB = 1024 * oneMB;
    const int oneTB = 1024 * oneGB;

    if (this >= oneTB) {
      return '${(this / oneTB).toStringAsFixed(decimals)} ТБ';
    } else if (this >= oneGB) {
      return '${(this / oneGB).toStringAsFixed(decimals)} ГБ';
    } else if (this >= oneMB) {
      return '${(this / oneMB).toStringAsFixed(decimals)} МБ';
    } else if (this >= oneKB) {
      return '${(this / oneKB).toStringAsFixed(decimals)} КБ';
    } else {
      return '$this Байт';
    }
  }
}
