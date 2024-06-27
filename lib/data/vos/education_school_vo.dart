import 'package:json_annotation/json_annotation.dart';
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

  EducationSchoolVo(this.id, this.employeeId, this.name, this.fromDate,
      this.toDate, this.secondary, this.maximumAchievement, this.subjects);

  factory EducationSchoolVo.fromJson(Map<String, dynamic> json) =>
      _$EducationSchoolVoFromJson(json);

  Map<String, dynamic> toJson() => _$EducationSchoolVoToJson(this);
}