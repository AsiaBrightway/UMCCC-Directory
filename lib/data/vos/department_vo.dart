import 'package:json_annotation/json_annotation.dart';
part 'department_vo.g.dart';

@JsonSerializable()
class DepartmentVo{
  @JsonKey(name:'Id')
  int? id;

  @JsonKey(name:'CompanyId')
  int? companyId;

  @JsonKey(name: 'DepartmentName')
  String? departmentName;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  DepartmentVo(this.id, this.companyId, this.departmentName, this.isActive);

  factory DepartmentVo.fromJson(Map<String,dynamic> json) => _$DepartmentVoFromJson(json);

  Map<String,dynamic> toJson() => _$DepartmentVoToJson(this);
}