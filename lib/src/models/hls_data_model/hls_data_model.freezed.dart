// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HlsDataModel _$HlsDataModelFromJson(Map<String, dynamic> json) {
  return _HlsDataModel.fromJson(json);
}

/// @nodoc
mixin _$HlsDataModel {
  String get master => throw _privateConstructorUsedError;
  List<HlsPlaylistDetailsModel> get videoPlaylists =>
      throw _privateConstructorUsedError;
  List<HlsPlaylistDetailsModel> get audioPlaylists =>
      throw _privateConstructorUsedError;
  String? get enc => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HlsDataModelCopyWith<HlsDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HlsDataModelCopyWith<$Res> {
  factory $HlsDataModelCopyWith(
          HlsDataModel value, $Res Function(HlsDataModel) then) =
      _$HlsDataModelCopyWithImpl<$Res, HlsDataModel>;
  @useResult
  $Res call(
      {String master,
      List<HlsPlaylistDetailsModel> videoPlaylists,
      List<HlsPlaylistDetailsModel> audioPlaylists,
      String? enc});
}

/// @nodoc
class _$HlsDataModelCopyWithImpl<$Res, $Val extends HlsDataModel>
    implements $HlsDataModelCopyWith<$Res> {
  _$HlsDataModelCopyWithImpl(this._value, this._then);

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
    Object? enc = freezed,
  }) {
    return _then(_value.copyWith(
      master: null == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as String,
      videoPlaylists: null == videoPlaylists
          ? _value.videoPlaylists
          : videoPlaylists // ignore: cast_nullable_to_non_nullable
              as List<HlsPlaylistDetailsModel>,
      audioPlaylists: null == audioPlaylists
          ? _value.audioPlaylists
          : audioPlaylists // ignore: cast_nullable_to_non_nullable
              as List<HlsPlaylistDetailsModel>,
      enc: freezed == enc
          ? _value.enc
          : enc // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HlsDataModelImplCopyWith<$Res>
    implements $HlsDataModelCopyWith<$Res> {
  factory _$$HlsDataModelImplCopyWith(
          _$HlsDataModelImpl value, $Res Function(_$HlsDataModelImpl) then) =
      __$$HlsDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String master,
      List<HlsPlaylistDetailsModel> videoPlaylists,
      List<HlsPlaylistDetailsModel> audioPlaylists,
      String? enc});
}

/// @nodoc
class __$$HlsDataModelImplCopyWithImpl<$Res>
    extends _$HlsDataModelCopyWithImpl<$Res, _$HlsDataModelImpl>
    implements _$$HlsDataModelImplCopyWith<$Res> {
  __$$HlsDataModelImplCopyWithImpl(
      _$HlsDataModelImpl _value, $Res Function(_$HlsDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = null,
    Object? videoPlaylists = null,
    Object? audioPlaylists = null,
    Object? enc = freezed,
  }) {
    return _then(_$HlsDataModelImpl(
      master: null == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as String,
      videoPlaylists: null == videoPlaylists
          ? _value._videoPlaylists
          : videoPlaylists // ignore: cast_nullable_to_non_nullable
              as List<HlsPlaylistDetailsModel>,
      audioPlaylists: null == audioPlaylists
          ? _value._audioPlaylists
          : audioPlaylists // ignore: cast_nullable_to_non_nullable
              as List<HlsPlaylistDetailsModel>,
      enc: freezed == enc
          ? _value.enc
          : enc // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HlsDataModelImpl implements _HlsDataModel {
  _$HlsDataModelImpl(
      {required this.master,
      required final List<HlsPlaylistDetailsModel> videoPlaylists,
      required final List<HlsPlaylistDetailsModel> audioPlaylists,
      this.enc})
      : _videoPlaylists = videoPlaylists,
        _audioPlaylists = audioPlaylists;

  factory _$HlsDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HlsDataModelImplFromJson(json);

  @override
  final String master;
  final List<HlsPlaylistDetailsModel> _videoPlaylists;
  @override
  List<HlsPlaylistDetailsModel> get videoPlaylists {
    if (_videoPlaylists is EqualUnmodifiableListView) return _videoPlaylists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoPlaylists);
  }

  final List<HlsPlaylistDetailsModel> _audioPlaylists;
  @override
  List<HlsPlaylistDetailsModel> get audioPlaylists {
    if (_audioPlaylists is EqualUnmodifiableListView) return _audioPlaylists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_audioPlaylists);
  }

  @override
  final String? enc;

  @override
  String toString() {
    return 'HlsDataModel(master: $master, videoPlaylists: $videoPlaylists, audioPlaylists: $audioPlaylists, enc: $enc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HlsDataModelImpl &&
            (identical(other.master, master) || other.master == master) &&
            const DeepCollectionEquality()
                .equals(other._videoPlaylists, _videoPlaylists) &&
            const DeepCollectionEquality()
                .equals(other._audioPlaylists, _audioPlaylists) &&
            (identical(other.enc, enc) || other.enc == enc));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      master,
      const DeepCollectionEquality().hash(_videoPlaylists),
      const DeepCollectionEquality().hash(_audioPlaylists),
      enc);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HlsDataModelImplCopyWith<_$HlsDataModelImpl> get copyWith =>
      __$$HlsDataModelImplCopyWithImpl<_$HlsDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HlsDataModelImplToJson(
      this,
    );
  }
}

abstract class _HlsDataModel implements HlsDataModel {
  factory _HlsDataModel(
      {required final String master,
      required final List<HlsPlaylistDetailsModel> videoPlaylists,
      required final List<HlsPlaylistDetailsModel> audioPlaylists,
      final String? enc}) = _$HlsDataModelImpl;

  factory _HlsDataModel.fromJson(Map<String, dynamic> json) =
      _$HlsDataModelImpl.fromJson;

  @override
  String get master;
  @override
  List<HlsPlaylistDetailsModel> get videoPlaylists;
  @override
  List<HlsPlaylistDetailsModel> get audioPlaylists;
  @override
  String? get enc;
  @override
  @JsonKey(ignore: true)
  _$$HlsDataModelImplCopyWith<_$HlsDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
