import 'package:json_annotation/json_annotation.dart';

import '../employee_vo.dart';
part 'employee_record_vo.g.dart';

@JsonSerializable()
class EmployeeRecordVo{

  @JsonKey(name: 'records')
  List<EmployeeVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  EmployeeRecordVo(this.records, this.totalRecords);

  factory EmployeeRecordVo.fromJson(Map<String,dynamic> json) => _$EmployeeRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$EmployeeRecordVoToJson(this);
}