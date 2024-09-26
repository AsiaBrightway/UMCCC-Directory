// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageVo _$LanguageVoFromJson(Map<String, dynamic> json) => LanguageVo(
      (json['Id'] as num?)?.toInt(),
      json['EmployeeId'] as String?,
      json['Name'] as String?,
      (json['Proficiency'] as num?)?.toInt(),
      json['Teach'] as bool?,
      json['ImageUrl'] as String?,
      json['Remark'] as String?,
    );

Map<String, dynamic> _$LanguageVoToJson(LanguageVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'EmployeeId': instance.employeeId,
      'Name': instance.name,
      'Proficiency': instance.proficiency,
      'Teach': instance.teach,
      'ImageUrl': instance.imageUrl,
      'Remark': instance.remark,
    };
