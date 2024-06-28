import 'package:json_annotation/json_annotation.dart';
part 'add_graduate_request.g.dart';

@JsonSerializable()
class AddGraduateRequest{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'university')
  String? university;

  @JsonKey(name: 'degreeType')
  String? degreeType;

  @JsonKey(name: 'receivedYear')
  String? receivedYear;

  AddGraduateRequest(this.id, this.employeeId, this.university, this.degreeType,
      this.receivedYear);

  factory AddGraduateRequest.fromJson(Map<String,dynamic> json) => _$AddGraduateRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddGraduateRequestToJson(this);
}