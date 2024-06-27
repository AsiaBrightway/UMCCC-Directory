import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/education_school_record_vo.dart';
part 'school_response.g.dart';

@JsonSerializable()
class SchoolResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  EducationSchoolRecordVo? document;

  SchoolResponse(this.code, this.message, this.document);

  factory SchoolResponse.fromJson(Map<String,dynamic> json) => _$SchoolResponseFromJson(json);

  Map<String,dynamic> toJson() => _$SchoolResponseToJson(this);
}