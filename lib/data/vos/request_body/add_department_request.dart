import 'package:json_annotation/json_annotation.dart';
part 'add_department_request.g.dart';

@JsonSerializable()
class AddDepartmentRequest{
  @JsonKey(name:'id')
  int? id;

  @JsonKey(name: 'companyId')
  int? companyId;

  @JsonKey(name: 'departmentName')
  String? departmentName;

  @JsonKey(name: 'isActive')
  bool? isActive;

  AddDepartmentRequest(
      this.id, this.companyId, this.departmentName, this.isActive);

  factory AddDepartmentRequest.fromJson(Map<String,dynamic> json) => _$AddDepartmentRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddDepartmentRequestToJson(this);
}