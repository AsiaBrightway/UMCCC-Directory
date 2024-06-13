import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
part 'employee_response.g.dart';

@JsonSerializable()
class EmployeeResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  EmployeeVo? document;

  EmployeeResponse(this.code, this.message, this.document);

  factory EmployeeResponse.fromJson(Map<String,dynamic> json) => _$EmployeeResponseFromJson(json);

  Map<String,dynamic> toJson() => _$EmployeeResponseToJson(this);
}