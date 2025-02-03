// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thumbs_playlist_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThumbsPlaylistDetailsModel _$ThumbsPlaylistDetailsModelFromJson(
    Map<String, dynamic> json) {
  return _ThumbsPlaylistDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$ThumbsPlaylistDetailsModel {
  String get uri => throw _privateConstructorUsedError;
  String get baseUrl => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get filesCount => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThumbsPlaylistDetailsModelCopyWith<ThumbsPlaylistDetailsModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThumbsPlaylistDetailsModelCopyWith<$Res> {
  factory $ThumbsPlaylistDetailsModelCopyWith(ThumbsPlaylistDetailsModel value,
          $Res Function(ThumbsPlaylistDetailsModel) then) =
      _$ThumbsPlaylistDetailsModelCopyWithImpl<$Res,
          ThumbsPlaylistDetailsModel>;
  @useResult
  $Res call(
      {String uri,
      String baseUrl,
      String name,
      int size,
      int filesCount,
      String data});
}

/// @nodoc
class _$ThumbsPlaylistDetailsModelCopyWithImpl<$Res,
        $Val extends ThumbsPlaylistDetailsModel>
    implements $ThumbsPlaylistDetailsModelCopyWith<$Res> {
  _$ThumbsPlaylistDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? baseUrl = null,
    Object? name = null,
    Object? size = null,
    Object? filesCount = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      filesCount: null == filesCount
          ? _value.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThumbsPlaylistDetailsModelImplCopyWith<$Res>
    implements $ThumbsPlaylistDetailsModelCopyWith<$Res> {
  factory _$$ThumbsPlaylistDetailsModelImplCopyWith(
          _$ThumbsPlaylistDetailsModelImpl value,
          $Res Function(_$ThumbsPlaylistDetailsModelImpl) then) =
      __$$ThumbsPlaylistDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uri,
      String baseUrl,
      String name,
      int size,
      int filesCount,
      String data});
}

/// @nodoc
class __$$ThumbsPlaylistDetailsModelImplCopyWithImpl<$Res>
    extends _$ThumbsPlaylistDetailsModelCopyWithImpl<$Res,
        _$ThumbsPlaylistDetailsModelImpl>
    implements _$$ThumbsPlaylistDetailsModelImplCopyWith<$Res> {
  __$$ThumbsPlaylistDetailsModelImplCopyWithImpl(
      _$ThumbsPlaylistDetailsModelImpl _value,
      $Res Function(_$ThumbsPlaylistDetailsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? baseUrl = null,
    Object? name = null,
    Object? size = null,
    Object? filesCount = null,
    Object? data = null,
  }) {
    return _then(_$ThumbsPlaylistDetailsModelImpl(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      filesCount: null == filesCount
          ? _value.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThumbsPlaylistDetailsModelImpl implements _ThumbsPlaylistDetailsModel {
  _$ThumbsPlaylistDetailsModelImpl(
      {required this.uri,
      required this.baseUrl,
      required this.name,
      required this.size,
      required this.filesCount,
      required this.data});

  factory _$ThumbsPlaylistDetailsModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ThumbsPlaylistDetailsModelImplFromJson(json);

  @override
  final String uri;
  @override
  final String baseUrl;
  @override
  final String name;
  @override
  final int size;
  @override
  final int filesCount;
  @override
  final String data;

  @override
  String toString() {
    return 'ThumbsPlaylistDetailsModel(uri: $uri, baseUrl: $baseUrl, name: $name, size: $size, filesCount: $filesCount, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThumbsPlaylistDetailsModelImpl &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.filesCount, filesCount) ||
                other.filesCount == filesCount) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uri, baseUrl, name, size, filesCount, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThumbsPlaylistDetailsModelImplCopyWith<_$ThumbsPlaylistDetailsModelImpl>
      get copyWith => __$$ThumbsPlaylistDetailsModelImplCopyWithImpl<
          _$ThumbsPlaylistDetailsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThumbsPlaylistDetailsModelImplToJson(
      this,
    );
  }
}

abstract class _ThumbsPlaylistDetailsModel
    implements ThumbsPlaylistDetailsModel {
  factory _ThumbsPlaylistDetailsModel(
      {required final String uri,
      required final String baseUrl,
      required final String name,
      required final int size,
      required final int filesCount,
      required final String data}) = _$ThumbsPlaylistDetailsModelImpl;

  factory _ThumbsPlaylistDetailsModel.fromJson(Map<String, dynamic> json) =
      _$ThumbsPlaylistDetailsModelImpl.fromJson;

  @override
  String get uri;
  @override
  String get baseUrl;
  @override
  String get name;
  @override
  int get size;
  @override
  int get filesCount;
  @override
  String get data;
  @override
  @JsonKey(ignore: true)
  _$$ThumbsPlaylistDetailsModelImplCopyWith<_$ThumbsPlaylistDetailsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
