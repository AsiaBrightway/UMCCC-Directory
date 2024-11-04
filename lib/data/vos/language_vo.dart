import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
import '../../network/api_constants.dart';
part 'language_vo.g.dart';

@JsonSerializable()
class LanguageVo{
  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'EmployeeId')
  String? employeeId;

  @JsonKey(name: 'Name')
  String? name;

  @JsonKey(name: 'Proficiency')
  int? proficiency;

  @JsonKey(name: 'Teach')
  bool? teach;

  @JsonKey(name: 'ImageUrl')
  String? imageUrl;

  @JsonKey(name: 'Remark')
  String? remark;


  LanguageVo(this.id, this.employeeId, this.name, this.proficiency, this.teach,
      this.imageUrl, this.remark);

  factory LanguageVo.fromJson(Map<String,dynamic> json) => _$LanguageVoFromJson(json);

  Map<String,dynamic> toJson() => _$LanguageVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (imageUrl ?? "");
  }
}