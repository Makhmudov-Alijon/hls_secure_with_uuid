// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_audio.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const HlsAudioTrackSchema = Schema(
  name: r'HlsAudioTrack',
  id: -5653270994295708730,
  properties: {
    r'filesCount': PropertySchema(
      id: 0,
      name: r'filesCount',
      type: IsarType.long,
    ),
    r'playlistBaseUrl': PropertySchema(
      id: 1,
      name: r'playlistBaseUrl',
      type: IsarType.string,
    ),
    r'size': PropertySchema(
      id: 2,
      name: r'size',
      type: IsarType.long,
    ),
    r'trackName': PropertySchema(
      id: 3,
      name: r'trackName',
      type: IsarType.string,
    ),
    r'trackType': PropertySchema(
      id: 4,
      name: r'trackType',
      type: IsarType.byte,
      enumMap: _HlsAudioTracktrackTypeEnumValueMap,
    ),
    r'trackUrl': PropertySchema(
      id: 5,
      name: r'trackUrl',
      type: IsarType.string,
    )
  },
  estimateSize: _hlsAudioTrackEstimateSize,
  serialize: _hlsAudioTrackSerialize,
  deserialize: _hlsAudioTrackDeserialize,
  deserializeProp: _hlsAudioTrackDeserializeProp,
);

int _hlsAudioTrackEstimateSize(
  HlsAudioTrack object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.playlistBaseUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.trackName.length * 3;
  bytesCount += 3 + object.trackUrl.length * 3;
  return bytesCount;
}

void _hlsAudioTrackSerialize(
  HlsAudioTrack object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.filesCount);
  writer.writeString(offsets[1], object.playlistBaseUrl);
  writer.writeLong(offsets[2], object.size);
  writer.writeString(offsets[3], object.trackName);
  writer.writeByte(offsets[4], object.trackType.index);
  writer.writeString(offsets[5], object.trackUrl);
}

HlsAudioTrack _hlsAudioTrackDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HlsAudioTrack(
    filesCount: reader.readLongOrNull(offsets[0]) ?? 0,
    playlistBaseUrl: reader.readStringOrNull(offsets[1]),
    size: reader.readLongOrNull(offsets[2]) ?? 0,
    trackName: reader.readStringOrNull(offsets[3]) ?? '',
    trackType: _HlsAudioTracktrackTypeValueEnumMap[
            reader.readByteOrNull(offsets[4])] ??
        HlsAudioTrackType.defaultTrack,
    trackUrl: reader.readStringOrNull(offsets[5]) ?? '',
  );
  return object;
}

P _hlsAudioTrackDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (_HlsAudioTracktrackTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          HlsAudioTrackType.defaultTrack) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HlsAudioTracktrackTypeEnumValueMap = {
  'low': 0,
  'high': 1,
  'defaultTrack': 2,
};
const _HlsAudioTracktrackTypeValueEnumMap = {
  0: HlsAudioTrackType.low,
  1: HlsAudioTrackType.high,
  2: HlsAudioTrackType.defaultTrack,
};

extension HlsAudioTrackQueryFilter
    on QueryBuilder<HlsAudioTrack, HlsAudioTrack, QFilterCondition> {
  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      filesCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      filesCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      filesCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      filesCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filesCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'playlistBaseUrl',
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'playlistBaseUrl',
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlistBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playlistBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playlistBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playlistBaseUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playlistBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playlistBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playlistBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playlistBaseUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlistBaseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      playlistBaseUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playlistBaseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition> sizeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      sizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      sizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition> sizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackName',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackName',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackTypeEqualTo(HlsAudioTrackType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackType',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackTypeGreaterThan(
    HlsAudioTrackType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackType',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackTypeLessThan(
    HlsAudioTrackType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackType',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackTypeBetween(
    HlsAudioTrackType lower,
    HlsAudioTrackType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsAudioTrack, HlsAudioTrack, QAfterFilterCondition>
      trackUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackUrl',
        value: '',
      ));
    });
  }
}

extension HlsAudioTrackQueryObject
    on QueryBuilder<HlsAudioTrack, HlsAudioTrack, QFilterCondition> {}
