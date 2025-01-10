// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_downloaded_stat_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHlsDownloadedStatModelCollection on Isar {
  IsarCollection<HlsDownloadedStatModel> get hlsDownloadedStatModels =>
      this.collection();
}

const HlsDownloadedStatModelSchema = CollectionSchema(
  name: r'HlsDownloadedStatModel',
  id: 3100718716235108798,
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
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    )
  },
  estimateSize: _hlsDownloadedStatModelEstimateSize,
  serialize: _hlsDownloadedStatModelSerialize,
  deserialize: _hlsDownloadedStatModelDeserialize,
  deserializeProp: _hlsDownloadedStatModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hlsDownloadedStatModelGetId,
  getLinks: _hlsDownloadedStatModelGetLinks,
  attach: _hlsDownloadedStatModelAttach,
  version: '3.1.0+1',
);

int _hlsDownloadedStatModelEstimateSize(
  HlsDownloadedStatModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _hlsDownloadedStatModelSerialize(
  HlsDownloadedStatModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.contentId);
  writer.writeLong(offsets[1], object.episodeId);
  writer.writeString(offsets[2], object.id);
}

HlsDownloadedStatModel _hlsDownloadedStatModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HlsDownloadedStatModel(
    contentId: reader.readLong(offsets[0]),
    episodeId: reader.readLongOrNull(offsets[1]),
    id: reader.readString(offsets[2]),
  );
  return object;
}

P _hlsDownloadedStatModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hlsDownloadedStatModelGetId(HlsDownloadedStatModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _hlsDownloadedStatModelGetLinks(
    HlsDownloadedStatModel object) {
  return [];
}

void _hlsDownloadedStatModelAttach(
    IsarCollection<dynamic> col, Id id, HlsDownloadedStatModel object) {}

extension HlsDownloadedStatModelQueryWhereSort
    on QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QWhere> {
  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HlsDownloadedStatModelQueryWhere on QueryBuilder<
    HlsDownloadedStatModel, HlsDownloadedStatModel, QWhereClause> {
  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterWhereClause> isarIdBetween(
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

extension HlsDownloadedStatModelQueryFilter on QueryBuilder<
    HlsDownloadedStatModel, HlsDownloadedStatModel, QFilterCondition> {
  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> contentIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> contentIdGreaterThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> contentIdLessThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> contentIdBetween(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> episodeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'episodeId',
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> episodeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'episodeId',
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> episodeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> episodeIdGreaterThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> episodeIdLessThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> episodeIdBetween(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel,
      QAfterFilterCondition> isarIdBetween(
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

extension HlsDownloadedStatModelQueryObject on QueryBuilder<
    HlsDownloadedStatModel, HlsDownloadedStatModel, QFilterCondition> {}

extension HlsDownloadedStatModelQueryLinks on QueryBuilder<
    HlsDownloadedStatModel, HlsDownloadedStatModel, QFilterCondition> {}

extension HlsDownloadedStatModelQuerySortBy
    on QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QSortBy> {
  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      sortByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      sortByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      sortByEpisodeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.asc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      sortByEpisodeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.desc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension HlsDownloadedStatModelQuerySortThenBy on QueryBuilder<
    HlsDownloadedStatModel, HlsDownloadedStatModel, QSortThenBy> {
  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenByEpisodeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.asc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenByEpisodeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeId', Sort.desc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension HlsDownloadedStatModelQueryWhereDistinct
    on QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QDistinct> {
  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QDistinct>
      distinctByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentId');
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QDistinct>
      distinctByEpisodeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeId');
    });
  }

  QueryBuilder<HlsDownloadedStatModel, HlsDownloadedStatModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }
}

extension HlsDownloadedStatModelQueryProperty on QueryBuilder<
    HlsDownloadedStatModel, HlsDownloadedStatModel, QQueryProperty> {
  QueryBuilder<HlsDownloadedStatModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<HlsDownloadedStatModel, int, QQueryOperations>
      contentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentId');
    });
  }

  QueryBuilder<HlsDownloadedStatModel, int?, QQueryOperations>
      episodeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeId');
    });
  }

  QueryBuilder<HlsDownloadedStatModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}
