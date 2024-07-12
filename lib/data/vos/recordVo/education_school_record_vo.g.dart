// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_school_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationSchoolRecordVo _$EducationSchoolRecordVoFromJson(
        Map<String, dynamic> json) =>
    EducationSchoolRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => EducationSchoolVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EducationSchoolRecordVoToJson(
        EducationSchoolRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
    };
