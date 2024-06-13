import 'package:json_annotation/json_annotation.dart';
part 'update_employee_request.g.dart';

@JsonSerializable()
class UpdateEmployeeRequest{
  @JsonKey(name: 'id')
  String? id;

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

  UpdateEmployeeRequest(
      this.id,
      this.employeeName,
      this.imageUrl,
      this.companyId,
      this.departmentId,
      this.positionId,
      this.employeeNumber,
      this.jdCode);

  factory UpdateEmployeeRequest.fromJson(Map<String,dynamic> json) => _$UpdateEmployeeRequestFromJson(json);

  Map<String,dynamic> toJson() => _$UpdateEmployeeRequestToJson(this);
}