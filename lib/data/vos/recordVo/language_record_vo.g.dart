// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageRecordVo _$LanguageRecordVoFromJson(Map<String, dynamic> json) =>
    LanguageRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => LanguageVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
      (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LanguageRecordVoToJson(LanguageRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
      'pageSize': instance.pageSize,
    };
