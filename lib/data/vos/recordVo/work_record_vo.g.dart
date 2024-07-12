// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkRecordVo _$WorkRecordVoFromJson(Map<String, dynamic> json) => WorkRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => WorkVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkRecordVoToJson(WorkRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
    };
