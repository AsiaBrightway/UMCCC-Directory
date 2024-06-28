import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/recordVo/graduate_record_vo.dart';
part 'graduate_response.g.dart';

@JsonSerializable()
class GraduateResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  GraduateRecordVo? document;

  GraduateResponse(this.code, this.message, this.document);

  factory GraduateResponse.fromJson(Map<String,dynamic> json) => _$GraduateResponseFromJson(json);

  Map<String,dynamic> toJson() => _$GraduateResponseToJson(this);
}