// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_by_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyByIdResponse _$CompanyByIdResponseFromJson(Map<String, dynamic> json) =>
    CompanyByIdResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : CompaniesVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyByIdResponseToJson(
        CompanyByIdResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
