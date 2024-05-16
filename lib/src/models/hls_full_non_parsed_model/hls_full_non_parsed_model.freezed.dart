// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_full_non_parsed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HlsFullNonParsedModel _$HlsFullNonParsedModelFromJson(
    Map<String, dynamic> json) {
  return _HlsFullNonParsedModel.fromJson(json);
}

/// @nodoc
mixin _$HlsFullNonParsedModel {
  String get master => throw _privateConstructorUsedError;
  List<HlsPlaylistDetailsModel> get videoPlaylists =>
      throw _privateConstructorUsedError;
  List<HlsPlaylistDetailsModel> get audioPlaylists =>
      throw _privateConstructorUsedError;
  String? get enc => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HlsFullNonParsedModelCopyWith<HlsFullNonParsedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HlsFullNonParsedModelCopyWith<$Res> {
  factory $HlsFullNonParsedModelCopyWith(HlsFullNonParsedModel value,
          $Res Function(HlsFullNonParsedModel) then) =
      _$HlsFullNonParsedModelCopyWithImpl<$Res, HlsFullNonParsedModel>;
  @useResult
  $Res call(
      {String master,
      List<HlsPlaylistDetailsModel> videoPlaylists,
      List<HlsPlaylistDetailsModel> audioPlaylists,
      String? enc});
}

/// @nodoc
class _$HlsFullNonParsedModelCopyWithImpl<$Res,
        $Val extends HlsFullNonParsedModel>
    implements $HlsFullNonParsedModelCopyWith<$Res> {
  _$HlsFullNonParsedModelCopyWithImpl(this._value, this._then);

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
abstract class _$$HlsFullNonParsedModelImplCopyWith<$Res>
    implements $HlsFullNonParsedModelCopyWith<$Res> {
  factory _$$HlsFullNonParsedModelImplCopyWith(
          _$HlsFullNonParsedModelImpl value,
          $Res Function(_$HlsFullNonParsedModelImpl) then) =
      __$$HlsFullNonParsedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String master,
      List<HlsPlaylistDetailsModel> videoPlaylists,
      List<HlsPlaylistDetailsModel> audioPlaylists,
      String? enc});
}

/// @nodoc
class __$$HlsFullNonParsedModelImplCopyWithImpl<$Res>
    extends _$HlsFullNonParsedModelCopyWithImpl<$Res,
        _$HlsFullNonParsedModelImpl>
    implements _$$HlsFullNonParsedModelImplCopyWith<$Res> {
  __$$HlsFullNonParsedModelImplCopyWithImpl(_$HlsFullNonParsedModelImpl _value,
      $Res Function(_$HlsFullNonParsedModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = null,
    Object? videoPlaylists = null,
    Object? audioPlaylists = null,
    Object? enc = freezed,
  }) {
    return _then(_$HlsFullNonParsedModelImpl(
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
class _$HlsFullNonParsedModelImpl implements _HlsFullNonParsedModel {
  _$HlsFullNonParsedModelImpl(
      {required this.master,
      required final List<HlsPlaylistDetailsModel> videoPlaylists,
      required final List<HlsPlaylistDetailsModel> audioPlaylists,
      this.enc})
      : _videoPlaylists = videoPlaylists,
        _audioPlaylists = audioPlaylists;

  factory _$HlsFullNonParsedModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HlsFullNonParsedModelImplFromJson(json);

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
    return 'HlsFullNonParsedModel(master: $master, videoPlaylists: $videoPlaylists, audioPlaylists: $audioPlaylists, enc: $enc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HlsFullNonParsedModelImpl &&
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
  _$$HlsFullNonParsedModelImplCopyWith<_$HlsFullNonParsedModelImpl>
      get copyWith => __$$HlsFullNonParsedModelImplCopyWithImpl<
          _$HlsFullNonParsedModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HlsFullNonParsedModelImplToJson(
      this,
    );
  }
}

abstract class _HlsFullNonParsedModel implements HlsFullNonParsedModel {
  factory _HlsFullNonParsedModel(
      {required final String master,
      required final List<HlsPlaylistDetailsModel> videoPlaylists,
      required final List<HlsPlaylistDetailsModel> audioPlaylists,
      final String? enc}) = _$HlsFullNonParsedModelImpl;

  factory _HlsFullNonParsedModel.fromJson(Map<String, dynamic> json) =
      _$HlsFullNonParsedModelImpl.fromJson;

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
  _$$HlsFullNonParsedModelImplCopyWith<_$HlsFullNonParsedModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
