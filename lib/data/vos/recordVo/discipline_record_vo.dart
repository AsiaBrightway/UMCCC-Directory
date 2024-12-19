import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/discipline_vo.dart';
part 'discipline_record_vo.g.dart';

@JsonSerializable()
class DisciplineRecordVo{
  @JsonKey(name: 'records')
  List<DisciplineVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  DisciplineRecordVo(this.records, this.totalRecords);

  factory DisciplineRecordVo.fromJson(Map<String,dynamic> json) => _$DisciplineRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$DisciplineRecordVoToJson(this);

}