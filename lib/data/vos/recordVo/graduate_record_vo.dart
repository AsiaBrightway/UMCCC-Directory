import 'package:json_annotation/json_annotation.dart';
import '../graduate_vo.dart';
part 'graduate_record_vo.g.dart';

@JsonSerializable()
class GraduateRecordVo{

  @JsonKey(name: 'records')
  List<GraduateVo>? records;

  @JsonKey(name: 'pageSize')
  int? pageSize;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  GraduateRecordVo(this.records, this.pageSize, this.totalRecords);

  factory GraduateRecordVo.fromJson(Map<String,dynamic> json) => _$GraduateRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$GraduateRecordVoToJson(this);
}