import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/position_vo.dart';

part 'position_record_vo.g.dart';

@JsonSerializable()
class PositionRecordVo{

  @JsonKey(name: 'records')
  List<PositionVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  PositionRecordVo(this.records, this.totalRecords);

  factory PositionRecordVo.fromJson(Map<String,dynamic> json) => _$PositionRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$PositionRecordVoToJson(this);
}