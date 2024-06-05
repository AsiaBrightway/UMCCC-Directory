import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/department_record_vo.dart';
part 'department_list_response.g.dart';

@JsonSerializable()
class DepartmentListResponse{

  @JsonKey(name:'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  DepartmentRecordVo? document;

  DepartmentListResponse(this.code, this.message, this.document);

  factory DepartmentListResponse.fromJson(Map<String,dynamic> json) => _$DepartmentListResponseFromJson(json);

  Map<String,dynamic> toJson() => _$DepartmentListResponseToJson(this);
}