
import 'package:json_annotation/json_annotation.dart';
part 'family_vo.g.dart';

@JsonSerializable()
class FamilyVo{

  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'EmployeeId')
  String? employeeId;

  @JsonKey(name: 'Name')
  String? name;

  @JsonKey(name: 'DateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'Race')
  String? race;

  @JsonKey(name: 'IdentityNumber')
  String? identityNumber;

  @JsonKey(name: 'Employment')
  String? employment;

  @JsonKey(name: 'Rank')
  String? rank;

  @JsonKey(name: 'MinistryAndCompany')
  String? ministryAndCompany;

  @JsonKey(name: 'Relationship')
  String? relationship;

  FamilyVo(
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

  factory FamilyVo.fromJson(Map<String,dynamic> json) => _$FamilyVoFromJson(json);

  Map<String,dynamic> toJson() => _$FamilyVoToJson(this);
}