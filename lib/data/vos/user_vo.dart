import 'package:json_annotation/json_annotation.dart';
part 'user_vo.g.dart';

@JsonSerializable()
class UserVo{

  @JsonKey(name: 'Id')
  String? id;

  @JsonKey(name: 'UserRolesId')
  int? userRolesId;

  @JsonKey(name: 'Password')
  String? password;

  @JsonKey(name: 'Email')
  String? email;

  @JsonKey(name: 'PhoneNumber')
  String? phoneNumber;

  @JsonKey(name: 'LogoutEnabled')
  bool? logoutEnabled;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  UserVo(this.id, this.userRolesId, this.password, this.email, this.phoneNumber,
      this.logoutEnabled, this.isActive);

  factory UserVo.fromJson(Map<String,dynamic> json) => _$UserVoFromJson(json);

  Map<String,dynamic> toJson() => _$UserVoToJson(this);
}