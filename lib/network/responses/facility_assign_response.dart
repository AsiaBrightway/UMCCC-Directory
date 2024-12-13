
import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/recordVo/facility_assign_record_vo.dart';
part 'facility_assign_response.g.dart';

@JsonSerializable()
class FacilityAssignResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  FacilityAssignRecordVo? document;

  FacilityAssignResponse(this.code, this.message, this.document);

  factory FacilityAssignResponse.fromJson(Map<String,dynamic> json) => _$FacilityAssignResponseFromJson(json);

  Map<String,dynamic> toJson() => _$FacilityAssignResponseToJson(this);
}