// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'labeler_viewer_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LabelerViewerStateImpl _$$LabelerViewerStateImplFromJson(Map json) =>
    $checkedCreate(
      r'_$LabelerViewerStateImpl',
      json,
      ($checkedConvert) {
        final val = _$LabelerViewerStateImpl(
          like: $checkedConvert(
              'like',
              (v) => _$JsonConverterFromJson<String, AtUri>(
                  v, const AtUriConverter().fromJson)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$LabelerViewerStateImplToJson(
        _$LabelerViewerStateImpl instance) =>
    <String, dynamic>{
      if (_$JsonConverterToJson<String, AtUri>(
              instance.like, const AtUriConverter().toJson)
          case final value?)
        'like': value,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
