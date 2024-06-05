// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadResponse _$ImageUploadResponseFromJson(Map<String, dynamic> json) =>
    ImageUploadResponse(
      (json['code'] as num?)?.toInt(),
      json['message'] as String?,
      json['document'] == null
          ? null
          : ImageVo.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImageUploadResponseToJson(
        ImageUploadResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'document': instance.document,
    };
