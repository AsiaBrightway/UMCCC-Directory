import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
import '../../network/api_constants.dart';
part 'education_school_vo.g.dart';

@JsonSerializable()
class EducationSchoolVo {

  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'EmployeeId')
  String? employeeId;

  @JsonKey(name: 'Name')
  String? name;

  @JsonKey(name: 'FromDate')
  String? fromDate;

  @JsonKey(name: 'ToDate')
  String? toDate;

  @JsonKey(name: 'Secondary')
  String? secondary;

  @JsonKey(name: 'MaximumAchievement')
  String? maximumAchievement;

  @JsonKey(name: 'Subjects')
  String? subjects;

  @JsonKey(name: 'ImageUrl')
  String? imageUrl;

  @JsonKey(name: 'Remark')
  String? remark;

  EducationSchoolVo(this.id, this.employeeId, this.name, this.fromDate,this.toDate,
      this.secondary, this.maximumAchievement, this.subjects, this.imageUrl,this.remark);

  factory EducationSchoolVo.fromJson(Map<String, dynamic> json) =>
      _$EducationSchoolVoFromJson(json);

  Map<String, dynamic> toJson() => _$EducationSchoolVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (imageUrl ?? "");
  }
}