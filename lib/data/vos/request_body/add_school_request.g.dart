// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_school_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddSchoolRequest _$AddSchoolRequestFromJson(Map<String, dynamic> json) =>
    AddSchoolRequest(
      (json['id'] as num?)?.toInt(),
      json['employeeId'] as String?,
      json['name'] as String?,
      json['fromDate'] as String?,
      json['toDate'] as String?,
      json['secondary'] as String?,
      json['maximumAchievement'] as String?,
      json['subjects'] as String?,
    );

Map<String, dynamic> _$AddSchoolRequestToJson(AddSchoolRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'name': instance.name,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'secondary': instance.secondary,
      'maximumAchievement': instance.maximumAchievement,
      'subjects': instance.subjects,
    };
