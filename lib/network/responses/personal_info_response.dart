import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/personal_info_record_vo.dart';
part 'personal_info_response.g.dart';

@JsonSerializable()
class PersonalInfoResponse {
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  PersonalInfoRecordVo? document;

  PersonalInfoResponse(this.code, this.message, this.document);

  factory PersonalInfoResponse.fromJson(Map<String,dynamic> json) => _$PersonalInfoResponseFromJson(json);

  Map<String,dynamic> toJson() => _$PersonalInfoResponseToJson(this);
}