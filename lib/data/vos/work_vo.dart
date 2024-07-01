import 'package:json_annotation/json_annotation.dart';
part 'work_vo.g.dart';

@JsonSerializable()
class WorkVo{
  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'EmployeeId')
  String? employeeId;

  @JsonKey(name: 'CompanyName')
  String? companyName;

  @JsonKey(name: 'Rank')
  String? rank;

  @JsonKey(name: 'FromDate')
  String? fromDate;

  @JsonKey(name: 'ToDate')
  String? toDate;

  @JsonKey(name: 'SalaryAndAllowance')
  String? salaryAndAllowance;

  @JsonKey(name: 'DetailResponsibilities')
  String? detailResponsibilities;

  WorkVo(this.id, this.employeeId, this.companyName, this.rank, this.fromDate,
      this.toDate, this.salaryAndAllowance, this.detailResponsibilities);

  factory WorkVo.fromJson(Map<String,dynamic> json) => _$WorkVoFromJson(json);

  Map<String,dynamic> toJson() => _$WorkVoToJson(this);
}