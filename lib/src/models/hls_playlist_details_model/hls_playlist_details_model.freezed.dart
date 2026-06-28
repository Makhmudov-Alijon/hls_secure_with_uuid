// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_playlist_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HlsPlaylistDetailsModel {

 String get path; String get data; int get size; int get filesCount;
/// Create a copy of HlsPlaylistDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HlsPlaylistDetailsModelCopyWith<HlsPlaylistDetailsModel> get copyWith => _$HlsPlaylistDetailsModelCopyWithImpl<HlsPlaylistDetailsModel>(this as HlsPlaylistDetailsModel, _$identity);

  /// Serializes this HlsPlaylistDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HlsPlaylistDetailsModel&&(identical(other.path, path) || other.path == path)&&(identical(other.data, data) || other.data == data)&&(identical(other.size, size) || other.size == size)&&(identical(other.filesCount, filesCount) || other.filesCount == filesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,data,size,filesCount);

@override
String toString() {
  return 'HlsPlaylistDetailsModel(path: $path, data: $data, size: $size, filesCount: $filesCount)';
}


}

/// @nodoc
abstract mixin class $HlsPlaylistDetailsModelCopyWith<$Res>  {
  factory $HlsPlaylistDetailsModelCopyWith(HlsPlaylistDetailsModel value, $Res Function(HlsPlaylistDetailsModel) _then) = _$HlsPlaylistDetailsModelCopyWithImpl;
@useResult
$Res call({
 String path, String data, int size, int filesCount
});




}
/// @nodoc
class _$HlsPlaylistDetailsModelCopyWithImpl<$Res>
    implements $HlsPlaylistDetailsModelCopyWith<$Res> {
  _$HlsPlaylistDetailsModelCopyWithImpl(this._self, this._then);

  final HlsPlaylistDetailsModel _self;
  final $Res Function(HlsPlaylistDetailsModel) _then;

/// Create a copy of HlsPlaylistDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? data = null,Object? size = null,Object? filesCount = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,filesCount: null == filesCount ? _self.filesCount : filesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HlsPlaylistDetailsModel].
extension HlsPlaylistDetailsModelPatterns on HlsPlaylistDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HlsPlaylistDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HlsPlaylistDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HlsPlaylistDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _HlsPlaylistDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HlsPlaylistDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _HlsPlaylistDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String data,  int size,  int filesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HlsPlaylistDetailsModel() when $default != null:
return $default(_that.path,_that.data,_that.size,_that.filesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String data,  int size,  int filesCount)  $default,) {final _that = this;
switch (_that) {
case _HlsPlaylistDetailsModel():
return $default(_that.path,_that.data,_that.size,_that.filesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String data,  int size,  int filesCount)?  $default,) {final _that = this;
switch (_that) {
case _HlsPlaylistDetailsModel() when $default != null:
return $default(_that.path,_that.data,_that.size,_that.filesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HlsPlaylistDetailsModel implements HlsPlaylistDetailsModel {
   _HlsPlaylistDetailsModel({required this.path, required this.data, required this.size, required this.filesCount});
  factory _HlsPlaylistDetailsModel.fromJson(Map<String, dynamic> json) => _$HlsPlaylistDetailsModelFromJson(json);

@override final  String path;
@override final  String data;
@override final  int size;
@override final  int filesCount;

/// Create a copy of HlsPlaylistDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HlsPlaylistDetailsModelCopyWith<_HlsPlaylistDetailsModel> get copyWith => __$HlsPlaylistDetailsModelCopyWithImpl<_HlsPlaylistDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HlsPlaylistDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HlsPlaylistDetailsModel&&(identical(other.path, path) || other.path == path)&&(identical(other.data, data) || other.data == data)&&(identical(other.size, size) || other.size == size)&&(identical(other.filesCount, filesCount) || other.filesCount == filesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,data,size,filesCount);

@override
String toString() {
  return 'HlsPlaylistDetailsModel(path: $path, data: $data, size: $size, filesCount: $filesCount)';
}


}

/// @nodoc
abstract mixin class _$HlsPlaylistDetailsModelCopyWith<$Res> implements $HlsPlaylistDetailsModelCopyWith<$Res> {
  factory _$HlsPlaylistDetailsModelCopyWith(_HlsPlaylistDetailsModel value, $Res Function(_HlsPlaylistDetailsModel) _then) = __$HlsPlaylistDetailsModelCopyWithImpl;
@override @useResult
$Res call({
 String path, String data, int size, int filesCount
});




}
/// @nodoc
class __$HlsPlaylistDetailsModelCopyWithImpl<$Res>
    implements _$HlsPlaylistDetailsModelCopyWith<$Res> {
  __$HlsPlaylistDetailsModelCopyWithImpl(this._self, this._then);

  final _HlsPlaylistDetailsModel _self;
  final $Res Function(_HlsPlaylistDetailsModel) _then;

/// Create a copy of HlsPlaylistDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? data = null,Object? size = null,Object? filesCount = null,}) {
  return _then(_HlsPlaylistDetailsModel(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,filesCount: null == filesCount ? _self.filesCount : filesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
