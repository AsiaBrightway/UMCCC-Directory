// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_graduate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddGraduateRequest _$AddGraduateRequestFromJson(Map<String, dynamic> json) =>
    AddGraduateRequest(
      (json['id'] as num?)?.toInt(),
      json['employeeId'] as String?,
      json['university'] as String?,
      json['degreeType'] as String?,
      json['receivedYear'] as String?,
    );

Map<String, dynamic> _$AddGraduateRequestToJson(AddGraduateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'university': instance.university,
      'degreeType': instance.degreeType,
      'receivedYear': instance.receivedYear,
    };
