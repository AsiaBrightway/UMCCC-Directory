import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/recordVo/language_record_vo.dart';
part 'language_response.g.dart';

@JsonSerializable()
class LanguageResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  LanguageRecordVo? document;

  LanguageResponse(this.code, this.message, this.document);

  factory LanguageResponse.fromJson(Map<String,dynamic> json) => _$LanguageResponseFromJson(json);

  Map<String,dynamic> toJson() => _$LanguageResponseToJson(this);
}