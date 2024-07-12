// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionResponse _$PositionResponseFromJson(Map<String, dynamic> json) =>
    PositionResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : PositionRecordVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PositionResponseToJson(PositionResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
