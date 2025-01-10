// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_hls_status.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocalHlsStatusSchema = Schema(
  name: r'LocalHlsStatus',
  id: 4134005785323454243,
  properties: {
    r'creationDate': PropertySchema(
      id: 0,
      name: r'creationDate',
      type: IsarType.long,
    ),
    r'getCreationDate': PropertySchema(
      id: 1,
      name: r'getCreationDate',
      type: IsarType.dateTime,
    ),
    r'message': PropertySchema(
      id: 2,
      name: r'message',
      type: IsarType.string,
    ),
    r'statusCode': PropertySchema(
      id: 3,
      name: r'statusCode',
      type: IsarType.long,
    ),
    r'statusType': PropertySchema(
      id: 4,
      name: r'statusType',
      type: IsarType.byte,
      enumMap: _LocalHlsStatusstatusTypeEnumValueMap,
    )
  },
  estimateSize: _localHlsStatusEstimateSize,
  serialize: _localHlsStatusSerialize,
  deserialize: _localHlsStatusDeserialize,
  deserializeProp: _localHlsStatusDeserializeProp,
);

int _localHlsStatusEstimateSize(
  LocalHlsStatus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.message;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _localHlsStatusSerialize(
  LocalHlsStatus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.creationDate);
  writer.writeDateTime(offsets[1], object.getCreationDate);
  writer.writeString(offsets[2], object.message);
  writer.writeLong(offsets[3], object.statusCode);
  writer.writeByte(offsets[4], object.statusType.index);
}

LocalHlsStatus _localHlsStatusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalHlsStatus(
    creationDate: reader.readLongOrNull(offsets[0]) ?? -1,
    message: reader.readStringOrNull(offsets[2]),
    statusCode: reader.readLongOrNull(offsets[3]),
    statusType: _LocalHlsStatusstatusTypeValueEnumMap[
            reader.readByteOrNull(offsets[4])] ??
        LocalHlsStatusType.notExist,
  );
  return object;
}

P _localHlsStatusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (_LocalHlsStatusstatusTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          LocalHlsStatusType.notExist) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LocalHlsStatusstatusTypeEnumValueMap = {
  'complete': 0,
  'downloading': 1,
  'paused': 2,
  'inQueue': 3,
  'notExist': 4,
  'deleted': 5,
  'prepared': 6,
  'error': 7,
};
const _LocalHlsStatusstatusTypeValueEnumMap = {
  0: LocalHlsStatusType.complete,
  1: LocalHlsStatusType.downloading,
  2: LocalHlsStatusType.paused,
  3: LocalHlsStatusType.inQueue,
  4: LocalHlsStatusType.notExist,
  5: LocalHlsStatusType.deleted,
  6: LocalHlsStatusType.prepared,
  7: LocalHlsStatusType.error,
};

extension LocalHlsStatusQueryFilter
    on QueryBuilder<LocalHlsStatus, LocalHlsStatus, QFilterCondition> {
  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      creationDateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      creationDateGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      creationDateLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      creationDateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      getCreationDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'getCreationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      getCreationDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'getCreationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      getCreationDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'getCreationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      getCreationDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getCreationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'message',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'message',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'statusCode',
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'statusCode',
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusCodeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusCode',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusCodeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusCode',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusCodeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusCode',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusCodeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusTypeEqualTo(LocalHlsStatusType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusType',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusTypeGreaterThan(
    LocalHlsStatusType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusType',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusTypeLessThan(
    LocalHlsStatusType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusType',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalHlsStatus, LocalHlsStatus, QAfterFilterCondition>
      statusTypeBetween(
    LocalHlsStatusType lower,
    LocalHlsStatusType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalHlsStatusQueryObject
    on QueryBuilder<LocalHlsStatus, LocalHlsStatus, QFilterCondition> {}
