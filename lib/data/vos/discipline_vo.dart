import 'package:json_annotation/json_annotation.dart';
part 'discipline_vo.g.dart';

@JsonSerializable()
class DisciplineVo{
  @JsonKey(name: 'discipline_id')
  int? id;

  @JsonKey(name: 'employee_id')
  String? employeeId;

  @JsonKey(name: 'discipline_type')
  String? disciplineType;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'discipline_date')
  String? disciplineDate;

  @JsonKey(name: 'action_taken_by')
  String? actionTakenBy;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'createdBy')
  String? createdBy;

  @JsonKey(name: 'updatedBy')
  String? updatedBy;

  @JsonKey(name: 'createdAt')
  String? createdAt;

  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  DisciplineVo(
      this.id,
      this.employeeId,
      this.disciplineType,
      this.description,
      this.disciplineDate,
      this.actionTakenBy,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt);

  factory DisciplineVo.fromJson(Map<String,dynamic> json) => _$DisciplineVoFromJson(json);

  Map<String,dynamic> toJson() => _$DisciplineVoToJson(this);
}