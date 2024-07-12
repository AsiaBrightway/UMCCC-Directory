// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduate_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduateRecordVo _$GraduateRecordVoFromJson(Map<String, dynamic> json) =>
    GraduateRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => GraduateVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pageSize'] as num?)?.toInt(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GraduateRecordVoToJson(GraduateRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'pageSize': instance.pageSize,
      'totalRecords': instance.totalRecords,
    };
