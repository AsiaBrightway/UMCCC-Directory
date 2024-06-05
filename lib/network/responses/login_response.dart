import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/token_vo.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse{

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  TokenVo? tokenVo;

  LoginResponse(this.code, this.message, this.tokenVo);

  factory LoginResponse.fromJson(Map<String,dynamic> json) => _$LoginResponseFromJson(json);

  Map<String,dynamic> toJson() => _$LoginResponseToJson(this);
}