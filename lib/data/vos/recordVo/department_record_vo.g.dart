// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentRecordVo _$DepartmentRecordVoFromJson(Map<String, dynamic> json) =>
    DepartmentRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => DepartmentVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DepartmentRecordVoToJson(DepartmentRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
    };
