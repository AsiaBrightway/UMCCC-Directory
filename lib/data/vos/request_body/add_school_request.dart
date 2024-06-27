import 'package:json_annotation/json_annotation.dart';
part 'add_school_request.g.dart';

@JsonSerializable()
class AddSchoolRequest{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'fromDate')
  String? fromDate;

  @JsonKey(name: 'toDate')
  String? toDate;

  @JsonKey(name: 'secondary')
  String? secondary;

  @JsonKey(name: 'maximumAchievement')
  String? maximumAchievement;

  @JsonKey(name: 'subjects')
  String? subjects;

  AddSchoolRequest(this.id, this.employeeId, this.name, this.fromDate,
      this.toDate, this.secondary, this.maximumAchievement, this.subjects);

  factory AddSchoolRequest.fromJson(Map<String,dynamic> json) => _$AddSchoolRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddSchoolRequestToJson(this);
}