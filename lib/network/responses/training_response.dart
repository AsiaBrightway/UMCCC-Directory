import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/recordVo/training_record_vo.dart';
part 'training_response.g.dart';

@JsonSerializable()
class TrainingResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  TrainingRecordVo? document;

  TrainingResponse(this.code, this.message, this.document);

  factory TrainingResponse.fromJson(Map<String,dynamic> json) => _$TrainingResponseFromJson(json);

  Map<String,dynamic> toJson() => _$TrainingResponseToJson(this);
}