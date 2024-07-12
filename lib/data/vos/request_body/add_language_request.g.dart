// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_language_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddLanguageRequest _$AddLanguageRequestFromJson(Map<String, dynamic> json) =>
    AddLanguageRequest(
      (json['id'] as num?)?.toInt(),
      json['employeeId'] as String?,
      json['name'] as String?,
      (json['proficiency'] as num?)?.toInt(),
      json['teach'] as bool?,
    );

Map<String, dynamic> _$AddLanguageRequestToJson(AddLanguageRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'name': instance.name,
      'proficiency': instance.proficiency,
      'teach': instance.teach,
    };
