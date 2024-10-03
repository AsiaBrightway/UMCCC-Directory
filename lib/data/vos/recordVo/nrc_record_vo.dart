
import 'package:json_annotation/json_annotation.dart';

import '../nrc_township_vo.dart';
part 'nrc_record_vo.g.dart';

@JsonSerializable()
class NrcRecordVo{

  @JsonKey(name: 'records')
  List<NrcTownshipVo>? records;

  @JsonKey(name: 'pageSize')
  int? pageSize;

  @JsonKey(name: 'pageNumber')
  int? pageNumber;

  NrcRecordVo(this.records, this.pageSize, this.pageNumber);

  factory NrcRecordVo.fromJson(Map<String,dynamic> json) => _$NrcRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$NrcRecordVoToJson(this);
}