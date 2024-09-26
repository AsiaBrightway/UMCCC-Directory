// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduate_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduateVo _$GraduateVoFromJson(Map<String, dynamic> json) => GraduateVo(
      (json['Id'] as num?)?.toInt(),
      json['EmployeeId'] as String?,
      json['University'] as String?,
      json['DegreeType'] as String?,
      json['ReceivedYear'] as String?,
      json['ImageUrl'] as String?,
      json['Remark'] as String?,
    );

Map<String, dynamic> _$GraduateVoToJson(GraduateVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'EmployeeId': instance.employeeId,
      'University': instance.university,
      'DegreeType': instance.degreeType,
      'ReceivedYear': instance.receivedYear,
      'ImageUrl': instance.imageUrl,
      'Remark': instance.remark,
    };
