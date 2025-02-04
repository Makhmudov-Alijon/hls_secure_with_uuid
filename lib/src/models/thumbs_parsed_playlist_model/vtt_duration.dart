import 'package:equatable/equatable.dart';

class VTTDurationRange extends Equatable {
  const VTTDurationRange({
    required this.startDuration,
    required this.endDuration,
  });

  factory VTTDurationRange.fromString(String string) {
    try {
      final splittedString = string.split(' --> ');
      return VTTDurationRange(
        startDuration: VTTDuration.fromString(splittedString[0]),
        endDuration: VTTDuration.fromString(splittedString[1]),
      );
    } catch (e) {
      throw const FormatException('VTTDurationRange has invalid format');
    }
  }

  @override
  String toString() {
    return '$startDuration --> $endDuration';
  }

  final VTTDuration startDuration;
  final VTTDuration endDuration;

  @override
  List<Object?> get props => [startDuration, endDuration];
}

class VTTDuration extends Equatable {
  const VTTDuration({required this.duration});

  factory VTTDuration.fromString(String time) {
    try {
      final regex = RegExp(r'(\d+):(\d+):(\d+).(\d+)');
      final match = regex.firstMatch(time);

      if (match == null) {
        throw FormatException(
          'VTTDuration Invalid time format: $time',
        );
      }

      final hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final seconds = int.parse(match.group(3)!);
      final milliseconds = int.parse(match.group(4)!);

      return VTTDuration(
        duration: Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          milliseconds: milliseconds,
        ),
      );
    } catch (e) {
      throw const FormatException('VTTDuration has invalid format');
    }
  }

  @override
  String toString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds.000';
  }

  final Duration duration;

  @override
  List<Object?> get props => [duration];
}
