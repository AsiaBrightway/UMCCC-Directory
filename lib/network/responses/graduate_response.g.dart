// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduateResponse _$GraduateResponseFromJson(Map<String, dynamic> json) =>
    GraduateResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : GraduateRecordVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraduateResponseToJson(GraduateResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
