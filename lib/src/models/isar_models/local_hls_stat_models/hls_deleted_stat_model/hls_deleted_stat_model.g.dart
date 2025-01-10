// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_deleted_stat_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHlsDeletedStatModelCollection on Isar {
  IsarCollection<HlsDeletedStatModel> get hlsDeletedStatModels =>
      this.collection();
}

const HlsDeletedStatModelSchema = CollectionSchema(
  name: r'HlsDeletedStatModel',
  id: 8995336069251226838,
  properties: {
    r'contentId': PropertySchema(
      id: 0,
      name: r'contentId',
      type: IsarType.long,
    ),
    r'entireContent': PropertySchema(
      id: 1,
      name: r'entireContent',
      type: IsarType.bool,
    ),
    r'episodeId': PropertySchema(
      id: 2,
      name: r'episodeId',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    )
  },
  estimateSize: _hlsDeletedStatModelEstimateSize,
  serialize: _hlsDeletedStatModelSerialize,
  deserialize: _hlsDeletedStatModelDeserialize,
  deserializeProp: _hlsDeletedStatModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hlsDeletedStatModelGetId,
  getLinks: _hlsDeletedStatModelGetLinks,
  attach: _hlsDeletedStatModelAttach,
  version: '3.1.0+1',
);

int _hlsDeletedStatModelEstimateSize(
  HlsDeletedStatModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _hlsDeletedStatModelSerialize(
  HlsDeletedStatModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.contentId);
  writer.writeBool(offsets[1], object.entireContent);
  writer.writeLong(offsets[2], object.episodeId);
  writer.writeString(offsets[3], object.id);
}

HlsDeletedStatModel _hlsDeletedStatModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HlsDeletedStatModel(
    contentId: reader.readLong(offsets[0]),
    entireContent: reader.readBoolOrNull(offsets[1]) ?? false,
    episodeId: reader.readLongOrNull(offsets[2]),
    id: reader.readString(offsets[3]),
  );
  return object;
}

P _hlsDeletedStatModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hlsDeletedStatModelGetId(HlsDeletedStatModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _hlsDeletedStatModelGetLinks(
    HlsDeletedStatModel object) {
  return [];
}

void _hlsDeletedStatModelAttach(
    IsarCollection<dynamic> col, Id id, HlsDeletedStatModel object) {}

extension HlsDeletedStatModelQueryWhereSort
    on QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QWhere> {
  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HlsDeletedStatModelQueryWhere
    on QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QWhereClause> {
  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HlsDeletedStatModelQueryFilter on QueryBuilder<HlsDeletedStatModel,
    HlsDeletedStatModel, QFilterCondition> {
  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      contentIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
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

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      contentIdLessThan(
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

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      contentIdBetween(
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

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      entireContentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entireContent',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      episodeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'episodeId',
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      episodeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'episodeId',
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      episodeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
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

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      episodeIdLessThan(
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

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      episodeIdBetween(
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

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HlsDeletedStatModelQueryObject on QueryBuilder<HlsDeletedStatModel,
    HlsDeletedStatModel, QFilterCondition> {}

extension HlsDeletedStatModelQueryLinks on QueryBuilder<HlsDeletedStatModel,
    HlsDeletedStatModel, QFilterCondition> {}

extension HlsDeletedStatModelQuerySortBy
    on QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QSortBy> {
  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortByEntireContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entireContent', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortByEntireContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entireContent', Sort.desc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortByEpisodeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortByEpisodeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.desc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension HlsDeletedStatModelQuerySortThenBy
    on QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QSortThenBy> {
  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByEntireContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entireContent', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByEntireContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entireContent', Sort.desc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByEpisodeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByEpisodeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.desc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension HlsDeletedStatModelQueryWhereDistinct
    on QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QDistinct> {
  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QDistinct>
      distinctByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentId');
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QDistinct>
      distinctByEntireContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entireContent');
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QDistinct>
      distinctByEpisodeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeId');
    });
  }

  QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }
}

extension HlsDeletedStatModelQueryProperty
    on QueryBuilder<HlsDeletedStatModel, HlsDeletedStatModel, QQueryProperty> {
  QueryBuilder<HlsDeletedStatModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<HlsDeletedStatModel, int, QQueryOperations> contentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentId');
    });
  }

  QueryBuilder<HlsDeletedStatModel, bool, QQueryOperations>
      entireContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entireContent');
    });
  }

  QueryBuilder<HlsDeletedStatModel, int?, QQueryOperations>
      episodeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeId');
    });
  }

  QueryBuilder<HlsDeletedStatModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}
