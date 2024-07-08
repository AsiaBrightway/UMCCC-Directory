
import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/recordVo/family_record_vo.dart';
part 'family_response.g.dart';

@JsonSerializable()
class FamilyResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  FamilyRecordVo? document;

  FamilyResponse(this.code, this.message, this.document);

  factory FamilyResponse.fromJson(Map<String,dynamic> json) => _$FamilyResponseFromJson(json);

  Map<String,dynamic> toJson() => _$FamilyResponseToJson(this);
}