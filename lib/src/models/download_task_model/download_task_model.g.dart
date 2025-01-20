// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadTaskCollection on Isar {
  IsarCollection<DownloadTask> get downloadTasks => this.collection();
}

const DownloadTaskSchema = CollectionSchema(
  name: r'DownloadTask',
  id: -8326932930248620171,
  properties: {
    r'doneTasksCount': PropertySchema(
      id: 0,
      name: r'doneTasksCount',
      type: IsarType.long,
    ),
    r'items': PropertySchema(
      id: 1,
      name: r'items',
      type: IsarType.objectList,
      target: r'DownloadItem',
    ),
    r'mbPerSegment': PropertySchema(
      id: 2,
      name: r'mbPerSegment',
      type: IsarType.double,
    )
  },
  estimateSize: _downloadTaskEstimateSize,
  serialize: _downloadTaskSerialize,
  deserialize: _downloadTaskDeserialize,
  deserializeProp: _downloadTaskDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'DownloadItem': DownloadItemSchema},
  getId: _downloadTaskGetId,
  getLinks: _downloadTaskGetLinks,
  attach: _downloadTaskAttach,
  version: '3.1.0+1',
);

int _downloadTaskEstimateSize(
  DownloadTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.items.length * 3;
  {
    final offsets = allOffsets[DownloadItem]!;
    for (var i = 0; i < object.items.length; i++) {
      final value = object.items[i];
      bytesCount += DownloadItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _downloadTaskSerialize(
  DownloadTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.doneTasksCount);
  writer.writeObjectList<DownloadItem>(
    offsets[1],
    allOffsets,
    DownloadItemSchema.serialize,
    object.items,
  );
  writer.writeDouble(offsets[2], object.mbPerSegment);
}

DownloadTask _downloadTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadTask(
    doneTasksCount: reader.readLongOrNull(offsets[0]) ?? 0,
    id: id,
    items: reader.readObjectList<DownloadItem>(
          offsets[1],
          DownloadItemSchema.deserialize,
          allOffsets,
          DownloadItem(),
        ) ??
        const [],
    mbPerSegment: reader.readDoubleOrNull(offsets[2]) ?? 0,
  );
  return object;
}

P _downloadTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readObjectList<DownloadItem>(
            offset,
            DownloadItemSchema.deserialize,
            allOffsets,
            DownloadItem(),
          ) ??
          const []) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadTaskGetId(DownloadTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadTaskGetLinks(DownloadTask object) {
  return [];
}

void _downloadTaskAttach(
    IsarCollection<dynamic> col, Id id, DownloadTask object) {
  object.id = id;
}

extension DownloadTaskQueryWhereSort
    on QueryBuilder<DownloadTask, DownloadTask, QWhere> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadTaskQueryWhere
    on QueryBuilder<DownloadTask, DownloadTask, QWhereClause> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause> idBetween(
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

extension DownloadTaskQueryFilter
    on QueryBuilder<DownloadTask, DownloadTask, QFilterCondition> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      doneTasksCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doneTasksCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      doneTasksCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doneTasksCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      doneTasksCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doneTasksCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      doneTasksCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doneTasksCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      itemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      itemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      itemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      mbPerSegmentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mbPerSegment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      mbPerSegmentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mbPerSegment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      mbPerSegmentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mbPerSegment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      mbPerSegmentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mbPerSegment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension DownloadTaskQueryObject
    on QueryBuilder<DownloadTask, DownloadTask, QFilterCondition> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> itemsElement(
      FilterQuery<DownloadItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'items');
    });
  }
}

extension DownloadTaskQueryLinks
    on QueryBuilder<DownloadTask, DownloadTask, QFilterCondition> {}

extension DownloadTaskQuerySortBy
    on QueryBuilder<DownloadTask, DownloadTask, QSortBy> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByDoneTasksCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneTasksCount', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByDoneTasksCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneTasksCount', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByMbPerSegment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mbPerSegment', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByMbPerSegmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mbPerSegment', Sort.desc);
    });
  }
}

extension DownloadTaskQuerySortThenBy
    on QueryBuilder<DownloadTask, DownloadTask, QSortThenBy> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByDoneTasksCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneTasksCount', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByDoneTasksCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneTasksCount', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByMbPerSegment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mbPerSegment', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByMbPerSegmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mbPerSegment', Sort.desc);
    });
  }
}

extension DownloadTaskQueryWhereDistinct
    on QueryBuilder<DownloadTask, DownloadTask, QDistinct> {
  QueryBuilder<DownloadTask, DownloadTask, QDistinct>
      distinctByDoneTasksCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doneTasksCount');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByMbPerSegment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mbPerSegment');
    });
  }
}

extension DownloadTaskQueryProperty
    on QueryBuilder<DownloadTask, DownloadTask, QQueryProperty> {
  QueryBuilder<DownloadTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadTask, int, QQueryOperations> doneTasksCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doneTasksCount');
    });
  }

  QueryBuilder<DownloadTask, List<DownloadItem>, QQueryOperations>
      itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'items');
    });
  }

  QueryBuilder<DownloadTask, double, QQueryOperations> mbPerSegmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mbPerSegment');
    });
  }
}
