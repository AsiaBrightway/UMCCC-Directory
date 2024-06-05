import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/image_vo.dart';
part 'image_upload_response.g.dart';

@JsonSerializable()
class ImageUploadResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  ImageVo? document;

  ImageUploadResponse(this.code, this.message, this.document);

  factory ImageUploadResponse.fromJson(Map<String,dynamic> json) => _$ImageUploadResponseFromJson(json);

  Map<String,dynamic> toJson() => _$ImageUploadResponseToJson(this);
}