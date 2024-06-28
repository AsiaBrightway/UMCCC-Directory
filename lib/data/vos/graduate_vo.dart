import 'package:json_annotation/json_annotation.dart';
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

  GraduateVo(this.id, this.employeeId, this.university, this.degreeType,
      this.receivedYear);

  factory GraduateVo.fromJson(Map<String,dynamic> json) => _$GraduateVoFromJson(json);

  Map<String,dynamic> toJson() => _$GraduateVoToJson(this);
}