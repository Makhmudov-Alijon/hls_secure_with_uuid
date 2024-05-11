import 'package:equatable/equatable.dart';

import '../../../../download_manager.dart';

class HlsKey extends Equatable {
  const HlsKey({required this.key});
  final String key;

  @override
  String toString() {
    return key;
  }

  @override
  List<Object?> get props => [key];
}

class HlsParamValue extends Equatable {
  const HlsParamValue({required this.value});
  final String value;

  @override
  String toString() {
    return value;
  }

  HlsParamValue copyWith({
    String? value,
  }) {
    return HlsParamValue(
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [value];
}

class HlsParam extends Equatable {
  const HlsParam({required this.parameter});
  final String parameter;

  @override
  String toString() {
    return parameter;
  }

  HlsParam copyWith({
    String? parameter,
  }) {
    return HlsParam(
      parameter: parameter ?? this.parameter,
    );
  }

  @override
  List<Object?> get props => [parameter];
}

class HlsPlaylistItem {
  const HlsPlaylistItem({
    required this.hlsKey,
    required this.hlsValueParameters,
    this.url,
  });

  final HlsKey hlsKey;
  final Map<HlsParam?, HlsParamValue> hlsValueParameters;
  final String? url;

  bool containsParam({required HlsParam param, HlsParamValue? paramValue}) {
    if (paramValue == null) {
      return hlsValueParameters.keys.contains(param);
    }
    return hlsValueParameters[param] == paramValue;
  }

  HlsPlaylistItem copyWith({
    HlsKey? hlsKey,
    Map<HlsParam?, HlsParamValue>? hlsValueParameters,
    String? url,
  }) {
    return HlsPlaylistItem(
      hlsKey: hlsKey ?? this.hlsKey,
      hlsValueParameters: hlsValueParameters ?? this.hlsValueParameters,
      url: url ?? this.url,
    );
  }

  @override
  String toString() {
    if (hlsValueParameters.isEmpty) {
      if (url == null) {
        return '$hlsKey';
      } else {
        return '$hlsKey\r\n$url';
      }
    } else {
      final valuePairs = <String>[];

      for (final entry in hlsValueParameters.entries) {
        final temp = entry.key == null
            ? entry.value.toString()
            : '${entry.key}=${entry.value}';
        valuePairs.add(temp);
      }

      final temp =
          '$hlsKey:${valuePairs.join(', ')}${hlsKey == HlsKeyConstants.extInf ? ',' : ''}';
      if (url == null) {
        return temp;
      } else {
        return '$temp\r\n$url';
      }
    }
  }
}
