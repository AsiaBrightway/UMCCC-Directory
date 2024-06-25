import 'package:json_annotation/json_annotation.dart';
part 'personal_info_request.g.dart';

@JsonSerializable()
class PersonalInfoRequest{

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'employeeId')
  String? employeeId;

  @JsonKey(name: 'gender')
  bool? gender;

  @JsonKey(name: 'address')
  String? address;

  @JsonKey(name: 'telNoOffice')
  String? telNoOffice;

  @JsonKey(name: 'telNoHome')
  String? telNoHome;

  @JsonKey(name: 'dateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'age')
  int? age;

  @JsonKey(name: 'placeOfBirth')
  String? placeOfBirth;

  @JsonKey(name: 'nationality')
  String? nationality;

  @JsonKey(name: 'religion')
  String? religion;

  @JsonKey(name: 'race')
  String? race;

  @JsonKey(name: 'health')
  String? health;

  @JsonKey(name: 'bloodType')
  int? bloodType;

  @JsonKey(name: 'handUsage')
  int? handUsage;

  @JsonKey(name: 'hairColor')
  String? hairColor;

  @JsonKey(name: 'eyeColor')
  String? eyeColor;

  @JsonKey(name: 'skinColor')
  String? skinColor;

  @JsonKey(name: 'marriageStatus')
  int? marriageStatus;

  @JsonKey(name: 'emmergencyContactName')
  String? emergencyContactName;

  @JsonKey(name: 'emmergencyContactRelation')
  String? emergencyContactRelation;

  @JsonKey(name: 'emmergencyContactAddress')
  String? emergencyContactAddress;

  @JsonKey(name: 'emmergencyContactHomePhone')
  String? emergencyContactHomePhone;

  @JsonKey(name: 'emmergencyContactOfficePhone')
  String? emergencyContactOfficePhone;

  @JsonKey(name: 'emmergencyContactMobilePhone')
  String? emergencyContactMobilePhone;

  @JsonKey(name: 'sportAndHobby')
  String? sportAndHobby;

  @JsonKey(name: 'socialActivities')
  String? socialActivities;

  @JsonKey(name: 'drivingLicenceStatus')
  int? drivingLicenceStatus;

  @JsonKey(name: 'drivingLicenceType')
  int? drivingLicenceType;

  @JsonKey(name: 'drivingLicenceColor')
  int? drivingLicenceColor;

  @JsonKey(name: 'vehiclePunishment')
  bool? vehiclePunishment;

  @JsonKey(name: 'vehiclePunishmentDescription')
  String? vehiclePunishmentDescription;

  @JsonKey(name: 'previousApplied')
  bool? previousApplied;

  @JsonKey(name: 'previousAppliedDescription')
  String? previousAppliedDescription;

  @JsonKey(name: 'hrDepartmentRecord')
  String? hRDepartmentRecord;

  PersonalInfoRequest({
      this.id,
      this.employeeId,
      this.gender,
      this.address,
      this.telNoOffice,
      this.telNoHome,
      this.dateOfBirth,
      this.age,
      this.placeOfBirth,
      this.nationality,
      this.religion,
      this.race,
      this.health,
      this.bloodType,
      this.handUsage,
      this.hairColor,
      this.eyeColor,
      this.skinColor,
      this.marriageStatus,
      this.emergencyContactName,
      this.emergencyContactRelation,
      this.emergencyContactAddress,
      this.emergencyContactHomePhone,
      this.emergencyContactOfficePhone,
      this.emergencyContactMobilePhone,
      this.sportAndHobby,
      this.socialActivities,
      this.drivingLicenceStatus,
      this.drivingLicenceType,
      this.drivingLicenceColor,
      this.vehiclePunishment,
      this.vehiclePunishmentDescription,
      this.previousApplied,
      this.previousAppliedDescription,
      this.hRDepartmentRecord});

  factory PersonalInfoRequest.fromJson(Map<String,dynamic> json) => _$PersonalInfoRequestFromJson(json);

  Map<String,dynamic> toJson() => _$PersonalInfoRequestToJson(this);
}