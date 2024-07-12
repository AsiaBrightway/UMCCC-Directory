// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_position_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPositionRequest _$AddPositionRequestFromJson(Map<String, dynamic> json) =>
    AddPositionRequest(
      (json['id'] as num?)?.toInt(),
      (json['departmentId'] as num?)?.toInt(),
      json['position'] as String?,
      json['isActive'] as bool?,
    );

Map<String, dynamic> _$AddPositionRequestToJson(AddPositionRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departmentId': instance.departmentId,
      'position': instance.position,
      'isActive': instance.isActive,
    };
