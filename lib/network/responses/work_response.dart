import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/recordVo/work_record_vo.dart';
part 'work_response.g.dart';

@JsonSerializable()
class WorkResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  WorkRecordVo? document;

  WorkResponse(this.code, this.message, this.document);

  factory WorkResponse.fromJson(Map<String,dynamic> json) => _$WorkResponseFromJson(json);

  Map<String,dynamic> toJson() => _$WorkResponseToJson(this);
}