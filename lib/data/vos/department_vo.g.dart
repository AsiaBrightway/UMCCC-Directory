// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentVo _$DepartmentVoFromJson(Map<String, dynamic> json) => DepartmentVo(
      (json['Id'] as num?)?.toInt(),
      (json['CompanyId'] as num?)?.toInt(),
      json['DepartmentName'] as String?,
      json['IsActive'] as bool?,
    );

Map<String, dynamic> _$DepartmentVoToJson(DepartmentVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CompanyId': instance.companyId,
      'DepartmentName': instance.departmentName,
      'IsActive': instance.isActive,
    };
