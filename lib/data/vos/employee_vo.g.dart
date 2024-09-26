// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeVo _$EmployeeVoFromJson(Map<String, dynamic> json) => EmployeeVo(
      json['Id'] as String?,
      json['EmployeeName'] as String?,
      json['Image_Url'] as String?,
      (json['CompanyId'] as num?)?.toInt(),
      (json['DepartmentId'] as num?)?.toInt(),
      (json['PositionId'] as num?)?.toInt(),
      json['EmployeeNumber'] as String?,
      json['AppointmentDate'] as String?,
      json['Remark'] as String?,
      json['DepartmentName'] as String?,
      json['Position'] as String?,
      json['CompanyName'] as String?,
    );

Map<String, dynamic> _$EmployeeVoToJson(EmployeeVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'EmployeeName': instance.employeeName,
      'Image_Url': instance.imageUrl,
      'CompanyId': instance.companyId,
      'DepartmentId': instance.departmentId,
      'PositionId': instance.positionId,
      'EmployeeNumber': instance.employeeNumber,
      'AppointmentDate': instance.appointmentDate,
      'Remark': instance.remark,
      'DepartmentName': instance.departmentName,
      'Position': instance.position,
      'CompanyName': instance.companyName,
    };
