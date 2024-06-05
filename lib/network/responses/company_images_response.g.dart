// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_images_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyImagesResponse _$CompanyImagesResponseFromJson(
        Map<String, dynamic> json) =>
    CompanyImagesResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : CompanyImagesRecordVo.fromJson(
              json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyImagesResponseToJson(
        CompanyImagesResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
