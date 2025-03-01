// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscribed_repo_migrate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Migrate _$MigrateFromJson(Map<String, dynamic> json) {
  return _Migrate.fromJson(json);
}

/// @nodoc
mixin _$Migrate {
  String get did => throw _privateConstructorUsedError;
  String? get migrateTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'seq')
  int get cursor => throw _privateConstructorUsedError;
  @JsonKey(name: 'time')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Migrate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Migrate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MigrateCopyWith<Migrate> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MigrateCopyWith<$Res> {
  factory $MigrateCopyWith(Migrate value, $Res Function(Migrate) then) =
      _$MigrateCopyWithImpl<$Res, Migrate>;
  @useResult
  $Res call(
      {String did,
      String? migrateTo,
      @JsonKey(name: 'seq') int cursor,
      @JsonKey(name: 'time') DateTime createdAt});
}

/// @nodoc
class _$MigrateCopyWithImpl<$Res, $Val extends Migrate>
    implements $MigrateCopyWith<$Res> {
  _$MigrateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Migrate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? did = null,
    Object? migrateTo = freezed,
    Object? cursor = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      did: null == did
          ? _value.did
          : did // ignore: cast_nullable_to_non_nullable
              as String,
      migrateTo: freezed == migrateTo
          ? _value.migrateTo
          : migrateTo // ignore: cast_nullable_to_non_nullable
              as String?,
      cursor: null == cursor
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MigrateImplCopyWith<$Res> implements $MigrateCopyWith<$Res> {
  factory _$$MigrateImplCopyWith(
          _$MigrateImpl value, $Res Function(_$MigrateImpl) then) =
      __$$MigrateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String did,
      String? migrateTo,
      @JsonKey(name: 'seq') int cursor,
      @JsonKey(name: 'time') DateTime createdAt});
}

/// @nodoc
class __$$MigrateImplCopyWithImpl<$Res>
    extends _$MigrateCopyWithImpl<$Res, _$MigrateImpl>
    implements _$$MigrateImplCopyWith<$Res> {
  __$$MigrateImplCopyWithImpl(
      _$MigrateImpl _value, $Res Function(_$MigrateImpl) _then)
      : super(_value, _then);

  /// Create a copy of Migrate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? did = null,
    Object? migrateTo = freezed,
    Object? cursor = null,
    Object? createdAt = null,
  }) {
    return _then(_$MigrateImpl(
      did: null == did
          ? _value.did
          : did // ignore: cast_nullable_to_non_nullable
              as String,
      migrateTo: freezed == migrateTo
          ? _value.migrateTo
          : migrateTo // ignore: cast_nullable_to_non_nullable
              as String?,
      cursor: null == cursor
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@jsonSerializable
class _$MigrateImpl implements _Migrate {
  const _$MigrateImpl(
      {required this.did,
      this.migrateTo,
      @JsonKey(name: 'seq') required this.cursor,
      @JsonKey(name: 'time') required this.createdAt});

  factory _$MigrateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MigrateImplFromJson(json);

  @override
  final String did;
  @override
  final String? migrateTo;
  @override
  @JsonKey(name: 'seq')
  final int cursor;
  @override
  @JsonKey(name: 'time')
  final DateTime createdAt;

  @override
  String toString() {
    return 'Migrate(did: $did, migrateTo: $migrateTo, cursor: $cursor, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MigrateImpl &&
            (identical(other.did, did) || other.did == did) &&
            (identical(other.migrateTo, migrateTo) ||
                other.migrateTo == migrateTo) &&
            (identical(other.cursor, cursor) || other.cursor == cursor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, did, migrateTo, cursor, createdAt);

  /// Create a copy of Migrate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MigrateImplCopyWith<_$MigrateImpl> get copyWith =>
      __$$MigrateImplCopyWithImpl<_$MigrateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MigrateImplToJson(
      this,
    );
  }
}

abstract class _Migrate implements Migrate {
  const factory _Migrate(
          {required final String did,
          final String? migrateTo,
          @JsonKey(name: 'seq') required final int cursor,
          @JsonKey(name: 'time') required final DateTime createdAt}) =
      _$MigrateImpl;

  factory _Migrate.fromJson(Map<String, dynamic> json) = _$MigrateImpl.fromJson;

  @override
  String get did;
  @override
  String? get migrateTo;
  @override
  @JsonKey(name: 'seq')
  int get cursor;
  @override
  @JsonKey(name: 'time')
  DateTime get createdAt;

  /// Create a copy of Migrate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MigrateImplCopyWith<_$MigrateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
