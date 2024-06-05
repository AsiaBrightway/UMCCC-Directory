// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentListResponse _$DepartmentListResponseFromJson(
        Map<String, dynamic> json) =>
    DepartmentListResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : DepartmentRecordVo.fromJson(
              json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepartmentListResponseToJson(
        DepartmentListResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
