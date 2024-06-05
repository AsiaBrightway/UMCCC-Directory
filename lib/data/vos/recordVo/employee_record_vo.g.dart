// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeRecordVo _$EmployeeRecordVoFromJson(Map<String, dynamic> json) =>
    EmployeeRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => EmployeeVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployeeRecordVoToJson(EmployeeRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
    };
