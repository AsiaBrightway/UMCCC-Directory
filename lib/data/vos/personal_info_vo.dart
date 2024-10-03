import 'package:json_annotation/json_annotation.dart';

import '../../network/api_constants.dart';

part 'personal_info_vo.g.dart';

@JsonSerializable()
class PersonalInfoVo {
  @JsonKey(name: 'Id')
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

  @JsonKey(name: 'NRCFrontUrl')
  String? nrcFrontUrl;

  @JsonKey(name: 'NRCBackUrl')
  String? nrcBackUrl;

  @JsonKey(name: 'DrivingLicenseFrontUrl')
  String? drivingLicenseFrontUrl;

  @JsonKey(name: 'DrivingLicenseBackUrl')
  String? drivingLicenseBackUrl;

  @JsonKey(name: 'PreviousApplied')
  bool? previousApplied;

  @JsonKey(name: 'PreviousAppliedDescription')
  String? previousAppliedDescription;

  @JsonKey(name: 'HRDepartmentRecord')
  String? hRDepartmentRecord;

  @JsonKey(name: 'NRCNumber')
  String? nrcNumber;

  @JsonKey(name: 'Email')
  String? email;

  PersonalInfoVo({
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
      this.nrcFrontUrl,
      this.nrcBackUrl,
      this.drivingLicenseFrontUrl,
      this.drivingLicenseBackUrl,
      this.previousApplied,
      this.previousAppliedDescription,
      this.hRDepartmentRecord,
      this.nrcNumber,
      this.email});

  factory PersonalInfoVo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoVoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInfoVoToJson(this);

  PersonalInfoVo copyWith({
    int? id,
    String? address,
    String? employeeId,
    bool? gender,
    String? telNoOffice,
    String? telNoHome,
    String? dateOfBirth,
    int? age,
    String? placeOfBirth,
    String? nationality,
    String? religion,
    String? race,
    String? health,
    int? bloodType,
    int? handUsage,
    String? hairColor,
    String? eyeColor,
    String? skinColor,
    int? marriageStatus,
    String? emergencyContactName,
    String? emergencyContactRelation,
    String? emergencyContactAddress,
    String? emergencyContactHomePhone,
    String? emergencyContactOfficePhone,
    String? emergencyContactMobilePhone,
    String? sportAndHobby,
    String? socialActivities,
    int? drivingLicenceStatus,
    int? drivingLicenceType,
    int? drivingLicenceColor,
    bool? vehiclePunishment,
    String? vehiclePunishmentDescription,
    String? nrcFrontUrl,
    String? nrcBackUrl,
    String? drivingLicenseFrontUrl,
    String? drivingLicenseBackUrl,
    bool? previousApplied,
    String? previousAppliedDescription,
    String? hRDepartmentRecord,
    String? nrcNumber,
    String? email
  }){
    return PersonalInfoVo(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        gender: gender ?? this.gender,
        address: address ?? this.address,
        telNoOffice: telNoOffice ?? this.telNoOffice,
        telNoHome: telNoHome ?? this.telNoHome,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        age: age ?? this.age,
        placeOfBirth: placeOfBirth ?? this.placeOfBirth,
        nationality: nationality ?? this.nationality,
        religion: religion ?? this.religion,
        race: race ?? this.race,
        health: health ?? this.health,
        bloodType: bloodType ?? this.bloodType,
        handUsage: handUsage ?? this.handUsage,
        hairColor: hairColor ?? this.hairColor,
        eyeColor: eyeColor ?? this.eyeColor,
        skinColor: skinColor ?? this.skinColor,
        marriageStatus: marriageStatus ?? this.marriageStatus,
        emergencyContactName: emergencyContactName ?? this.emergencyContactName,
        emergencyContactRelation: emergencyContactRelation ?? this.emergencyContactRelation,
        emergencyContactAddress: emergencyContactAddress ?? this.emergencyContactAddress,
        emergencyContactHomePhone: emergencyContactHomePhone ?? this.emergencyContactHomePhone,
        emergencyContactOfficePhone: emergencyContactOfficePhone ?? this.emergencyContactOfficePhone,
        emergencyContactMobilePhone: emergencyContactMobilePhone ?? this.emergencyContactMobilePhone,
        sportAndHobby: sportAndHobby ?? this.sportAndHobby,
        socialActivities: socialActivities ?? this.socialActivities,
        drivingLicenceStatus: drivingLicenceStatus ?? this.drivingLicenceStatus,
        drivingLicenceType: drivingLicenceType ?? this.drivingLicenceType,
        drivingLicenceColor: drivingLicenceColor ?? this.drivingLicenceColor,
        vehiclePunishment: vehiclePunishment ?? this.vehiclePunishment,
        vehiclePunishmentDescription: vehiclePunishmentDescription ?? this.vehiclePunishmentDescription,
        nrcFrontUrl: nrcFrontUrl ?? this.nrcFrontUrl,
        nrcBackUrl: nrcBackUrl ?? this.nrcBackUrl,
        drivingLicenseFrontUrl: drivingLicenseFrontUrl ?? this.drivingLicenseFrontUrl,
        drivingLicenseBackUrl: drivingLicenseBackUrl ?? this.drivingLicenseBackUrl,
        previousApplied: previousApplied ?? this.previousApplied,
        previousAppliedDescription: previousAppliedDescription ?? this.previousAppliedDescription,
        hRDepartmentRecord: hRDepartmentRecord ?? this.hRDepartmentRecord,
        nrcNumber: nrcNumber ?? this.nrcNumber,
        email: email ?? this.email);
  }

  String getImageWithBaseUrl(String imageUrl){
    return kBaseImageUrl + (imageUrl ?? "");
  }
}