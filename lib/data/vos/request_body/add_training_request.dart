import 'package:json_annotation/json_annotation.dart';
part 'add_training_request.g.dart';

@JsonSerializable()
class AddTrainingRequest{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'courseName')
  String? courseName;

  @JsonKey(name: 'trainingType')
  int? trainingType;

  @JsonKey(name: 'trainingProvidedBy')
  String? trainingProvidedBy;

  @JsonKey(name: 'place')
  String? place;

  @JsonKey(name: 'startDate')
  String? startDate;

  @JsonKey(name: 'endDate')
  String? endDate;

  @JsonKey(name: 'totalTrainingTime')
  String? totalTrainingTime;

  @JsonKey(name: 'trainingResult')
  int? trainingResult;

  @JsonKey(name: 'certificate')
  bool? certificate;

  @JsonKey(name: 'note')
  String? note;

  AddTrainingRequest(
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

  factory AddTrainingRequest.fromJson(Map<String,dynamic> json) => _$AddTrainingRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddTrainingRequestToJson(this);
}