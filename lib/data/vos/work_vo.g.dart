// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkVo _$WorkVoFromJson(Map<String, dynamic> json) => WorkVo(
      (json['Id'] as num?)?.toInt(),
      json['EmployeeId'] as String?,
      json['CompanyName'] as String?,
      json['Rank'] as String?,
      json['FromDate'] as String?,
      json['ToDate'] as String?,
      json['SalaryAndAllowance'] as String?,
      json['DetailResponsibilities'] as String?,
    );

Map<String, dynamic> _$WorkVoToJson(WorkVo instance) => <String, dynamic>{
      'Id': instance.id,
      'EmployeeId': instance.employeeId,
      'CompanyName': instance.companyName,
      'Rank': instance.rank,
      'FromDate': instance.fromDate,
      'ToDate': instance.toDate,
      'SalaryAndAllowance': instance.salaryAndAllowance,
      'DetailResponsibilities': instance.detailResponsibilities,
    };
