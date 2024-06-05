// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_department_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddDepartmentRequest _$AddDepartmentRequestFromJson(
        Map<String, dynamic> json) =>
    AddDepartmentRequest(
      (json['id'] as num?)?.toInt(),
      (json['companyId'] as num?)?.toInt(),
      json['departmentName'] as String?,
      json['isActive'] as bool?,
    );

Map<String, dynamic> _$AddDepartmentRequestToJson(
        AddDepartmentRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'departmentName': instance.departmentName,
      'isActive': instance.isActive,
    };
