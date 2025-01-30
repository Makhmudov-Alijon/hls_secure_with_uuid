part of 'disk_space_info_provider.dart';

class DiskSpaceInfoState extends Equatable {
  const DiskSpaceInfoState({
    this.occupied = 0.0,
    this.available = 0.0,
    this.total = 0.0,
  });

  final double occupied;
  final double available;
  final double total;

  DiskSpaceInfoState copyWith({
    double? occupied,
    double? available,
    double? total,
  }) =>
      DiskSpaceInfoState(
        occupied: occupied ?? this.occupied,
        available: available ?? this.available,
        total: total ?? this.total,
      );

  bool isAvailable(int bytes) {
    return bytes.toMb < available;
  }

  // bool isAvailable(int bytes) => true;

  @override
  List<Object?> get props => [
        occupied,
        available,
        total,
      ];
}
