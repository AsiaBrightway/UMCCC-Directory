import 'package:json_annotation/json_annotation.dart';
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

  LanguageVo(this.id, this.employeeId, this.name, this.proficiency, this.teach);

  factory LanguageVo.fromJson(Map<String,dynamic> json) => _$LanguageVoFromJson(json);

  Map<String,dynamic> toJson() => _$LanguageVoToJson(this);
}