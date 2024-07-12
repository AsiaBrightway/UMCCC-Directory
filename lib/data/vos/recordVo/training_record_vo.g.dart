// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingRecordVo _$TrainingRecordVoFromJson(Map<String, dynamic> json) =>
    TrainingRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => TrainingVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pageNumber'] as num?)?.toInt(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TrainingRecordVoToJson(TrainingRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'pageNumber': instance.pageNumber,
      'totalRecords': instance.totalRecords,
    };
