// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyVo _$FamilyVoFromJson(Map<String, dynamic> json) => FamilyVo(
      (json['Id'] as num?)?.toInt(),
      json['EmployeeId'] as String?,
      json['Name'] as String?,
      json['DateOfBirth'] as String?,
      json['Race'] as String?,
      json['IdentityNumber'] as String?,
      json['Employment'] as String?,
      json['Rank'] as String?,
      json['MinistryAndCompany'] as String?,
      json['Relationship'] as String?,
    );

Map<String, dynamic> _$FamilyVoToJson(FamilyVo instance) => <String, dynamic>{
      'Id': instance.id,
      'EmployeeId': instance.employeeId,
      'Name': instance.name,
      'DateOfBirth': instance.dateOfBirth,
      'Race': instance.race,
      'IdentityNumber': instance.identityNumber,
      'Employment': instance.employment,
      'Rank': instance.rank,
      'MinistryAndCompany': instance.ministryAndCompany,
      'Relationship': instance.relationship,
    };
