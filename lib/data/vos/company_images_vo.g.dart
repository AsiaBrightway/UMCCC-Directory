// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_images_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyImagesVo _$CompanyImagesVoFromJson(Map<String, dynamic> json) =>
    CompanyImagesVo(
      (json['Id'] as num?)?.toInt(),
      (json['CompanyId'] as num?)?.toInt(),
      json['Image_Url'] as String?,
    );

Map<String, dynamic> _$CompanyImagesVoToJson(CompanyImagesVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CompanyId': instance.companyId,
      'Image_Url': instance.imageUrl,
    };
