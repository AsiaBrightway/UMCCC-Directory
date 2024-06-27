import 'package:json_annotation/json_annotation.dart';
import '../education_school_vo.dart';
part 'education_school_record_vo.g.dart';

@JsonSerializable()
class EducationSchoolRecordVo{
  @JsonKey(name: 'records')
  List<EducationSchoolVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  EducationSchoolRecordVo(this.records, this.totalRecords);

  factory EducationSchoolRecordVo.fromJson(Map<String,dynamic> json) => _$EducationSchoolRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$EducationSchoolRecordVoToJson(this);
}