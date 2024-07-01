import 'package:json_annotation/json_annotation.dart';
part 'add_language_request.g.dart';

@JsonSerializable()
class AddLanguageRequest{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'proficiency')
  int? proficiency;

  @JsonKey(name: 'teach')
  bool? teach;

  AddLanguageRequest(
      this.id, this.employeeId, this.name, this.proficiency, this.teach);

  factory AddLanguageRequest.fromJson(Map<String,dynamic> json) => _$AddLanguageRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddLanguageRequestToJson(this);
}