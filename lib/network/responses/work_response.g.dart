// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkResponse _$WorkResponseFromJson(Map<String, dynamic> json) => WorkResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : WorkRecordVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkResponseToJson(WorkResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
