// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_work_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddWorkRequest _$AddWorkRequestFromJson(Map<String, dynamic> json) =>
    AddWorkRequest(
      (json['id'] as num?)?.toInt(),
      json['employeeId'] as String?,
      json['companyName'] as String?,
      json['rank'] as String?,
      json['fromDate'] as String?,
      json['toDate'] as String?,
      json['salaryAndAllowance'] as String?,
      json['detailResponsibilities'] as String?,
    );

Map<String, dynamic> _$AddWorkRequestToJson(AddWorkRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'companyName': instance.companyName,
      'rank': instance.rank,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'salaryAndAllowance': instance.salaryAndAllowance,
      'detailResponsibilities': instance.detailResponsibilities,
    };
