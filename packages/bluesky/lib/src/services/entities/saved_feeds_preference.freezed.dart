// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_feeds_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SavedFeedsPreference _$SavedFeedsPreferenceFromJson(Map<String, dynamic> json) {
  return _SavedFeedsPreference.fromJson(json);
}

/// @nodoc
mixin _$SavedFeedsPreference {
  @typeKey
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'pinned')
  @AtUriConverter()
  List<AtUri> get pinnedUris => throw _privateConstructorUsedError;
  @AtUriConverter()
  @JsonKey(name: 'saved')
  List<AtUri> get savedUris => throw _privateConstructorUsedError;
  int? get timelineIndex => throw _privateConstructorUsedError;

  /// Serializes this SavedFeedsPreference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedFeedsPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedFeedsPreferenceCopyWith<SavedFeedsPreference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedFeedsPreferenceCopyWith<$Res> {
  factory $SavedFeedsPreferenceCopyWith(SavedFeedsPreference value,
          $Res Function(SavedFeedsPreference) then) =
      _$SavedFeedsPreferenceCopyWithImpl<$Res, SavedFeedsPreference>;
  @useResult
  $Res call(
      {@typeKey String type,
      @JsonKey(name: 'pinned') @AtUriConverter() List<AtUri> pinnedUris,
      @AtUriConverter() @JsonKey(name: 'saved') List<AtUri> savedUris,
      int? timelineIndex});
}

/// @nodoc
class _$SavedFeedsPreferenceCopyWithImpl<$Res,
        $Val extends SavedFeedsPreference>
    implements $SavedFeedsPreferenceCopyWith<$Res> {
  _$SavedFeedsPreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedFeedsPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? pinnedUris = null,
    Object? savedUris = null,
    Object? timelineIndex = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      pinnedUris: null == pinnedUris
          ? _value.pinnedUris
          : pinnedUris // ignore: cast_nullable_to_non_nullable
              as List<AtUri>,
      savedUris: null == savedUris
          ? _value.savedUris
          : savedUris // ignore: cast_nullable_to_non_nullable
              as List<AtUri>,
      timelineIndex: freezed == timelineIndex
          ? _value.timelineIndex
          : timelineIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedFeedsPreferenceImplCopyWith<$Res>
    implements $SavedFeedsPreferenceCopyWith<$Res> {
  factory _$$SavedFeedsPreferenceImplCopyWith(_$SavedFeedsPreferenceImpl value,
          $Res Function(_$SavedFeedsPreferenceImpl) then) =
      __$$SavedFeedsPreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@typeKey String type,
      @JsonKey(name: 'pinned') @AtUriConverter() List<AtUri> pinnedUris,
      @AtUriConverter() @JsonKey(name: 'saved') List<AtUri> savedUris,
      int? timelineIndex});
}

/// @nodoc
class __$$SavedFeedsPreferenceImplCopyWithImpl<$Res>
    extends _$SavedFeedsPreferenceCopyWithImpl<$Res, _$SavedFeedsPreferenceImpl>
    implements _$$SavedFeedsPreferenceImplCopyWith<$Res> {
  __$$SavedFeedsPreferenceImplCopyWithImpl(_$SavedFeedsPreferenceImpl _value,
      $Res Function(_$SavedFeedsPreferenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedFeedsPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? pinnedUris = null,
    Object? savedUris = null,
    Object? timelineIndex = freezed,
  }) {
    return _then(_$SavedFeedsPreferenceImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      pinnedUris: null == pinnedUris
          ? _value._pinnedUris
          : pinnedUris // ignore: cast_nullable_to_non_nullable
              as List<AtUri>,
      savedUris: null == savedUris
          ? _value._savedUris
          : savedUris // ignore: cast_nullable_to_non_nullable
              as List<AtUri>,
      timelineIndex: freezed == timelineIndex
          ? _value.timelineIndex
          : timelineIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@jsonSerializable
class _$SavedFeedsPreferenceImpl implements _SavedFeedsPreference {
  const _$SavedFeedsPreferenceImpl(
      {@typeKey this.type = appBskyActorDefsSavedFeedsPref,
      @JsonKey(name: 'pinned')
      @AtUriConverter()
      required final List<AtUri> pinnedUris,
      @AtUriConverter()
      @JsonKey(name: 'saved')
      required final List<AtUri> savedUris,
      this.timelineIndex})
      : _pinnedUris = pinnedUris,
        _savedUris = savedUris;

  factory _$SavedFeedsPreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedFeedsPreferenceImplFromJson(json);

  @override
  @typeKey
  final String type;
  final List<AtUri> _pinnedUris;
  @override
  @JsonKey(name: 'pinned')
  @AtUriConverter()
  List<AtUri> get pinnedUris {
    if (_pinnedUris is EqualUnmodifiableListView) return _pinnedUris;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pinnedUris);
  }

  final List<AtUri> _savedUris;
  @override
  @AtUriConverter()
  @JsonKey(name: 'saved')
  List<AtUri> get savedUris {
    if (_savedUris is EqualUnmodifiableListView) return _savedUris;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_savedUris);
  }

  @override
  final int? timelineIndex;

  @override
  String toString() {
    return 'SavedFeedsPreference(type: $type, pinnedUris: $pinnedUris, savedUris: $savedUris, timelineIndex: $timelineIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedFeedsPreferenceImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._pinnedUris, _pinnedUris) &&
            const DeepCollectionEquality()
                .equals(other._savedUris, _savedUris) &&
            (identical(other.timelineIndex, timelineIndex) ||
                other.timelineIndex == timelineIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      const DeepCollectionEquality().hash(_pinnedUris),
      const DeepCollectionEquality().hash(_savedUris),
      timelineIndex);

  /// Create a copy of SavedFeedsPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedFeedsPreferenceImplCopyWith<_$SavedFeedsPreferenceImpl>
      get copyWith =>
          __$$SavedFeedsPreferenceImplCopyWithImpl<_$SavedFeedsPreferenceImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedFeedsPreferenceImplToJson(
      this,
    );
  }
}

abstract class _SavedFeedsPreference implements SavedFeedsPreference {
  const factory _SavedFeedsPreference(
      {@typeKey final String type,
      @JsonKey(name: 'pinned')
      @AtUriConverter()
      required final List<AtUri> pinnedUris,
      @AtUriConverter()
      @JsonKey(name: 'saved')
      required final List<AtUri> savedUris,
      final int? timelineIndex}) = _$SavedFeedsPreferenceImpl;

  factory _SavedFeedsPreference.fromJson(Map<String, dynamic> json) =
      _$SavedFeedsPreferenceImpl.fromJson;

  @override
  @typeKey
  String get type;
  @override
  @JsonKey(name: 'pinned')
  @AtUriConverter()
  List<AtUri> get pinnedUris;
  @override
  @AtUriConverter()
  @JsonKey(name: 'saved')
  List<AtUri> get savedUris;
  @override
  int? get timelineIndex;

  /// Create a copy of SavedFeedsPreference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedFeedsPreferenceImplCopyWith<_$SavedFeedsPreferenceImpl>
      get copyWith => throw _privateConstructorUsedError;
}
