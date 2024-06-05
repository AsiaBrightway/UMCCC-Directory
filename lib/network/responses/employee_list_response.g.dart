// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeListResponse _$EmployeeListResponseFromJson(
        Map<String, dynamic> json) =>
    EmployeeListResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : EmployeeRecordVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmployeeListResponseToJson(
        EmployeeListResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
