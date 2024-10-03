// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_employee_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateEmployeeRequest _$UpdateEmployeeRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateEmployeeRequest(
      json['id'] as String?,
      json['employeeName'] as String?,
      json['image_Url'] as String?,
      (json['companyId'] as num?)?.toInt(),
      (json['departmentId'] as num?)?.toInt(),
      (json['positionId'] as num?)?.toInt(),
      json['employeeNumber'] as String?,
      json['appointmentDate'] as String?,
    );

Map<String, dynamic> _$UpdateEmployeeRequestToJson(
        UpdateEmployeeRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeName': instance.employeeName,
      'image_Url': instance.imageUrl,
      'companyId': instance.companyId,
      'departmentId': instance.departmentId,
      'positionId': instance.positionId,
      'employeeNumber': instance.employeeNumber,
      'appointmentDate': instance.appointmentDate,
    };
