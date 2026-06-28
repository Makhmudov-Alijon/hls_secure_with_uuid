// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_resolution.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const HlsResolutionSchema = Schema(
  name: r'HlsResolution',
  id: 402197790564224843,
  properties: {
    r'filesCount': PropertySchema(
      id: 0,
      name: r'filesCount',
      type: IsarType.long,
    ),
    r'resolution': PropertySchema(
      id: 1,
      name: r'resolution',
      type: IsarType.byte,
      enumMap: _HlsResolutionresolutionEnumValueMap,
    ),
    r'size': PropertySchema(id: 2, name: r'size', type: IsarType.long),
    r'trackType': PropertySchema(
      id: 3,
      name: r'trackType',
      type: IsarType.byte,
      enumMap: _HlsResolutiontrackTypeEnumValueMap,
    ),
    r'videoPlaylistUrl': PropertySchema(
      id: 4,
      name: r'videoPlaylistUrl',
      type: IsarType.string,
    ),
  },

  estimateSize: _hlsResolutionEstimateSize,
  serialize: _hlsResolutionSerialize,
  deserialize: _hlsResolutionDeserialize,
  deserializeProp: _hlsResolutionDeserializeProp,
);

int _hlsResolutionEstimateSize(
  HlsResolution object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.videoPlaylistUrl.length * 3;
  return bytesCount;
}

void _hlsResolutionSerialize(
  HlsResolution object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.filesCount);
  writer.writeByte(offsets[1], object.resolution.index);
  writer.writeLong(offsets[2], object.size);
  writer.writeByte(offsets[3], object.trackType.index);
  writer.writeString(offsets[4], object.videoPlaylistUrl);
}

HlsResolution _hlsResolutionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HlsResolution(
    filesCount: reader.readLongOrNull(offsets[0]) ?? 0,
    resolution:
        _HlsResolutionresolutionValueEnumMap[reader.readByteOrNull(
          offsets[1],
        )] ??
        HlsResolutionType.v480p,
    size: reader.readLongOrNull(offsets[2]) ?? 0,
    trackType:
        _HlsResolutiontrackTypeValueEnumMap[reader.readByteOrNull(
          offsets[3],
        )] ??
        HlsAudioTrackType.defaultTrack,
    videoPlaylistUrl: reader.readStringOrNull(offsets[4]) ?? '',
  );
  return object;
}

P _hlsResolutionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (_HlsResolutionresolutionValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              HlsResolutionType.v480p)
          as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (_HlsResolutiontrackTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              HlsAudioTrackType.defaultTrack)
          as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HlsResolutionresolutionEnumValueMap = {
  'v240p': 0,
  'v360p': 1,
  'v480p': 2,
  'v720p': 3,
  'v1080p': 4,
  'v2k': 5,
  'v4k': 6,
};
const _HlsResolutionresolutionValueEnumMap = {
  0: HlsResolutionType.v240p,
  1: HlsResolutionType.v360p,
  2: HlsResolutionType.v480p,
  3: HlsResolutionType.v720p,
  4: HlsResolutionType.v1080p,
  5: HlsResolutionType.v2k,
  6: HlsResolutionType.v4k,
};
const _HlsResolutiontrackTypeEnumValueMap = {
  'low': 0,
  'high': 1,
  'defaultTrack': 2,
};
const _HlsResolutiontrackTypeValueEnumMap = {
  0: HlsAudioTrackType.low,
  1: HlsAudioTrackType.high,
  2: HlsAudioTrackType.defaultTrack,
};

extension HlsResolutionQueryFilter
    on QueryBuilder<HlsResolution, HlsResolution, QFilterCondition> {
  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  filesCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filesCount', value: value),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  filesCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'filesCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  filesCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'filesCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  filesCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'filesCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  resolutionEqualTo(HlsResolutionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resolution', value: value),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  resolutionGreaterThan(HlsResolutionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resolution',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  resolutionLessThan(HlsResolutionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resolution',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  resolutionBetween(
    HlsResolutionType lower,
    HlsResolutionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resolution',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition> sizeEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'size', value: value),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  sizeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'size',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  sizeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'size',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition> sizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'size',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  trackTypeEqualTo(HlsAudioTrackType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trackType', value: value),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  trackTypeGreaterThan(HlsAudioTrackType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'trackType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  trackTypeLessThan(HlsAudioTrackType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'trackType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  trackTypeBetween(
    HlsAudioTrackType lower,
    HlsAudioTrackType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'trackType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'videoPlaylistUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoPlaylistUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoPlaylistUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoPlaylistUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'videoPlaylistUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'videoPlaylistUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'videoPlaylistUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'videoPlaylistUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoPlaylistUrl', value: ''),
      );
    });
  }

  QueryBuilder<HlsResolution, HlsResolution, QAfterFilterCondition>
  videoPlaylistUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoPlaylistUrl', value: ''),
      );
    });
  }
}

extension HlsResolutionQueryObject
    on QueryBuilder<HlsResolution, HlsResolution, QFilterCondition> {}
