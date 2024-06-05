// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenVo _$TokenVoFromJson(Map<String, dynamic> json) => TokenVo(
      json['AccessToken'] as String?,
      json['UserId'] as String?,
      (json['userRoles'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TokenVoToJson(TokenVo instance) => <String, dynamic>{
      'AccessToken': instance.accessToken,
      'UserId': instance.userId,
      'userRoles': instance.userRole,
    };
