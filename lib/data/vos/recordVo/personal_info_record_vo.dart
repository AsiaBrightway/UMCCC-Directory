import 'package:json_annotation/json_annotation.dart';

import '../personal_info_vo.dart';
part 'personal_info_record_vo.g.dart';

@JsonSerializable()
class PersonalInfoRecordVo{
  @JsonKey(name: 'records')
  List<PersonalInfoVo>? records;

  PersonalInfoRecordVo(this.records);

  factory PersonalInfoRecordVo.fromJson(Map<String,dynamic> json) => _$PersonalInfoRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$PersonalInfoRecordVoToJson(this);
}