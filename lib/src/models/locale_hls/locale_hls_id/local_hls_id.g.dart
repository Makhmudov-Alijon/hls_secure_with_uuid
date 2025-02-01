// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_hls_id.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocalHlsIdSchema = Schema(
  name: r'LocalHlsId',
  id: -7008202528732484075,
  properties: {
    r'contentId': PropertySchema(
      id: 0,
      name: r'contentId',
      type: IsarType.long,
    ),
    r'episodeId': PropertySchema(
      id: 1,
      name: r'episodeId',
      type: IsarType.long,
    ),
    r'seasonId': PropertySchema(
      id: 2,
      name: r'seasonId',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(
      id: 3,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _localHlsIdEstimateSize,
  serialize: _localHlsIdSerialize,
  deserialize: _localHlsIdDeserialize,
  deserializeProp: _localHlsIdDeserializeProp,
);

int _localHlsIdEstimateSize(
  LocalHlsId object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.uuid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _localHlsIdSerialize(
  LocalHlsId object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.contentId);
  writer.writeLong(offsets[1], object.episodeId);
  writer.writeLong(offsets[2], object.seasonId);
  writer.writeString(offsets[3], object.uuid);
}

LocalHlsId _localHlsIdDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalHlsId(
    contentId: reader.readLongOrNull(offsets[0]) ?? -1,
    episodeId: reader.readLongOrNull(offsets[1]),
    seasonId: reader.readLongOrNull(offsets[2]),
    uuid: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _localHlsIdDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LocalHlsIdQueryFilter
    on QueryBuilder<LocalHlsId, LocalHlsId, QFilterCondition> {
  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> contentIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition>
      contentIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> contentIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> contentIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition>
      episodeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'episodeId',
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition>
      episodeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'episodeId',
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> episodeIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition>
      episodeIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> episodeIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> episodeIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> seasonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seasonId',
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition>
      seasonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seasonId',
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> seasonIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition>
      seasonIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> seasonIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> seasonIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uuid',
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uuid',
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsId, LocalHlsId, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension LocalHlsIdQueryObject
    on QueryBuilder<LocalHlsId, LocalHlsId, QFilterCondition> {}
