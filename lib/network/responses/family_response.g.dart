// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyResponse _$FamilyResponseFromJson(Map<String, dynamic> json) =>
    FamilyResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : FamilyRecordVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FamilyResponseToJson(FamilyResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
