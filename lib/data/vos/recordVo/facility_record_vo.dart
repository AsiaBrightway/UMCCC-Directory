import 'package:json_annotation/json_annotation.dart';

import '../facility_vo.dart';
part 'facility_record_vo.g.dart';

@JsonSerializable()
class FacilityRecordVo{
  @JsonKey(name: 'records')
  List<FacilityVo>? records;

  @JsonKey(name: 'pageNumber')
  int? pageNumber;

  @JsonKey(name: 'totalRecords')
  int? total;

  FacilityRecordVo(this.records, this.pageNumber, this.total);

  factory FacilityRecordVo.fromJson(Map<String,dynamic> json) => _$FacilityRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$FacilityRecordVoToJson(this);
}