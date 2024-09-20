import 'package:json_annotation/json_annotation.dart';

import '../../network/api_constants.dart';
part 'employee_vo.g.dart';

@JsonSerializable()
class EmployeeVo{

  @JsonKey(name:'Id')
  String? id;

  @JsonKey(name:'EmployeeName')
  String? employeeName;

  @JsonKey(name:'Image_Url')
  String? imageUrl;

  @JsonKey(name: 'CompanyId')
  int? companyId;

  @JsonKey(name: 'DepartmentId')
  int? departmentId;

  @JsonKey(name: 'PositionId')
  int? positionId;

  @JsonKey(name: 'EmployeeNumber')
  String? employeeNumber;

  @JsonKey(name: 'AppointmentDate')
  String? jdCode;

  @JsonKey(name: 'Remark')
  String? remark;

  @JsonKey(name: 'DepartmentName')
  String? departmentName;

  @JsonKey(name: 'Position')
  String? position;

  @JsonKey(name: 'CompanyName')
  String? companyName;

  EmployeeVo(
      this.id,
      this.employeeName,
      this.imageUrl,
      this.companyId,
      this.departmentId,
      this.positionId,
      this.employeeNumber,
      this.jdCode,
      this.remark,
      this.departmentName,
      this.position,
      this.companyName);

  factory EmployeeVo.fromJson(Map<String,dynamic> json) => _$EmployeeVoFromJson(json);

  Map<String,dynamic> toJson() => _$EmployeeVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (imageUrl ?? "");
  }
}