// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thumbs_playlist_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThumbsPlaylistDetailsModel {
  String get uri;
  String get baseUrl;
  String get name;
  int get size;
  int get filesCount;
  String get data;

  /// Create a copy of ThumbsPlaylistDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThumbsPlaylistDetailsModelCopyWith<ThumbsPlaylistDetailsModel>
      get copyWith =>
          _$ThumbsPlaylistDetailsModelCopyWithImpl<ThumbsPlaylistDetailsModel>(
              this as ThumbsPlaylistDetailsModel, _$identity);

  /// Serializes this ThumbsPlaylistDetailsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThumbsPlaylistDetailsModel &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.filesCount, filesCount) ||
                other.filesCount == filesCount) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uri, baseUrl, name, size, filesCount, data);

  @override
  String toString() {
    return 'ThumbsPlaylistDetailsModel(uri: $uri, baseUrl: $baseUrl, name: $name, size: $size, filesCount: $filesCount, data: $data)';
  }
}

/// @nodoc
abstract mixin class $ThumbsPlaylistDetailsModelCopyWith<$Res> {
  factory $ThumbsPlaylistDetailsModelCopyWith(ThumbsPlaylistDetailsModel value,
          $Res Function(ThumbsPlaylistDetailsModel) _then) =
      _$ThumbsPlaylistDetailsModelCopyWithImpl;
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
class _$ThumbsPlaylistDetailsModelCopyWithImpl<$Res>
    implements $ThumbsPlaylistDetailsModelCopyWith<$Res> {
  _$ThumbsPlaylistDetailsModelCopyWithImpl(this._self, this._then);

  final ThumbsPlaylistDetailsModel _self;
  final $Res Function(ThumbsPlaylistDetailsModel) _then;

  /// Create a copy of ThumbsPlaylistDetailsModel
  /// with the given fields replaced by the non-null parameter values.
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
    return _then(_self.copyWith(
      uri: null == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _self.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      filesCount: null == filesCount
          ? _self.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ThumbsPlaylistDetailsModel].
extension ThumbsPlaylistDetailsModelPatterns on ThumbsPlaylistDetailsModel {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ThumbsPlaylistDetailsModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ThumbsPlaylistDetailsModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ThumbsPlaylistDetailsModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThumbsPlaylistDetailsModel():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ThumbsPlaylistDetailsModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThumbsPlaylistDetailsModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String uri, String baseUrl, String name, int size,
            int filesCount, String data)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ThumbsPlaylistDetailsModel() when $default != null:
        return $default(_that.uri, _that.baseUrl, _that.name, _that.size,
            _that.filesCount, _that.data);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String uri, String baseUrl, String name, int size,
            int filesCount, String data)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThumbsPlaylistDetailsModel():
        return $default(_that.uri, _that.baseUrl, _that.name, _that.size,
            _that.filesCount, _that.data);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String uri, String baseUrl, String name, int size,
            int filesCount, String data)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThumbsPlaylistDetailsModel() when $default != null:
        return $default(_that.uri, _that.baseUrl, _that.name, _that.size,
            _that.filesCount, _that.data);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ThumbsPlaylistDetailsModel implements ThumbsPlaylistDetailsModel {
  _ThumbsPlaylistDetailsModel(
      {required this.uri,
      required this.baseUrl,
      required this.name,
      required this.size,
      required this.filesCount,
      required this.data});
  factory _ThumbsPlaylistDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ThumbsPlaylistDetailsModelFromJson(json);

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

  /// Create a copy of ThumbsPlaylistDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ThumbsPlaylistDetailsModelCopyWith<_ThumbsPlaylistDetailsModel>
      get copyWith => __$ThumbsPlaylistDetailsModelCopyWithImpl<
          _ThumbsPlaylistDetailsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ThumbsPlaylistDetailsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ThumbsPlaylistDetailsModel &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.filesCount, filesCount) ||
                other.filesCount == filesCount) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uri, baseUrl, name, size, filesCount, data);

  @override
  String toString() {
    return 'ThumbsPlaylistDetailsModel(uri: $uri, baseUrl: $baseUrl, name: $name, size: $size, filesCount: $filesCount, data: $data)';
  }
}

/// @nodoc
abstract mixin class _$ThumbsPlaylistDetailsModelCopyWith<$Res>
    implements $ThumbsPlaylistDetailsModelCopyWith<$Res> {
  factory _$ThumbsPlaylistDetailsModelCopyWith(
          _ThumbsPlaylistDetailsModel value,
          $Res Function(_ThumbsPlaylistDetailsModel) _then) =
      __$ThumbsPlaylistDetailsModelCopyWithImpl;
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
class __$ThumbsPlaylistDetailsModelCopyWithImpl<$Res>
    implements _$ThumbsPlaylistDetailsModelCopyWith<$Res> {
  __$ThumbsPlaylistDetailsModelCopyWithImpl(this._self, this._then);

  final _ThumbsPlaylistDetailsModel _self;
  final $Res Function(_ThumbsPlaylistDetailsModel) _then;

  /// Create a copy of ThumbsPlaylistDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uri = null,
    Object? baseUrl = null,
    Object? name = null,
    Object? size = null,
    Object? filesCount = null,
    Object? data = null,
  }) {
    return _then(_ThumbsPlaylistDetailsModel(
      uri: null == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _self.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      filesCount: null == filesCount
          ? _self.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
