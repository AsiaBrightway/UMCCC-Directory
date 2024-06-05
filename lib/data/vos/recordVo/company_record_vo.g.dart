// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyRecordVo _$CompanyRecordVoFromJson(Map<String, dynamic> json) =>
    CompanyRecordVo(
      (json['records'] as List<dynamic>?)
          ?.map((e) => CompaniesVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pageNumber'] as num?)?.toInt(),
      (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompanyRecordVoToJson(CompanyRecordVo instance) =>
    <String, dynamic>{
      'records': instance.records,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
    };
