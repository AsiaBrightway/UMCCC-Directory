import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/employee_record_vo.dart';
part 'employee_list_response.g.dart';

@JsonSerializable()
class EmployeeListResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  EmployeeRecordVo? document;

  EmployeeListResponse(this.code, this.message, this.document);

  factory EmployeeListResponse.fromJson(Map<String,dynamic> json) => _$EmployeeListResponseFromJson(json);

  Map<String,dynamic> toJson() => _$EmployeeListResponseToJson(this);
}