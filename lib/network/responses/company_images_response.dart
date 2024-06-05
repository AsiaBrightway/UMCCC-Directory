import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/company_images_record_vo.dart';
part 'company_images_response.g.dart';

@JsonSerializable()
class CompanyImagesResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  CompanyImagesRecordVo? document;

  CompanyImagesResponse(this.code, this.message, this.document);

  factory CompanyImagesResponse.fromJson(Map<String,dynamic> json) => _$CompanyImagesResponseFromJson(json);

  Map<String,dynamic> toJson() => _$CompanyImagesResponseToJson(this);
}
