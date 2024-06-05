import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/user_vo.dart';
part 'user_response.g.dart';

@JsonSerializable()
class UserResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  UserVo? document;

  UserResponse(this.code, this.message, this.document);

  factory UserResponse.fromJson(Map<String,dynamic> json) => _$UserResponseFromJson(json);

  Map<String,dynamic> toJson() => _$UserResponseToJson(this);
}