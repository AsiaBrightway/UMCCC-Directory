// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_family_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddFamilyRequest _$AddFamilyRequestFromJson(Map<String, dynamic> json) =>
    AddFamilyRequest(
      (json['id'] as num?)?.toInt(),
      json['employeeId'] as String?,
      json['name'] as String?,
      json['dateOfBirth'] as String?,
      json['race'] as String?,
      json['identityNumber'] as String?,
      json['employment'] as String?,
      json['rank'] as String?,
      json['ministryAndCompany'] as String?,
      json['relationship'] as String?,
    );

Map<String, dynamic> _$AddFamilyRequestToJson(AddFamilyRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'name': instance.name,
      'dateOfBirth': instance.dateOfBirth,
      'race': instance.race,
      'identityNumber': instance.identityNumber,
      'employment': instance.employment,
      'rank': instance.rank,
      'ministryAndCompany': instance.ministryAndCompany,
      'relationship': instance.relationship,
    };
