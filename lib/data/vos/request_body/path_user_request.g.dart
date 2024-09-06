// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathUserRequest _$PathUserRequestFromJson(Map<String, dynamic> json) =>
    PathUserRequest(
      json['path'] as String?,
      json['op'] as String?,
      json['value'] as String?,
    );

Map<String, dynamic> _$PathUserRequestToJson(PathUserRequest instance) =>
    <String, dynamic>{
      'path': instance.path,
      'op': instance.op,
      'value': instance.value,
    };
