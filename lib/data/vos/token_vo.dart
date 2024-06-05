import 'package:json_annotation/json_annotation.dart';
part 'token_vo.g.dart';

@JsonSerializable()
class TokenVo{

  @JsonKey(name: 'AccessToken')
  String? accessToken;

  @JsonKey(name: 'UserId')
  String? userId;

  @JsonKey(name: 'userRoles')
  int? userRole;

  TokenVo(this.accessToken, this.userId, this.userRole);

  factory TokenVo.fromJson(Map<String,dynamic> json) => _$TokenVoFromJson(json);

  Map<String,dynamic> toJson() => _$TokenVoToJson(this);
}