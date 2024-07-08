
import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/family_vo.dart';
part 'family_record_vo.g.dart';

@JsonSerializable()
class FamilyRecordVo{

  @JsonKey(name: 'records')
  List<FamilyVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  FamilyRecordVo(this.records, this.totalRecords);

  factory FamilyRecordVo.fromJson(Map<String,dynamic> json) => _$FamilyRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$FamilyRecordVoToJson(this);
}