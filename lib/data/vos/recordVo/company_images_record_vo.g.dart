// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_images_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyImagesRecordVo _$CompanyImagesRecordVoFromJson(
        Map<String, dynamic> json) =>
    CompanyImagesRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => CompanyImagesVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompanyImagesRecordVoToJson(
        CompanyImagesRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'totalRecords': instance.totalRecords,
    };
