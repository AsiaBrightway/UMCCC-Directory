// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorVo _$ErrorVoFromJson(Map<String, dynamic> json) => ErrorVo(
      statusCode: (json['code'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ErrorVoToJson(ErrorVo instance) => <String, dynamic>{
      'code': instance.statusCode,
      'message': instance.message,
    };
