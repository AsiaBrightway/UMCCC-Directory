// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_school_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationSchoolVo _$EducationSchoolVoFromJson(Map<String, dynamic> json) =>
    EducationSchoolVo(
      (json['Id'] as num?)?.toInt(),
      json['EmployeeId'] as String?,
      json['Name'] as String?,
      json['FromDate'] as String?,
      json['ToDate'] as String?,
      json['Secondary'] as String?,
      json['MaximumAchievement'] as String?,
      json['Subjects'] as String?,
    );

Map<String, dynamic> _$EducationSchoolVoToJson(EducationSchoolVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'EmployeeId': instance.employeeId,
      'Name': instance.name,
      'FromDate': instance.fromDate,
      'ToDate': instance.toDate,
      'Secondary': instance.secondary,
      'MaximumAchievement': instance.maximumAchievement,
      'Subjects': instance.subjects,
    };
