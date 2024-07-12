// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_company_image_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCompanyImageVo _$AddCompanyImageVoFromJson(Map<String, dynamic> json) =>
    AddCompanyImageVo(
      (json['id'] as num?)?.toInt(),
      (json['companyId'] as num?)?.toInt(),
      json['image_Url'] as String?,
    );

Map<String, dynamic> _$AddCompanyImageVoToJson(AddCompanyImageVo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'image_Url': instance.imageUrl,
    };
