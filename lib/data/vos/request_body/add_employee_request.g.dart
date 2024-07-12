// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_employee_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddEmployeeRequest _$AddEmployeeRequestFromJson(Map<String, dynamic> json) =>
    AddEmployeeRequest(
      json['id'] as String?,
      (json['userRolesId'] as num?)?.toInt(),
      json['password'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['logoutEnabled'] as bool?,
      json['isActive'] as bool?,
      json['employeeId'] as String?,
      json['employeeName'] as String?,
      json['image_Url'] as String?,
      (json['companyId'] as num?)?.toInt(),
      (json['departmentId'] as num?)?.toInt(),
      (json['positionId'] as num?)?.toInt(),
      json['employeeNumber'] as String?,
      json['jdCode'] as String?,
    );

Map<String, dynamic> _$AddEmployeeRequestToJson(AddEmployeeRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userRolesId': instance.userRoleId,
      'password': instance.password,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'logoutEnabled': instance.logoutEnabled,
      'isActive': instance.isActive,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'image_Url': instance.imageUrl,
      'companyId': instance.companyId,
      'departmentId': instance.departmentId,
      'positionId': instance.positionId,
      'employeeNumber': instance.employeeNumber,
      'jdCode': instance.jdCode,
    };
