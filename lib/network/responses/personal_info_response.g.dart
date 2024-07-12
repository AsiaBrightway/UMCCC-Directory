// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfoResponse _$PersonalInfoResponseFromJson(
        Map<String, dynamic> json) =>
    PersonalInfoResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : PersonalInfoRecordVo.fromJson(
              json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersonalInfoResponseToJson(
        PersonalInfoResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
