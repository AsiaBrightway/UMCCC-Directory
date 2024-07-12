// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfoRequest _$PersonalInfoRequestFromJson(Map<String, dynamic> json) =>
    PersonalInfoRequest(
      id: (json['id'] as num?)?.toInt(),
      employeeId: json['employeeId'] as String?,
      gender: json['gender'] as bool?,
      address: json['address'] as String?,
      telNoOffice: json['telNoOffice'] as String?,
      telNoHome: json['telNoHome'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      age: (json['age'] as num?)?.toInt(),
      placeOfBirth: json['placeOfBirth'] as String?,
      nationality: json['nationality'] as String?,
      religion: json['religion'] as String?,
      race: json['race'] as String?,
      health: json['health'] as String?,
      bloodType: (json['bloodType'] as num?)?.toInt(),
      handUsage: (json['handUsage'] as num?)?.toInt(),
      hairColor: json['hairColor'] as String?,
      eyeColor: json['eyeColor'] as String?,
      skinColor: json['skinColor'] as String?,
      marriageStatus: (json['marriageStatus'] as num?)?.toInt(),
      emergencyContactName: json['emmergencyContactName'] as String?,
      emergencyContactRelation: json['emmergencyContactRelation'] as String?,
      emergencyContactAddress: json['emmergencyContactAddress'] as String?,
      emergencyContactHomePhone: json['emmergencyContactHomePhone'] as String?,
      emergencyContactOfficePhone:
          json['emmergencyContactOfficePhone'] as String?,
      emergencyContactMobilePhone:
          json['emmergencyContactMobilePhone'] as String?,
      sportAndHobby: json['sportAndHobby'] as String?,
      socialActivities: json['socialActivities'] as String?,
      drivingLicenceStatus: (json['drivingLicenceStatus'] as num?)?.toInt(),
      drivingLicenceType: (json['drivingLicenceType'] as num?)?.toInt(),
      drivingLicenceColor: (json['drivingLicenceColor'] as num?)?.toInt(),
      vehiclePunishment: json['vehiclePunishment'] as bool?,
      vehiclePunishmentDescription:
          json['vehiclePunishmentDescription'] as String?,
      previousApplied: json['previousApplied'] as bool?,
      previousAppliedDescription: json['previousAppliedDescription'] as String?,
      hRDepartmentRecord: json['hrDepartmentRecord'] as String?,
    );

Map<String, dynamic> _$PersonalInfoRequestToJson(
        PersonalInfoRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'gender': instance.gender,
      'address': instance.address,
      'telNoOffice': instance.telNoOffice,
      'telNoHome': instance.telNoHome,
      'dateOfBirth': instance.dateOfBirth,
      'age': instance.age,
      'placeOfBirth': instance.placeOfBirth,
      'nationality': instance.nationality,
      'religion': instance.religion,
      'race': instance.race,
      'health': instance.health,
      'bloodType': instance.bloodType,
      'handUsage': instance.handUsage,
      'hairColor': instance.hairColor,
      'eyeColor': instance.eyeColor,
      'skinColor': instance.skinColor,
      'marriageStatus': instance.marriageStatus,
      'emmergencyContactName': instance.emergencyContactName,
      'emmergencyContactRelation': instance.emergencyContactRelation,
      'emmergencyContactAddress': instance.emergencyContactAddress,
      'emmergencyContactHomePhone': instance.emergencyContactHomePhone,
      'emmergencyContactOfficePhone': instance.emergencyContactOfficePhone,
      'emmergencyContactMobilePhone': instance.emergencyContactMobilePhone,
      'sportAndHobby': instance.sportAndHobby,
      'socialActivities': instance.socialActivities,
      'drivingLicenceStatus': instance.drivingLicenceStatus,
      'drivingLicenceType': instance.drivingLicenceType,
      'drivingLicenceColor': instance.drivingLicenceColor,
      'vehiclePunishment': instance.vehiclePunishment,
      'vehiclePunishmentDescription': instance.vehiclePunishmentDescription,
      'previousApplied': instance.previousApplied,
      'previousAppliedDescription': instance.previousAppliedDescription,
      'hrDepartmentRecord': instance.hRDepartmentRecord,
    };
