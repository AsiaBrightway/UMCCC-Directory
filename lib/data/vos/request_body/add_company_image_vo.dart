import 'package:json_annotation/json_annotation.dart';
part 'add_company_image_vo.g.dart';

@JsonSerializable()
class AddCompanyImageVo{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'companyId')
  int? companyId;

  @JsonKey(name: 'image_Url')
  String? imageUrl;

  AddCompanyImageVo(this.id, this.companyId, this.imageUrl);

  factory AddCompanyImageVo.fromJson(Map<String,dynamic> json) => _$AddCompanyImageVoFromJson(json);

  Map<String,dynamic> toJson() => _$AddCompanyImageVoToJson(this);
}