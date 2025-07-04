import 'package:json_annotation/json_annotation.dart';
part 'error_vo.g.dart';

@JsonSerializable()
class ErrorVo{

  @JsonKey(name: 'code')
  final int statusCode;

  @JsonKey(name:'message')
  final String message;

  ErrorVo({required this.statusCode,required this.message});

  factory ErrorVo.fromJson(Map<String,dynamic> json) => _$ErrorVoFromJson(json);

  Map<String,dynamic> toJson() => _$ErrorVoToJson(this);
}