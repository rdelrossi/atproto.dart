// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_list_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThreadListRule _$ThreadListRuleFromJson(Map<String, dynamic> json) {
  return _ThreadListRule.fromJson(json);
}

/// @nodoc
mixin _$ThreadListRule {
  @typeKey
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'list')
  @AtUriConverter()
  AtUri get listUri => throw _privateConstructorUsedError;

  /// Serializes this ThreadListRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ThreadListRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThreadListRuleCopyWith<ThreadListRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThreadListRuleCopyWith<$Res> {
  factory $ThreadListRuleCopyWith(
          ThreadListRule value, $Res Function(ThreadListRule) then) =
      _$ThreadListRuleCopyWithImpl<$Res, ThreadListRule>;
  @useResult
  $Res call(
      {@typeKey String type,
      @JsonKey(name: 'list') @AtUriConverter() AtUri listUri});
}

/// @nodoc
class _$ThreadListRuleCopyWithImpl<$Res, $Val extends ThreadListRule>
    implements $ThreadListRuleCopyWith<$Res> {
  _$ThreadListRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThreadListRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? listUri = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      listUri: null == listUri
          ? _value.listUri
          : listUri // ignore: cast_nullable_to_non_nullable
              as AtUri,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThreadListRuleImplCopyWith<$Res>
    implements $ThreadListRuleCopyWith<$Res> {
  factory _$$ThreadListRuleImplCopyWith(_$ThreadListRuleImpl value,
          $Res Function(_$ThreadListRuleImpl) then) =
      __$$ThreadListRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@typeKey String type,
      @JsonKey(name: 'list') @AtUriConverter() AtUri listUri});
}

/// @nodoc
class __$$ThreadListRuleImplCopyWithImpl<$Res>
    extends _$ThreadListRuleCopyWithImpl<$Res, _$ThreadListRuleImpl>
    implements _$$ThreadListRuleImplCopyWith<$Res> {
  __$$ThreadListRuleImplCopyWithImpl(
      _$ThreadListRuleImpl _value, $Res Function(_$ThreadListRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThreadListRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? listUri = null,
  }) {
    return _then(_$ThreadListRuleImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      listUri: null == listUri
          ? _value.listUri
          : listUri // ignore: cast_nullable_to_non_nullable
              as AtUri,
    ));
  }
}

/// @nodoc

@jsonSerializable
class _$ThreadListRuleImpl implements _ThreadListRule {
  const _$ThreadListRuleImpl(
      {@typeKey this.type = appBskyFeedThreadgateListRule,
      @JsonKey(name: 'list') @AtUriConverter() required this.listUri});

  factory _$ThreadListRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThreadListRuleImplFromJson(json);

  @override
  @typeKey
  final String type;
  @override
  @JsonKey(name: 'list')
  @AtUriConverter()
  final AtUri listUri;

  @override
  String toString() {
    return 'ThreadListRule(type: $type, listUri: $listUri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThreadListRuleImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.listUri, listUri) || other.listUri == listUri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, listUri);

  /// Create a copy of ThreadListRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThreadListRuleImplCopyWith<_$ThreadListRuleImpl> get copyWith =>
      __$$ThreadListRuleImplCopyWithImpl<_$ThreadListRuleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThreadListRuleImplToJson(
      this,
    );
  }
}

abstract class _ThreadListRule implements ThreadListRule {
  const factory _ThreadListRule(
      {@typeKey final String type,
      @JsonKey(name: 'list')
      @AtUriConverter()
      required final AtUri listUri}) = _$ThreadListRuleImpl;

  factory _ThreadListRule.fromJson(Map<String, dynamic> json) =
      _$ThreadListRuleImpl.fromJson;

  @override
  @typeKey
  String get type;
  @override
  @JsonKey(name: 'list')
  @AtUriConverter()
  AtUri get listUri;

  /// Create a copy of ThreadListRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThreadListRuleImplCopyWith<_$ThreadListRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
