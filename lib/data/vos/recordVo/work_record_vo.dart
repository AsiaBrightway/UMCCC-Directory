import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/work_vo.dart';
part 'work_record_vo.g.dart';

@JsonSerializable()
class WorkRecordVo{

  @JsonKey(name: 'records')
  List<WorkVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  WorkRecordVo(this.records, this.totalRecords);

  factory WorkRecordVo.fromJson(Map<String,dynamic> json) => _$WorkRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$WorkRecordVoToJson(this);
}