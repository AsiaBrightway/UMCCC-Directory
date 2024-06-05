// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_company_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCompanyRequest _$AddCompanyRequestFromJson(Map<String, dynamic> json) =>
    AddCompanyRequest(
      (json['id'] as num?)?.toInt(),
      json['companyName'] as String?,
      json['address'] as String?,
      json['phoneNo'] as String?,
      json['about'] as String?,
      json['companyLogo'] as String?,
      json['startDate'] as String?,
      (json['sortOrder'] as num?)?.toInt(),
      json['isActive'] as bool?,
    );

Map<String, dynamic> _$AddCompanyRequestToJson(AddCompanyRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'address': instance.address,
      'phoneNo': instance.phoneNo,
      'about': instance.about,
      'companyLogo': instance.companyLogo,
      'startDate': instance.startDate,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };
