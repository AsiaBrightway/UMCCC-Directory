import 'package:json_annotation/json_annotation.dart';
import '../../data/vos/recordVo/discipline_record_vo.dart';
part 'discipline_response.g.dart';

@JsonSerializable()
class DisciplineResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  DisciplineRecordVo? document;

  DisciplineResponse(this.code, this.message, this.document);

  factory DisciplineResponse.fromJson(Map<String,dynamic> json) => _$DisciplineResponseFromJson(json);

  Map<String,dynamic> toJson() => _$DisciplineResponseToJson(this);
}