import 'package:json_annotation/json_annotation.dart';
part 'path_user_request.g.dart';

@JsonSerializable()
class PathUserRequest{
  @JsonKey(name: 'path')
  String? path;

  @JsonKey(name: 'op')
  String? op;

  @JsonKey(name: 'value')
  String? value;

  PathUserRequest(this.path, this.op, this.value);

  factory PathUserRequest.fromJson(Map<String,dynamic> json) => _$PathUserRequestFromJson(json);

  Map<String,dynamic> toJson() => _$PathUserRequestToJson(this);
}