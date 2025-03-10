// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'jwt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JwtImpl _$$JwtImplFromJson(Map json) => $checkedCreate(
      r'_$JwtImpl',
      json,
      ($checkedConvert) {
        final val = _$JwtImpl(
          aud: $checkedConvert('aud', (v) => v as String),
          sub: $checkedConvert('sub', (v) => v as String),
          jti: $checkedConvert('jti', (v) => v as String?),
          cnf: $checkedConvert(
              'cnf',
              (v) => (v as Map?)?.map(
                    (k, e) => MapEntry(k as String, e),
                  )),
          clientId: $checkedConvert('client_id', (v) => v as String?),
          scope: $checkedConvert('scope', (v) => v as String),
          iss: $checkedConvert('iss', (v) => v as String?),
          exp: $checkedConvert(
              'exp', (v) => dateTimeConverter.fromJson((v as num).toInt())),
          iat: $checkedConvert(
              'iat', (v) => dateTimeConverter.fromJson((v as num).toInt())),
        );
        return val;
      },
      fieldKeyMap: const {'clientId': 'client_id'},
    );

Map<String, dynamic> _$$JwtImplToJson(_$JwtImpl instance) => <String, dynamic>{
      'aud': instance.aud,
      'sub': instance.sub,
      if (instance.jti case final value?) 'jti': value,
      if (instance.cnf case final value?) 'cnf': value,
      if (instance.clientId case final value?) 'client_id': value,
      'scope': instance.scope,
      if (instance.iss case final value?) 'iss': value,
      'exp': dateTimeConverter.toJson(instance.exp),
      'iat': dateTimeConverter.toJson(instance.iat),
    };
