import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/position_record_vo.dart';
part 'position_response.g.dart';

@JsonSerializable()
class PositionResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  PositionRecordVo? document;

  PositionResponse(this.code, this.message, this.document);

  factory PositionResponse.fromJson(Map<String,dynamic> json) => _$PositionResponseFromJson(json);

  Map<String,dynamic> toJson() => _$PositionResponseToJson(this);
}