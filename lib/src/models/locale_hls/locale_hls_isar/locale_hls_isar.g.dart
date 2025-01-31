// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_hls_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalHlsModelIsarCollection on Isar {
  IsarCollection<LocalHlsModelIsar> get localHlsModelIsars => this.collection();
}

const LocalHlsModelIsarSchema = CollectionSchema(
  name: r'LocalHlsModelIsar',
  id: -3787462116817466814,
  properties: {
    r'baseDirPath': PropertySchema(
      id: 0,
      name: r'baseDirPath',
      type: IsarType.string,
    ),
    r'downloadStatus': PropertySchema(
      id: 1,
      name: r'downloadStatus',
      type: IsarType.object,
      target: r'LocalHlsStatus',
    ),
    r'getStatusKey': PropertySchema(
      id: 2,
      name: r'getStatusKey',
      type: IsarType.string,
    ),
    r'hlsDetails': PropertySchema(
      id: 3,
      name: r'hlsDetails',
      type: IsarType.object,
      target: r'LocalHlsDetailsModel',
    ),
    r'iD': PropertySchema(
      id: 4,
      name: r'iD',
      type: IsarType.object,
      target: r'LocalHlsId',
    ),
    r'iv': PropertySchema(
      id: 5,
      name: r'iv',
      type: IsarType.string,
    ),
    r'masterDirPath': PropertySchema(
      id: 6,
      name: r'masterDirPath',
      type: IsarType.string,
    ),
    r'masterFilePath': PropertySchema(
      id: 7,
      name: r'masterFilePath',
      type: IsarType.string,
    ),
    r'posterFilePath': PropertySchema(
      id: 8,
      name: r'posterFilePath',
      type: IsarType.string,
    ),
    r'totalSegments': PropertySchema(
      id: 9,
      name: r'totalSegments',
      type: IsarType.long,
    )
  },
  estimateSize: _localHlsModelIsarEstimateSize,
  serialize: _localHlsModelIsarSerialize,
  deserialize: _localHlsModelIsarDeserialize,
  deserializeProp: _localHlsModelIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'LocalHlsDetailsModel': LocalHlsDetailsModelSchema,
    r'LocalHlsId': LocalHlsIdSchema,
    r'HlsResolution': HlsResolutionSchema,
    r'HlsAudioTrack': HlsAudioTrackSchema,
    r'LocalHlsStatus': LocalHlsStatusSchema
  },
  getId: _localHlsModelIsarGetId,
  getLinks: _localHlsModelIsarGetLinks,
  attach: _localHlsModelIsarAttach,
  version: '3.1.0+1',
);

int _localHlsModelIsarEstimateSize(
  LocalHlsModelIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.baseDirPath.length * 3;
  {
    final value = object.downloadStatus;
    if (value != null) {
      bytesCount += 3 +
          LocalHlsStatusSchema.estimateSize(
              value, allOffsets[LocalHlsStatus]!, allOffsets);
    }
  }
  bytesCount += 3 + object.getStatusKey.length * 3;
  bytesCount += 3 +
      LocalHlsDetailsModelSchema.estimateSize(
          object.hlsDetails, allOffsets[LocalHlsDetailsModel]!, allOffsets);
  bytesCount += 3 +
      LocalHlsIdSchema.estimateSize(
          object.iD, allOffsets[LocalHlsId]!, allOffsets);
  bytesCount += 3 + object.iv.length * 3;
  bytesCount += 3 + object.masterDirPath.length * 3;
  bytesCount += 3 + object.masterFilePath.length * 3;
  bytesCount += 3 + object.posterFilePath.length * 3;
  return bytesCount;
}

void _localHlsModelIsarSerialize(
  LocalHlsModelIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.baseDirPath);
  writer.writeObject<LocalHlsStatus>(
    offsets[1],
    allOffsets,
    LocalHlsStatusSchema.serialize,
    object.downloadStatus,
  );
  writer.writeString(offsets[2], object.getStatusKey);
  writer.writeObject<LocalHlsDetailsModel>(
    offsets[3],
    allOffsets,
    LocalHlsDetailsModelSchema.serialize,
    object.hlsDetails,
  );
  writer.writeObject<LocalHlsId>(
    offsets[4],
    allOffsets,
    LocalHlsIdSchema.serialize,
    object.iD,
  );
  writer.writeString(offsets[5], object.iv);
  writer.writeString(offsets[6], object.masterDirPath);
  writer.writeString(offsets[7], object.masterFilePath);
  writer.writeString(offsets[8], object.posterFilePath);
  writer.writeLong(offsets[9], object.totalSegments);
}

LocalHlsModelIsar _localHlsModelIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalHlsModelIsar(
    baseDirPath: reader.readStringOrNull(offsets[0]) ?? '',
    downloadStatus: reader.readObjectOrNull<LocalHlsStatus>(
      offsets[1],
      LocalHlsStatusSchema.deserialize,
      allOffsets,
    ),
    hlsDetails: reader.readObjectOrNull<LocalHlsDetailsModel>(
          offsets[3],
          LocalHlsDetailsModelSchema.deserialize,
          allOffsets,
        ) ??
        const LocalHlsDetailsModel(),
    iv: reader.readStringOrNull(offsets[5]) ?? '',
    masterDirPath: reader.readStringOrNull(offsets[6]) ?? '',
    masterFilePath: reader.readStringOrNull(offsets[7]) ?? '',
    posterFilePath: reader.readStringOrNull(offsets[8]) ?? '',
    totalSegments: reader.readLongOrNull(offsets[9]) ?? 0,
  );
  object.id = id;
  return object;
}

P _localHlsModelIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readObjectOrNull<LocalHlsStatus>(
        offset,
        LocalHlsStatusSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<LocalHlsDetailsModel>(
            offset,
            LocalHlsDetailsModelSchema.deserialize,
            allOffsets,
          ) ??
          const LocalHlsDetailsModel()) as P;
    case 4:
      return (reader.readObjectOrNull<LocalHlsId>(
            offset,
            LocalHlsIdSchema.deserialize,
            allOffsets,
          ) ??
          LocalHlsId()) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localHlsModelIsarGetId(LocalHlsModelIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localHlsModelIsarGetLinks(
    LocalHlsModelIsar object) {
  return [];
}

void _localHlsModelIsarAttach(
    IsarCollection<dynamic> col, Id id, LocalHlsModelIsar object) {
  object.id = id;
}

extension LocalHlsModelIsarQueryWhereSort
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QWhere> {
  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalHlsModelIsarQueryWhere
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QWhereClause> {
  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalHlsModelIsarQueryFilter
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QFilterCondition> {
  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseDirPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'baseDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'baseDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'baseDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'baseDirPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseDirPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      baseDirPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'baseDirPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      downloadStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadStatus',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      downloadStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadStatus',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'getStatusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'getStatusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'getStatusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getStatusKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'getStatusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'getStatusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'getStatusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'getStatusKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'getStatusKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      getStatusKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'getStatusKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iv',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iv',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iv',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      ivIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iv',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'masterDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'masterDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'masterDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'masterDirPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'masterDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'masterDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'masterDirPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'masterDirPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'masterDirPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterDirPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'masterDirPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'masterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'masterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'masterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'masterFilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'masterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'masterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'masterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'masterFilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'masterFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      masterFilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'masterFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterFilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterFilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      posterFilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      totalSegmentsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSegments',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      totalSegmentsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSegments',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      totalSegmentsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSegments',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      totalSegmentsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSegments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalHlsModelIsarQueryObject
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QFilterCondition> {
  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      downloadStatus(FilterQuery<LocalHlsStatus> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'downloadStatus');
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition>
      hlsDetails(FilterQuery<LocalHlsDetailsModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'hlsDetails');
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterFilterCondition> iD(
      FilterQuery<LocalHlsId> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'iD');
    });
  }
}

extension LocalHlsModelIsarQueryLinks
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QFilterCondition> {}

extension LocalHlsModelIsarQuerySortBy
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QSortBy> {
  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByBaseDirPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirPath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByBaseDirPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirPath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByGetStatusKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getStatusKey', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByGetStatusKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getStatusKey', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy> sortByIv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iv', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByIvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iv', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByMasterDirPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterDirPath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByMasterDirPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterDirPath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByMasterFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterFilePath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByMasterFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterFilePath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByPosterFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterFilePath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByPosterFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterFilePath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByTotalSegments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSegments', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      sortByTotalSegmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSegments', Sort.desc);
    });
  }
}

extension LocalHlsModelIsarQuerySortThenBy
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QSortThenBy> {
  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByBaseDirPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirPath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByBaseDirPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirPath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByGetStatusKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getStatusKey', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByGetStatusKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getStatusKey', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy> thenByIv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iv', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByIvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iv', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByMasterDirPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterDirPath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByMasterDirPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterDirPath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByMasterFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterFilePath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByMasterFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterFilePath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByPosterFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterFilePath', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByPosterFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterFilePath', Sort.desc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByTotalSegments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSegments', Sort.asc);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QAfterSortBy>
      thenByTotalSegmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSegments', Sort.desc);
    });
  }
}

extension LocalHlsModelIsarQueryWhereDistinct
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct> {
  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct>
      distinctByBaseDirPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseDirPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct>
      distinctByGetStatusKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'getStatusKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct> distinctByIv(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iv', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct>
      distinctByMasterDirPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'masterDirPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct>
      distinctByMasterFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'masterFilePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct>
      distinctByPosterFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterFilePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QDistinct>
      distinctByTotalSegments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSegments');
    });
  }
}

extension LocalHlsModelIsarQueryProperty
    on QueryBuilder<LocalHlsModelIsar, LocalHlsModelIsar, QQueryProperty> {
  QueryBuilder<LocalHlsModelIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalHlsModelIsar, String, QQueryOperations>
      baseDirPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseDirPath');
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsStatus?, QQueryOperations>
      downloadStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadStatus');
    });
  }

  QueryBuilder<LocalHlsModelIsar, String, QQueryOperations>
      getStatusKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'getStatusKey');
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsDetailsModel, QQueryOperations>
      hlsDetailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hlsDetails');
    });
  }

  QueryBuilder<LocalHlsModelIsar, LocalHlsId, QQueryOperations> iDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iD');
    });
  }

  QueryBuilder<LocalHlsModelIsar, String, QQueryOperations> ivProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iv');
    });
  }

  QueryBuilder<LocalHlsModelIsar, String, QQueryOperations>
      masterDirPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'masterDirPath');
    });
  }

  QueryBuilder<LocalHlsModelIsar, String, QQueryOperations>
      masterFilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'masterFilePath');
    });
  }

  QueryBuilder<LocalHlsModelIsar, String, QQueryOperations>
      posterFilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterFilePath');
    });
  }

  QueryBuilder<LocalHlsModelIsar, int, QQueryOperations>
      totalSegmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSegments');
    });
  }
}
