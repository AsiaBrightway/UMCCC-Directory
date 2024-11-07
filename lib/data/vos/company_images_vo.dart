import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
part 'company_images_vo.g.dart';

@JsonSerializable()
class CompanyImagesVo{

  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'CompanyId')
  int? companyId;

  @JsonKey(name: 'Image_Url')
  String? imageUrl;

  CompanyImagesVo(this.id, this.companyId, this.imageUrl);

  factory CompanyImagesVo.fromJson(Map<String,dynamic> json) => _$CompanyImagesVoFromJson(json);

  Map<String,dynamic> json() => _$CompanyImagesVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (imageUrl ?? "");
  }
}