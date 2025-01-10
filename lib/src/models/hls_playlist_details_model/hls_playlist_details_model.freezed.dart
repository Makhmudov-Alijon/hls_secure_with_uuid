// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_playlist_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HlsPlaylistDetailsModel _$HlsPlaylistDetailsModelFromJson(
    Map<String, dynamic> json) {
  return _HlsPlaylistDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$HlsPlaylistDetailsModel {
  String get path => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get filesCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HlsPlaylistDetailsModelCopyWith<HlsPlaylistDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HlsPlaylistDetailsModelCopyWith<$Res> {
  factory $HlsPlaylistDetailsModelCopyWith(HlsPlaylistDetailsModel value,
          $Res Function(HlsPlaylistDetailsModel) then) =
      _$HlsPlaylistDetailsModelCopyWithImpl<$Res, HlsPlaylistDetailsModel>;
  @useResult
  $Res call({String path, String data, int size, int filesCount});
}

/// @nodoc
class _$HlsPlaylistDetailsModelCopyWithImpl<$Res,
        $Val extends HlsPlaylistDetailsModel>
    implements $HlsPlaylistDetailsModelCopyWith<$Res> {
  _$HlsPlaylistDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? data = null,
    Object? size = null,
    Object? filesCount = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      filesCount: null == filesCount
          ? _value.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HlsPlaylistDetailsModelImplCopyWith<$Res>
    implements $HlsPlaylistDetailsModelCopyWith<$Res> {
  factory _$$HlsPlaylistDetailsModelImplCopyWith(
          _$HlsPlaylistDetailsModelImpl value,
          $Res Function(_$HlsPlaylistDetailsModelImpl) then) =
      __$$HlsPlaylistDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String data, int size, int filesCount});
}

/// @nodoc
class __$$HlsPlaylistDetailsModelImplCopyWithImpl<$Res>
    extends _$HlsPlaylistDetailsModelCopyWithImpl<$Res,
        _$HlsPlaylistDetailsModelImpl>
    implements _$$HlsPlaylistDetailsModelImplCopyWith<$Res> {
  __$$HlsPlaylistDetailsModelImplCopyWithImpl(
      _$HlsPlaylistDetailsModelImpl _value,
      $Res Function(_$HlsPlaylistDetailsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? data = null,
    Object? size = null,
    Object? filesCount = null,
  }) {
    return _then(_$HlsPlaylistDetailsModelImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      filesCount: null == filesCount
          ? _value.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HlsPlaylistDetailsModelImpl implements _HlsPlaylistDetailsModel {
  _$HlsPlaylistDetailsModelImpl(
      {required this.path,
      required this.data,
      required this.size,
      required this.filesCount});

  factory _$HlsPlaylistDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HlsPlaylistDetailsModelImplFromJson(json);

  @override
  final String path;
  @override
  final String data;
  @override
  final int size;
  @override
  final int filesCount;

  @override
  String toString() {
    return 'HlsPlaylistDetailsModel(path: $path, data: $data, size: $size, filesCount: $filesCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HlsPlaylistDetailsModelImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.filesCount, filesCount) ||
                other.filesCount == filesCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, data, size, filesCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HlsPlaylistDetailsModelImplCopyWith<_$HlsPlaylistDetailsModelImpl>
      get copyWith => __$$HlsPlaylistDetailsModelImplCopyWithImpl<
          _$HlsPlaylistDetailsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HlsPlaylistDetailsModelImplToJson(
      this,
    );
  }
}

abstract class _HlsPlaylistDetailsModel implements HlsPlaylistDetailsModel {
  factory _HlsPlaylistDetailsModel(
      {required final String path,
      required final String data,
      required final int size,
      required final int filesCount}) = _$HlsPlaylistDetailsModelImpl;

  factory _HlsPlaylistDetailsModel.fromJson(Map<String, dynamic> json) =
      _$HlsPlaylistDetailsModelImpl.fromJson;

  @override
  String get path;
  @override
  String get data;
  @override
  int get size;
  @override
  int get filesCount;
  @override
  @JsonKey(ignore: true)
  _$$HlsPlaylistDetailsModelImplCopyWith<_$HlsPlaylistDetailsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
