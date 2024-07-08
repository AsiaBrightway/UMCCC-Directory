import 'package:json_annotation/json_annotation.dart';
part 'training_vo.g.dart';

@JsonSerializable()
class TrainingVo{
  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'EmployeeId')
  String? employeeId;

  @JsonKey(name: 'CourseName')
  String? courseName;

  @JsonKey(name: 'TrainingType')
  int? trainingType;

  @JsonKey(name: 'TrainingProvidedBy')
  String? trainingProvidedBy;

  @JsonKey(name: 'Place')
  String? place;

  @JsonKey(name: 'StartDate')
  String? startDate;

  @JsonKey(name: 'EndDate')
  String? endDate;

  @JsonKey(name: 'TotalTrainingTime')
  String? totalTrainingTime;

  @JsonKey(name: 'TrainingResult')
  int? trainingResult;

  @JsonKey(name: 'Certificate')
  bool? certificate;

  @JsonKey(name: 'Note')
  String? note;

  TrainingVo(
      this.id,
      this.employeeId,
      this.courseName,
      this.trainingType,
      this.trainingProvidedBy,
      this.place,
      this.startDate,
      this.endDate,
      this.totalTrainingTime,
      this.trainingResult,
      this.certificate,
      this.note);

  factory TrainingVo.fromJson(Map<String,dynamic> json) => _$TrainingVoFromJson(json);

  Map<String,dynamic> toJson() => _$TrainingVoToJson(this);
}