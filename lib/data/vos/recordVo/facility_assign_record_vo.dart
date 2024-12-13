import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/facility_assign_vo.dart';
part 'facility_assign_record_vo.g.dart';

@JsonSerializable()
class FacilityAssignRecordVo{
  @JsonKey(name: 'records')
  List<FacilityAssignVo>? records;

  @JsonKey(name: 'pageNumber')
  int? pageNumber;

  @JsonKey(name: 'totalRecords')
  int? total;

  FacilityAssignRecordVo(this.records, this.pageNumber, this.total);

  factory FacilityAssignRecordVo.fromJson(Map<String,dynamic> json) => _$FacilityAssignRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$FacilityAssignRecordVoToJson(this);
}