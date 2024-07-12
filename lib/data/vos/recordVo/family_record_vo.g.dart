// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyRecordVo _$FamilyRecordVoFromJson(Map<String, dynamic> json) =>
    FamilyRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => FamilyVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FamilyRecordVoToJson(FamilyRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
    };
