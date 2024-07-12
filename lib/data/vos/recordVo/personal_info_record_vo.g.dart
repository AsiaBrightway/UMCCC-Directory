// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfoRecordVo _$PersonalInfoRecordVoFromJson(
        Map<String, dynamic> json) =>
    PersonalInfoRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => PersonalInfoVo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonalInfoRecordVoToJson(
        PersonalInfoRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
    };
