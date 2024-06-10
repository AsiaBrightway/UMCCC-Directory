import 'package:json_annotation/json_annotation.dart';
part 'add_employee_request.g.dart';

@JsonSerializable()
class AddEmployeeRequest{
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'userRolesId')
  int? userRoleId;

  @JsonKey(name: 'password')
  String? password;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'phoneNumber')
  String? phoneNumber;

  @JsonKey(name: 'logoutEnabled')
  bool? logoutEnabled;

  @JsonKey(name: 'isActive')
  bool? isActive;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'employeeName')
  String? employeeName;

  @JsonKey(name: 'image_Url')
  String? imageUrl;

  @JsonKey(name: 'companyId')
  int? companyId;

  @JsonKey(name: 'departmentId')
  int? departmentId;

  @JsonKey(name: 'positionId')
  int? positionId;

  @JsonKey(name: 'employeeNumber')
  String? employeeNumber;

  @JsonKey(name: 'jdCode')
  String? jdCode;

  AddEmployeeRequest(
      this.id,
      this.userRoleId,
      this.password,
      this.email,
      this.phoneNumber,
      this.logoutEnabled,
      this.isActive,
      this.employeeId,
      this.employeeName,
      this.imageUrl,
      this.companyId,
      this.departmentId,
      this.positionId,
      this.employeeNumber,
      this.jdCode);

  factory AddEmployeeRequest.fromJson(Map<String,dynamic> json) => _$AddEmployeeRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddEmployeeRequestToJson(this);
}