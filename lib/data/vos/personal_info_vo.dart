import 'package:json_annotation/json_annotation.dart';
part 'personal_info_vo.g.dart';

@JsonSerializable()
class PersonalInfoVo {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'EmployeeId')
  String? employeeId;

  @JsonKey(name: 'Gender')
  bool? gender;

  @JsonKey(name: 'Address')
  String? address;

  @JsonKey(name: 'TelNoOffice')
  String? telNoOffice;

  @JsonKey(name: 'TelNoHome')
  String? telNoHome;

  @JsonKey(name: 'DateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'Age')
  int? age;

  @JsonKey(name: 'PlaceOfBirth')
  String? placeOfBirth;

  @JsonKey(name: 'Nationality')
  String? nationality;

  @JsonKey(name: 'Religion')
  String? religion;

  @JsonKey(name: 'Race')
  String? race;

  @JsonKey(name: 'Health')
  String? health;

  @JsonKey(name: 'BloodType')
  int? bloodType;

  @JsonKey(name: 'HandUsage')
  int? handUsage;

  @JsonKey(name: 'HairColor')
  String? hairColor;

  @JsonKey(name: 'EyeColor')
  String? eyeColor;

  @JsonKey(name: 'SkinColor')
  String? skinColor;

  @JsonKey(name: 'MarriageStatus')
  int? marriageStatus;

  @JsonKey(name: 'EmmergencyContactName')
  String? emergencyContactName;

  @JsonKey(name: 'EmmergencyContactRelation')
  String? emergencyContactRelation;

  @JsonKey(name: 'EmmergencyContactAddress')
  String? emergencyContactAddress;

  @JsonKey(name: 'EmmergencyContactHomePhone')
  String? emergencyContactHomePhone;

  @JsonKey(name: 'EmmergencyContactOfficePhone')
  String? emergencyContactOfficePhone;

  @JsonKey(name: 'EmmergencyContactMobilePhone')
  String? emergencyContactMobilePhone;

  @JsonKey(name: 'SportAndHobby')
  String? sportAndHobby;

  @JsonKey(name: 'SocialActivities')
  String? socialActivities;

  @JsonKey(name: 'DrivingLicenceStatus')
  int? drivingLicenceStatus;

  @JsonKey(name: 'DrivingLicenceType')
  int? drivingLicenceType;

  @JsonKey(name: 'DrivingLicenceColor')
  int? drivingLicenceColor;

  @JsonKey(name: 'VehiclePunishment')
  bool? vehiclePunishment;

  @JsonKey(name: 'VehiclePunishmentDescription')
  String? vehiclePunishmentDescription;

  @JsonKey(name: 'PreviousApplied')
  bool? previousApplied;

  @JsonKey(name: 'PreviousAppliedDescription')
  String? previousAppliedDescription;

  @JsonKey(name: 'HRDepartmentRecord')
  String? hRDepartmentRecord;

  PersonalInfoVo({this.id,
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

  factory PersonalInfoVo.fromJson(Map<String,dynamic> json) => _$PersonalInfoVoFromJson(json);

  Map<String,dynamic> toJson() => _$PersonalInfoVoToJson(this);
}