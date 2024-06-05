// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVo _$UserVoFromJson(Map<String, dynamic> json) => UserVo(
      json['Id'] as String?,
      (json['UserRolesId'] as num?)?.toInt(),
      json['Password'] as String?,
      json['Email'] as String?,
      json['PhoneNumber'] as String?,
      json['LogoutEnabled'] as bool?,
      json['IsActive'] as bool?,
    );

Map<String, dynamic> _$UserVoToJson(UserVo instance) => <String, dynamic>{
      'Id': instance.id,
      'UserRolesId': instance.userRolesId,
      'Password': instance.password,
      'Email': instance.email,
      'PhoneNumber': instance.phoneNumber,
      'LogoutEnabled': instance.logoutEnabled,
      'IsActive': instance.isActive,
    };
