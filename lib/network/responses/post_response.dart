
import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/post_record_vo.dart';
part 'post_response.g.dart';

@JsonSerializable()
class PostResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  PostRecordVo? document;

  PostResponse(this.code, this.message, this.document);

  factory PostResponse.fromJson(Map<String,dynamic> json) => _$PostResponseFromJson(json);

  Map<String,dynamic> toJson() => _$PostResponseToJson(this);
}