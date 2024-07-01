import 'package:json_annotation/json_annotation.dart';
part 'add_work_request.g.dart';

@JsonSerializable()
class AddWorkRequest{

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'companyName')
  String? companyName;

  @JsonKey(name: 'rank')
  String? rank;

  @JsonKey(name: 'fromDate')
  String? fromDate;

  @JsonKey(name: 'toDate')
  String? toDate;

  @JsonKey(name: 'salaryAndAllowance')
  String? salaryAndAllowance;

  @JsonKey(name: 'detailResponsibilities')
  String? detailResponsibilities;

  AddWorkRequest(
      this.id,
      this.employeeId,
      this.companyName,
      this.rank,
      this.fromDate,
      this.toDate,
      this.salaryAndAllowance,
      this.detailResponsibilities);

  factory AddWorkRequest.fromJson(Map<String,dynamic> json) => _$AddWorkRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddWorkRequestToJson(this);

}