// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_full_non_parsed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HlsFullNonParsedModel {

 String get master; List<HlsPlaylistDetailsModel> get videoPlaylists; List<HlsPlaylistDetailsModel> get audioPlaylists;@ThumbsConverter() List<ThumbsPlaylist> get thumbsPlaylists; String get enc;
/// Create a copy of HlsFullNonParsedModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HlsFullNonParsedModelCopyWith<HlsFullNonParsedModel> get copyWith => _$HlsFullNonParsedModelCopyWithImpl<HlsFullNonParsedModel>(this as HlsFullNonParsedModel, _$identity);

  /// Serializes this HlsFullNonParsedModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HlsFullNonParsedModel&&(identical(other.master, master) || other.master == master)&&const DeepCollectionEquality().equals(other.videoPlaylists, videoPlaylists)&&const DeepCollectionEquality().equals(other.audioPlaylists, audioPlaylists)&&const DeepCollectionEquality().equals(other.thumbsPlaylists, thumbsPlaylists)&&(identical(other.enc, enc) || other.enc == enc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,master,const DeepCollectionEquality().hash(videoPlaylists),const DeepCollectionEquality().hash(audioPlaylists),const DeepCollectionEquality().hash(thumbsPlaylists),enc);

@override
String toString() {
  return 'HlsFullNonParsedModel(master: $master, videoPlaylists: $videoPlaylists, audioPlaylists: $audioPlaylists, thumbsPlaylists: $thumbsPlaylists, enc: $enc)';
}


}

/// @nodoc
abstract mixin class $HlsFullNonParsedModelCopyWith<$Res>  {
  factory $HlsFullNonParsedModelCopyWith(HlsFullNonParsedModel value, $Res Function(HlsFullNonParsedModel) _then) = _$HlsFullNonParsedModelCopyWithImpl;
@useResult
$Res call({
 String master, List<HlsPlaylistDetailsModel> videoPlaylists, List<HlsPlaylistDetailsModel> audioPlaylists,@ThumbsConverter() List<ThumbsPlaylist> thumbsPlaylists, String enc
});




}
/// @nodoc
class _$HlsFullNonParsedModelCopyWithImpl<$Res>
    implements $HlsFullNonParsedModelCopyWith<$Res> {
  _$HlsFullNonParsedModelCopyWithImpl(this._self, this._then);

  final HlsFullNonParsedModel _self;
  final $Res Function(HlsFullNonParsedModel) _then;

/// Create a copy of HlsFullNonParsedModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? master = null,Object? videoPlaylists = null,Object? audioPlaylists = null,Object? thumbsPlaylists = null,Object? enc = null,}) {
  return _then(_self.copyWith(
master: null == master ? _self.master : master // ignore: cast_nullable_to_non_nullable
as String,videoPlaylists: null == videoPlaylists ? _self.videoPlaylists : videoPlaylists // ignore: cast_nullable_to_non_nullable
as List<HlsPlaylistDetailsModel>,audioPlaylists: null == audioPlaylists ? _self.audioPlaylists : audioPlaylists // ignore: cast_nullable_to_non_nullable
as List<HlsPlaylistDetailsModel>,thumbsPlaylists: null == thumbsPlaylists ? _self.thumbsPlaylists : thumbsPlaylists // ignore: cast_nullable_to_non_nullable
as List<ThumbsPlaylist>,enc: null == enc ? _self.enc : enc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HlsFullNonParsedModel].
extension HlsFullNonParsedModelPatterns on HlsFullNonParsedModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HlsFullNonParsedModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HlsFullNonParsedModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HlsFullNonParsedModel value)  $default,){
final _that = this;
switch (_that) {
case _HlsFullNonParsedModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HlsFullNonParsedModel value)?  $default,){
final _that = this;
switch (_that) {
case _HlsFullNonParsedModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String master,  List<HlsPlaylistDetailsModel> videoPlaylists,  List<HlsPlaylistDetailsModel> audioPlaylists, @ThumbsConverter()  List<ThumbsPlaylist> thumbsPlaylists,  String enc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HlsFullNonParsedModel() when $default != null:
return $default(_that.master,_that.videoPlaylists,_that.audioPlaylists,_that.thumbsPlaylists,_that.enc);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String master,  List<HlsPlaylistDetailsModel> videoPlaylists,  List<HlsPlaylistDetailsModel> audioPlaylists, @ThumbsConverter()  List<ThumbsPlaylist> thumbsPlaylists,  String enc)  $default,) {final _that = this;
switch (_that) {
case _HlsFullNonParsedModel():
return $default(_that.master,_that.videoPlaylists,_that.audioPlaylists,_that.thumbsPlaylists,_that.enc);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String master,  List<HlsPlaylistDetailsModel> videoPlaylists,  List<HlsPlaylistDetailsModel> audioPlaylists, @ThumbsConverter()  List<ThumbsPlaylist> thumbsPlaylists,  String enc)?  $default,) {final _that = this;
switch (_that) {
case _HlsFullNonParsedModel() when $default != null:
return $default(_that.master,_that.videoPlaylists,_that.audioPlaylists,_that.thumbsPlaylists,_that.enc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HlsFullNonParsedModel implements HlsFullNonParsedModel {
   _HlsFullNonParsedModel({required this.master, required final  List<HlsPlaylistDetailsModel> videoPlaylists, required final  List<HlsPlaylistDetailsModel> audioPlaylists, @ThumbsConverter() required final  List<ThumbsPlaylist> thumbsPlaylists, required this.enc}): _videoPlaylists = videoPlaylists,_audioPlaylists = audioPlaylists,_thumbsPlaylists = thumbsPlaylists;
  factory _HlsFullNonParsedModel.fromJson(Map<String, dynamic> json) => _$HlsFullNonParsedModelFromJson(json);

@override final  String master;
 final  List<HlsPlaylistDetailsModel> _videoPlaylists;
@override List<HlsPlaylistDetailsModel> get videoPlaylists {
  if (_videoPlaylists is EqualUnmodifiableListView) return _videoPlaylists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videoPlaylists);
}

 final  List<HlsPlaylistDetailsModel> _audioPlaylists;
@override List<HlsPlaylistDetailsModel> get audioPlaylists {
  if (_audioPlaylists is EqualUnmodifiableListView) return _audioPlaylists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audioPlaylists);
}

 final  List<ThumbsPlaylist> _thumbsPlaylists;
@override@ThumbsConverter() List<ThumbsPlaylist> get thumbsPlaylists {
  if (_thumbsPlaylists is EqualUnmodifiableListView) return _thumbsPlaylists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_thumbsPlaylists);
}

@override final  String enc;

/// Create a copy of HlsFullNonParsedModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HlsFullNonParsedModelCopyWith<_HlsFullNonParsedModel> get copyWith => __$HlsFullNonParsedModelCopyWithImpl<_HlsFullNonParsedModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HlsFullNonParsedModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HlsFullNonParsedModel&&(identical(other.master, master) || other.master == master)&&const DeepCollectionEquality().equals(other._videoPlaylists, _videoPlaylists)&&const DeepCollectionEquality().equals(other._audioPlaylists, _audioPlaylists)&&const DeepCollectionEquality().equals(other._thumbsPlaylists, _thumbsPlaylists)&&(identical(other.enc, enc) || other.enc == enc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,master,const DeepCollectionEquality().hash(_videoPlaylists),const DeepCollectionEquality().hash(_audioPlaylists),const DeepCollectionEquality().hash(_thumbsPlaylists),enc);

@override
String toString() {
  return 'HlsFullNonParsedModel(master: $master, videoPlaylists: $videoPlaylists, audioPlaylists: $audioPlaylists, thumbsPlaylists: $thumbsPlaylists, enc: $enc)';
}


}

/// @nodoc
abstract mixin class _$HlsFullNonParsedModelCopyWith<$Res> implements $HlsFullNonParsedModelCopyWith<$Res> {
  factory _$HlsFullNonParsedModelCopyWith(_HlsFullNonParsedModel value, $Res Function(_HlsFullNonParsedModel) _then) = __$HlsFullNonParsedModelCopyWithImpl;
@override @useResult
$Res call({
 String master, List<HlsPlaylistDetailsModel> videoPlaylists, List<HlsPlaylistDetailsModel> audioPlaylists,@ThumbsConverter() List<ThumbsPlaylist> thumbsPlaylists, String enc
});




}
/// @nodoc
class __$HlsFullNonParsedModelCopyWithImpl<$Res>
    implements _$HlsFullNonParsedModelCopyWith<$Res> {
  __$HlsFullNonParsedModelCopyWithImpl(this._self, this._then);

  final _HlsFullNonParsedModel _self;
  final $Res Function(_HlsFullNonParsedModel) _then;

/// Create a copy of HlsFullNonParsedModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? master = null,Object? videoPlaylists = null,Object? audioPlaylists = null,Object? thumbsPlaylists = null,Object? enc = null,}) {
  return _then(_HlsFullNonParsedModel(
master: null == master ? _self.master : master // ignore: cast_nullable_to_non_nullable
as String,videoPlaylists: null == videoPlaylists ? _self._videoPlaylists : videoPlaylists // ignore: cast_nullable_to_non_nullable
as List<HlsPlaylistDetailsModel>,audioPlaylists: null == audioPlaylists ? _self._audioPlaylists : audioPlaylists // ignore: cast_nullable_to_non_nullable
as List<HlsPlaylistDetailsModel>,thumbsPlaylists: null == thumbsPlaylists ? _self._thumbsPlaylists : thumbsPlaylists // ignore: cast_nullable_to_non_nullable
as List<ThumbsPlaylist>,enc: null == enc ? _self.enc : enc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
