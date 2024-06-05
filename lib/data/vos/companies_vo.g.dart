// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companies_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompaniesVo _$CompaniesVoFromJson(Map<String, dynamic> json) => CompaniesVo(
      (json['Id'] as num?)?.toInt(),
      json['CompanyName'] as String?,
      json['Address'] as String?,
      json['CompanyLogo'] as String?,
      json['PhoneNo'] as String?,
      json['About'] as String?,
      json['StartDate'] as String?,
      (json['SortOrder'] as num?)?.toInt(),
      json['IsActive'] as bool?,
    );

Map<String, dynamic> _$CompaniesVoToJson(CompaniesVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CompanyName': instance.companyName,
      'Address': instance.address,
      'CompanyLogo': instance.companyLogo,
      'PhoneNo': instance.phoneNO,
      'About': instance.about,
      'StartDate': instance.startDate,
      'SortOrder': instance.sortOrder,
      'IsActive': instance.isActive,
    };
