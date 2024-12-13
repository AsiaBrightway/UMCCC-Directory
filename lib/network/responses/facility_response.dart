
import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/facility_record_vo.dart';
part 'facility_response.g.dart';

@JsonSerializable()
class FacilityResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  FacilityRecordVo? document;

  FacilityResponse(this.code, this.message, this.document);

  factory FacilityResponse.fromJson(Map<String,dynamic> json) => _$FacilityResponseFromJson(json);

  Map<String,dynamic> toJson() => _$FacilityResponseToJson(this);
}