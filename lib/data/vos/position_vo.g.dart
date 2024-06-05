// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionVo _$PositionVoFromJson(Map<String, dynamic> json) => PositionVo(
      (json['Id'] as num?)?.toInt(),
      (json['DepartmentId'] as num?)?.toInt(),
      json['Position'] as String?,
      json['IsActive'] as bool?,
    );

Map<String, dynamic> _$PositionVoToJson(PositionVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'DepartmentId': instance.deptId,
      'Position': instance.position,
      'IsActive': instance.isActive,
    };
