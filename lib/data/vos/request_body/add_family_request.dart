
import 'package:json_annotation/json_annotation.dart';
part 'add_family_request.g.dart';

@JsonSerializable()
class AddFamilyRequest{

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'dateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'race')
  String? race;

  @JsonKey(name: 'identityNumber')
  String? identityNumber;

  @JsonKey(name: 'employment')
  String? employment;

  @JsonKey(name: 'rank')
  String? rank;

  @JsonKey(name: 'ministryAndCompany')
  String? ministryAndCompany;

  @JsonKey(name: 'relationship')
  String? relationship;

  AddFamilyRequest(
      this.id,
      this.employeeId,
      this.name,
      this.dateOfBirth,
      this.race,
      this.identityNumber,
      this.employment,
      this.rank,
      this.ministryAndCompany,
      this.relationship);

  factory AddFamilyRequest.fromJson(Map<String,dynamic> json) => _$AddFamilyRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddFamilyRequestToJson(this);
}