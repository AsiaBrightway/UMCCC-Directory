import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
part 'graduate_vo.g.dart';

@JsonSerializable()
class GraduateVo{

  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'EmployeeId')
  String? employeeId;

  @JsonKey(name: 'University')
  String? university;

  @JsonKey(name: 'DegreeType')
  String? degreeType;

  @JsonKey(name: 'ReceivedYear')
  String? receivedYear;

  @JsonKey(name: 'ImageUrl')
  String? imageUrl;

  @JsonKey(name: 'Remark')
  String? remark;

  GraduateVo(this.id, this.employeeId, this.university, this.degreeType,
      this.receivedYear, this.imageUrl, this.remark);

  factory GraduateVo.fromJson(Map<String,dynamic> json) => _$GraduateVoFromJson(json);

  Map<String,dynamic> toJson() => _$GraduateVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (imageUrl ?? "");
  }
}