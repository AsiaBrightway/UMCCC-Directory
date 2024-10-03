
import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/nrc_record_vo.dart';
part 'township_response.g.dart';

@JsonSerializable()
class TownshipResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  NrcRecordVo? document;

  TownshipResponse(this.code, this.message, this.document);

  factory TownshipResponse.fromJson(Map<String,dynamic> json) => _$TownshipResponseFromJson(json);

  Map<String,dynamic> toJson() => _$TownshipResponseToJson(this);
}