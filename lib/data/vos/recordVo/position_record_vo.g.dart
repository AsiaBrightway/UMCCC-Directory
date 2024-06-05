// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionRecordVo _$PositionRecordVoFromJson(Map<String, dynamic> json) =>
    PositionRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => PositionVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PositionRecordVoToJson(PositionRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
    };
