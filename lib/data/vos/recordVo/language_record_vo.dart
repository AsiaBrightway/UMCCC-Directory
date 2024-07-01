import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/language_vo.dart';
part 'language_record_vo.g.dart';

@JsonSerializable()
class LanguageRecordVo{

  @JsonKey(name: 'records')
  List<LanguageVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  @JsonKey(name: 'pageSize')
  int? pageSize;

  LanguageRecordVo(this.records, this.totalRecords, this.pageSize);

  factory LanguageRecordVo.fromJson(Map<String,dynamic> json) => _$LanguageRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$LanguageRecordVoToJson(this);
}