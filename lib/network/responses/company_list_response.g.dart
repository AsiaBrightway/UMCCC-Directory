// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyListResponse _$CompanyListResponseFromJson(Map<String, dynamic> json) =>
    CompanyListResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : CompanyRecordVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyListResponseToJson(
        CompanyListResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
