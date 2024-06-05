import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/department_vo.dart';
part 'department_record_vo.g.dart';

@JsonSerializable()
class DepartmentRecordVo{

  @JsonKey(name: 'records')
  List<DepartmentVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  DepartmentRecordVo(this.records, this.totalRecords);

  factory DepartmentRecordVo.fromJson(Map<String,dynamic> json) => _$DepartmentRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$DepartmentRecordVoToJson(this);
}