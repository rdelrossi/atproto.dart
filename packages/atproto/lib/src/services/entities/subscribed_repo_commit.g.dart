// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'subscribed_repo_commit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommitImpl _$$CommitImplFromJson(Map json) => $checkedCreate(
      r'_$CommitImpl',
      json,
      ($checkedConvert) {
        final val = _$CommitImpl(
          ops: $checkedConvert(
              'ops',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      RepoOp.fromJson(Map<String, Object?>.from(e as Map)))
                  .toList()),
          did: $checkedConvert('repo', (v) => v as String),
          cursor: $checkedConvert('seq', (v) => (v as num).toInt()),
          rev: $checkedConvert('rev', (v) => v as String),
          since: $checkedConvert('since', (v) => v as String?),
          isTooBig: $checkedConvert('tooBig', (v) => v as bool? ?? false),
          createdAt:
              $checkedConvert('time', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'did': 'repo',
        'cursor': 'seq',
        'isTooBig': 'tooBig',
        'createdAt': 'time'
      },
    );

Map<String, dynamic> _$$CommitImplToJson(_$CommitImpl instance) =>
    <String, dynamic>{
      'ops': instance.ops.map((e) => e.toJson()).toList(),
      'repo': instance.did,
      'seq': instance.cursor,
      'rev': instance.rev,
      if (instance.since case final value?) 'since': value,
      'tooBig': instance.isTooBig,
      'time': instance.createdAt.toIso8601String(),
    };
