// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

enum LocalHlsStatusType {
  complete,
  downloading,
  paused,
  inQueue,
  notExist,
  deleted,
  error;
}

class LocalHlsStatus extends Equatable {
  LocalHlsStatus({
    required this.statusType,
    DateTime? creationDate,
    this.message,
    this.statusCode,
  }) {
    if (creationDate == null) {
      this.creationDate = DateTime.now();
    } else {
      this.creationDate = creationDate;
    }
  }

  final LocalHlsStatusType statusType;
  final String? message;
  final int? statusCode;
  late final DateTime creationDate;

  @override
  List<Object?> get props => [statusType, message, statusCode];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusType': statusType.name,
      'message': message,
      'statusCode': statusCode,
      'creationDate': creationDate.toUtc().toIso8601String(),
    };
  }

  factory LocalHlsStatus.fromMap(Map<String, dynamic> map) {
    return LocalHlsStatus(
      statusType: LocalHlsStatusType.values.firstWhere(
        (element) => element.name == map['statusType'] as String,
      ),
      message: map['message'] != null ? map['message'] as String : null,
      statusCode: map['statusCode'] as int?,
      creationDate: DateTime.parse(map['creationDate'] as String).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalHlsStatus.fromJson(String source) =>
      LocalHlsStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  LocalHlsStatus copyWith({
    LocalHlsStatusType? statusType,
    String? message,
    int? statusCode,
    DateTime? creationDate,
  }) {
    return LocalHlsStatus(
      statusType: statusType ?? this.statusType,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      creationDate: creationDate ?? this.creationDate,
    );
  }
}
