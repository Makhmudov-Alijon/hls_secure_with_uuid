// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_hls_details_model.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocalHlsDetailsModelSchema = Schema(
  name: r'LocalHlsDetailsModel',
  id: 7493520627150096025,
  properties: {
    r'audioTracks': PropertySchema(
      id: 0,
      name: r'audioTracks',
      type: IsarType.objectList,
      target: r'HlsAudioTrack',
    ),
    r'episodeNum': PropertySchema(
      id: 1,
      name: r'episodeNum',
      type: IsarType.long,
    ),
    r'isSerial': PropertySchema(
      id: 2,
      name: r'isSerial',
      type: IsarType.bool,
    ),
    r'localHlsId': PropertySchema(
      id: 3,
      name: r'localHlsId',
      type: IsarType.object,
      target: r'LocalHlsId',
    ),
    r'resolution': PropertySchema(
      id: 4,
      name: r'resolution',
      type: IsarType.object,
      target: r'HlsResolution',
    ),
    r'seasonNum': PropertySchema(
      id: 5,
      name: r'seasonNum',
      type: IsarType.long,
    ),
    r'sizeBytes': PropertySchema(
      id: 6,
      name: r'sizeBytes',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _localHlsDetailsModelEstimateSize,
  serialize: _localHlsDetailsModelSerialize,
  deserialize: _localHlsDetailsModelDeserialize,
  deserializeProp: _localHlsDetailsModelDeserializeProp,
);

int _localHlsDetailsModelEstimateSize(
  LocalHlsDetailsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.audioTracks.length * 3;
  {
    final offsets = allOffsets[HlsAudioTrack]!;
    for (var i = 0; i < object.audioTracks.length; i++) {
      final value = object.audioTracks[i];
      bytesCount +=
          HlsAudioTrackSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 +
      LocalHlsIdSchema.estimateSize(
          object.localHlsId, allOffsets[LocalHlsId]!, allOffsets);
  bytesCount += 3 +
      HlsResolutionSchema.estimateSize(
          object.resolution, allOffsets[HlsResolution]!, allOffsets);
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _localHlsDetailsModelSerialize(
  LocalHlsDetailsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<HlsAudioTrack>(
    offsets[0],
    allOffsets,
    HlsAudioTrackSchema.serialize,
    object.audioTracks,
  );
  writer.writeLong(offsets[1], object.episodeNum);
  writer.writeBool(offsets[2], object.isSerial);
  writer.writeObject<LocalHlsId>(
    offsets[3],
    allOffsets,
    LocalHlsIdSchema.serialize,
    object.localHlsId,
  );
  writer.writeObject<HlsResolution>(
    offsets[4],
    allOffsets,
    HlsResolutionSchema.serialize,
    object.resolution,
  );
  writer.writeLong(offsets[5], object.seasonNum);
  writer.writeLong(offsets[6], object.sizeBytes);
  writer.writeString(offsets[7], object.title);
}

LocalHlsDetailsModel _localHlsDetailsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalHlsDetailsModel(
    audioTracks: reader.readObjectList<HlsAudioTrack>(
          offsets[0],
          HlsAudioTrackSchema.deserialize,
          allOffsets,
          HlsAudioTrack(),
        ) ??
        const [],
    episodeNum: reader.readLongOrNull(offsets[1]),
    isSerial: reader.readBoolOrNull(offsets[2]) ?? false,
    localHlsId: reader.readObjectOrNull<LocalHlsId>(
          offsets[3],
          LocalHlsIdSchema.deserialize,
          allOffsets,
        ) ??
        const LocalHlsId(),
    resolution: reader.readObjectOrNull<HlsResolution>(
          offsets[4],
          HlsResolutionSchema.deserialize,
          allOffsets,
        ) ??
        const HlsResolution(),
    seasonNum: reader.readLongOrNull(offsets[5]),
    title: reader.readStringOrNull(offsets[7]) ?? '',
  );
  return object;
}

P _localHlsDetailsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<HlsAudioTrack>(
            offset,
            HlsAudioTrackSchema.deserialize,
            allOffsets,
            HlsAudioTrack(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readObjectOrNull<LocalHlsId>(
            offset,
            LocalHlsIdSchema.deserialize,
            allOffsets,
          ) ??
          const LocalHlsId()) as P;
    case 4:
      return (reader.readObjectOrNull<HlsResolution>(
            offset,
            HlsResolutionSchema.deserialize,
            allOffsets,
          ) ??
          const HlsResolution()) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LocalHlsDetailsModelQueryFilter on QueryBuilder<LocalHlsDetailsModel,
    LocalHlsDetailsModel, QFilterCondition> {
  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> audioTracksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTracks',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> audioTracksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTracks',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> audioTracksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTracks',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> audioTracksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTracks',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> audioTracksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTracks',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> audioTracksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTracks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> episodeNumIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'episodeNum',
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> episodeNumIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'episodeNum',
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> episodeNumEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeNum',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> episodeNumGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeNum',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> episodeNumLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeNum',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> episodeNumBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeNum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> isSerialEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSerial',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> seasonNumIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seasonNum',
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> seasonNumIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seasonNum',
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> seasonNumEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonNum',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> seasonNumGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonNum',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> seasonNumLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonNum',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> seasonNumBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonNum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> sizeBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> sizeBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> sizeBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> sizeBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension LocalHlsDetailsModelQueryObject on QueryBuilder<LocalHlsDetailsModel,
    LocalHlsDetailsModel, QFilterCondition> {
  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> audioTracksElement(FilterQuery<HlsAudioTrack> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'audioTracks');
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> localHlsId(FilterQuery<LocalHlsId> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'localHlsId');
    });
  }

  QueryBuilder<LocalHlsDetailsModel, LocalHlsDetailsModel,
      QAfterFilterCondition> resolution(FilterQuery<HlsResolution> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'resolution');
    });
  }
}
