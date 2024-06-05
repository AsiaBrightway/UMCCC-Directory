// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_method_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMethodResponse _$PostMethodResponseFromJson(Map<String, dynamic> json) =>
    PostMethodResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      (json['document'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PostMethodResponseToJson(PostMethodResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
