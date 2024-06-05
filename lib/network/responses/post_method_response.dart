import 'package:json_annotation/json_annotation.dart';
part 'post_method_response.g.dart';

@JsonSerializable()
class PostMethodResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  int? document;

  PostMethodResponse(this.code, this.message, this.document);

  factory PostMethodResponse.fromJson(Map<String,dynamic> json) => _$PostMethodResponseFromJson(json);

  Map<String,dynamic> toJson() => _$PostMethodResponseToJson(this);
}