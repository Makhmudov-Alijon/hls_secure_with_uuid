// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_hls_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RemoteHlsDataModel _$RemoteHlsDataModelFromJson(Map<String, dynamic> json) {
  return _RemoteHlsDataModel.fromJson(json);
}

/// @nodoc
mixin _$RemoteHlsDataModel {
  String get master => throw _privateConstructorUsedError;
  List<String> get videoPlaylists => throw _privateConstructorUsedError;
  List<String> get audioPlaylists => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RemoteHlsDataModelCopyWith<RemoteHlsDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteHlsDataModelCopyWith<$Res> {
  factory $RemoteHlsDataModelCopyWith(
          RemoteHlsDataModel value, $Res Function(RemoteHlsDataModel) then) =
      _$RemoteHlsDataModelCopyWithImpl<$Res, RemoteHlsDataModel>;
  @useResult
  $Res call(
      {String master,
      List<String> videoPlaylists,
      List<String> audioPlaylists});
}

/// @nodoc
class _$RemoteHlsDataModelCopyWithImpl<$Res, $Val extends RemoteHlsDataModel>
    implements $RemoteHlsDataModelCopyWith<$Res> {
  _$RemoteHlsDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = null,
    Object? videoPlaylists = null,
    Object? audioPlaylists = null,
  }) {
    return _then(_value.copyWith(
      master: null == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as String,
      videoPlaylists: null == videoPlaylists
          ? _value.videoPlaylists
          : videoPlaylists // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioPlaylists: null == audioPlaylists
          ? _value.audioPlaylists
          : audioPlaylists // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoteHlsDataModelImplCopyWith<$Res>
    implements $RemoteHlsDataModelCopyWith<$Res> {
  factory _$$RemoteHlsDataModelImplCopyWith(_$RemoteHlsDataModelImpl value,
          $Res Function(_$RemoteHlsDataModelImpl) then) =
      __$$RemoteHlsDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String master,
      List<String> videoPlaylists,
      List<String> audioPlaylists});
}

/// @nodoc
class __$$RemoteHlsDataModelImplCopyWithImpl<$Res>
    extends _$RemoteHlsDataModelCopyWithImpl<$Res, _$RemoteHlsDataModelImpl>
    implements _$$RemoteHlsDataModelImplCopyWith<$Res> {
  __$$RemoteHlsDataModelImplCopyWithImpl(_$RemoteHlsDataModelImpl _value,
      $Res Function(_$RemoteHlsDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = null,
    Object? videoPlaylists = null,
    Object? audioPlaylists = null,
  }) {
    return _then(_$RemoteHlsDataModelImpl(
      master: null == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as String,
      videoPlaylists: null == videoPlaylists
          ? _value._videoPlaylists
          : videoPlaylists // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioPlaylists: null == audioPlaylists
          ? _value._audioPlaylists
          : audioPlaylists // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteHlsDataModelImpl implements _RemoteHlsDataModel {
  const _$RemoteHlsDataModelImpl(
      {required this.master,
      required final List<String> videoPlaylists,
      required final List<String> audioPlaylists})
      : _videoPlaylists = videoPlaylists,
        _audioPlaylists = audioPlaylists;

  factory _$RemoteHlsDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteHlsDataModelImplFromJson(json);

  @override
  final String master;
  final List<String> _videoPlaylists;
  @override
  List<String> get videoPlaylists {
    if (_videoPlaylists is EqualUnmodifiableListView) return _videoPlaylists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoPlaylists);
  }

  final List<String> _audioPlaylists;
  @override
  List<String> get audioPlaylists {
    if (_audioPlaylists is EqualUnmodifiableListView) return _audioPlaylists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_audioPlaylists);
  }

  @override
  String toString() {
    return 'RemoteHlsDataModel(master: $master, videoPlaylists: $videoPlaylists, audioPlaylists: $audioPlaylists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteHlsDataModelImpl &&
            (identical(other.master, master) || other.master == master) &&
            const DeepCollectionEquality()
                .equals(other._videoPlaylists, _videoPlaylists) &&
            const DeepCollectionEquality()
                .equals(other._audioPlaylists, _audioPlaylists));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      master,
      const DeepCollectionEquality().hash(_videoPlaylists),
      const DeepCollectionEquality().hash(_audioPlaylists));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteHlsDataModelImplCopyWith<_$RemoteHlsDataModelImpl> get copyWith =>
      __$$RemoteHlsDataModelImplCopyWithImpl<_$RemoteHlsDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteHlsDataModelImplToJson(
      this,
    );
  }
}

abstract class _RemoteHlsDataModel implements RemoteHlsDataModel {
  const factory _RemoteHlsDataModel(
      {required final String master,
      required final List<String> videoPlaylists,
      required final List<String> audioPlaylists}) = _$RemoteHlsDataModelImpl;

  factory _RemoteHlsDataModel.fromJson(Map<String, dynamic> json) =
      _$RemoteHlsDataModelImpl.fromJson;

  @override
  String get master;
  @override
  List<String> get videoPlaylists;
  @override
  List<String> get audioPlaylists;
  @override
  @JsonKey(ignore: true)
  _$$RemoteHlsDataModelImplCopyWith<_$RemoteHlsDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
