import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/nrc_township_vo.dart';
import 'package:pahg_group/data/vos/personal_info_vo.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/data/vos/request_body/path_user_request.dart';
import 'package:pahg_group/data/vos/request_body/personal_info_request.dart';
import 'package:pahg_group/utils/helper_functions.dart';

enum PersonalInfoState { initial, loading, success, error }

class PersonalInfoBloc extends ChangeNotifier{

  final PahgModel _pahgModel = PahgModel();
  PersonalInfoVo _personalInfo = PersonalInfoVo();
  PersonalInfoState _personalInfoState = PersonalInfoState.initial;
  PersonalInfoState _updateState = PersonalInfoState.initial;
  String? _nrcNo;
  String? _nrcNumber;
  String? _errorMessage;
  bool _isDataEmpty = false;
  String? _updateSuccess;
  bool _editMode = false;
  bool _isNrcExpanded = false;
  bool _isAppearanceExpanded = false;
  bool _isDrivingLicenseExpanded = false;
  bool _isEmergencyExpanded = false;
  String _token = "";
  String _employeeId = "";
  int? _selectedState;
  String? _selectedTownship;
  String? _selectedNationalType;
  List<NrcTownshipVo>? townshipList;

  String? get nrcNo => _nrcNo;
  String? get selectedNationalType => _selectedNationalType;

  set selectedNationalType(String? value) {
    _selectedNationalType = value;
    notifyListeners();
  }

  set setNrcNo(String? value) {
    _nrcNo = value;
  }

  String? get nrcNumber => _nrcNumber;
  int? get selectedState => _selectedState;
  String? get selectedTownship => _selectedTownship;
  bool get isAppearanceExpanded => _isAppearanceExpanded;
  bool get isDrivingLicenseExpanded => _isDrivingLicenseExpanded;
  bool get isEmergencyExpanded => _isEmergencyExpanded;
  bool get isNrcExpanded => _isNrcExpanded;
  bool get editMode => _editMode;
  String? get updateSuccess => _updateSuccess;
  PersonalInfoState get updateState => _updateState;
  PersonalInfoVo get personalInfo => _personalInfo;
  PersonalInfoState get personalInfoState => _personalInfoState;
  String? get errorMessage => _errorMessage;
  bool get isDataEmpty => _isDataEmpty;

  PersonalInfoBloc(String token,String columnValue){
    getPersonalInformation(token, columnValue);
    _token = token;
    _employeeId = columnValue;
  }

  ///fetch personal info
  Future<void> getPersonalInformation(String token,String columnValue) async{
    _personalInfoState = PersonalInfoState.loading;
    notifyListeners();
    _pahgModel.getPersonalInfo(token,"EmployeeId", columnValue).then((onValue){
      if(onValue.isEmpty){
       _isDataEmpty = true;
      }else{
        _personalInfo = onValue.first;
        _nrcNumber = _personalInfo.nrcNumber;
        _isDataEmpty = false;
      }
      _personalInfoState = PersonalInfoState.success;
      notifyListeners();
    }).catchError((onError){
      _errorMessage = onError.toString();
      _personalInfoState = PersonalInfoState.error;
      notifyListeners();
    });
  }

  Future<void> addPersonalInformation(String token,String userId,BuildContext context) async{
    _updateState = PersonalInfoState.loading;
    notifyListeners();
    PersonalInfoRequest request = getPersonalRequest();
    request.employeeId = userId;
    request.id = 0;
    _pahgModel.addPersonalInfo(token, request).then((onValue){
      _updateSuccess = onValue?.message;
      _updateState = PersonalInfoState.success;
      _isDataEmpty = false;
      getPersonalInformation(_token, _employeeId);
      showSuccessScaffold(context, onValue?.message ?? '');
      notifyListeners();
    }).catchError((onError){
      _errorMessage = onError.toString();
      _updateState = PersonalInfoState.error;
      showScaffoldMessage(context, onError.toString());
      notifyListeners();
    });
  }

  Future<void> updatePersonalInformation(String token,BuildContext context) async{
    _updateState = PersonalInfoState.loading;
    notifyListeners();
    PersonalInfoRequest request = getPersonalRequest();
    _pahgModel.updatePersonalInfo(token, _personalInfo.id!,request).then((onValue){
      _updateSuccess = onValue?.message;
      _updateState = PersonalInfoState.success;
      _nrcNumber = "$selectedState/$selectedTownship/($selectedNationalType) $_nrcNo";
      showSuccessScaffold(context, onValue?.message ?? '');
      notifyListeners();
    }).catchError((onError){
      _errorMessage = onError.toString();
      _updateState = PersonalInfoState.error;
      showScaffoldMessage(context, onError.toString());
      notifyListeners();
    });
  }

  ///get township
  Future<void> getTownship(int distinctId) async{
    GetRequest request = GetRequest(columnName: "StateDistrictNo", columnCondition: 1, columnValue: distinctId.toString());
    _pahgModel.getTownship(_token, request).then((response){
      townshipList = [];
      townshipList = response;
      notifyListeners();
    }).catchError((onError){

    });
  }

  ///context was used only in the function
  Future<void> uploadImage(BuildContext context,int imageType,File image) async{
    if(_personalInfo.id == null) {
      showScaffoldMessage(context, "Personal Info is empty");
      return;
    }
    _pahgModel.uploadImage(_token, image).then((onValue){
      switch(imageType){
        case 1 :
          patchImageUrl("DrivingLicenseFrontUrl", "replace", onValue?.file ?? 'null');
          break;
        case 2 :
          patchImageUrl("DrivingLicenseBackUrl", "replace", onValue?.file ?? 'null');
          break;
        case 3 :
          patchImageUrl("NRCFrontUrl", "replace", onValue?.file ?? 'null');
          break;
        case 4 :
          patchImageUrl("NRCBackUrl", "replace", onValue?.file ?? 'null');
          break;
      }
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }
  
  Future<void> patchImageUrl(String path,String op,String value) async{
    PathUserRequest request = PathUserRequest(path, op, value);
    _pahgModel.patchPersonalInfo(_token,_personalInfo.id!, request).then((onValue){
      _errorMessage = onValue?.message.toString();
      switch(path){
        case "DrivingLicenseFrontUrl":
          _personalInfo.drivingLicenseFrontUrl = value;
          break;
        case "DrivingLicenseBackUrl":
          _personalInfo.drivingLicenseBackUrl = value;
        case "NRCFrontUrl":
          _personalInfo.nrcFrontUrl = value;
        case "NRCBackUrl":
          _personalInfo.nrcBackUrl = value;
      }
      notifyListeners();
    }).catchError((onError){
      _errorMessage = onError.toString();
      notifyListeners();
    });
  }
  
  void toggleEditMode(){
    _editMode = !_editMode;
    _updateState = PersonalInfoState.initial;
    notifyListeners();
  }

  void toggleNrcExpanded(){
    _isNrcExpanded = !_isNrcExpanded;
    notifyListeners();
  }

  void toggleAppearanceExpanded(){
    _isAppearanceExpanded = !_isAppearanceExpanded;
    notifyListeners();
  }

  void toggleDrivingExpanded(){
    _isDrivingLicenseExpanded = !_isDrivingLicenseExpanded;
    notifyListeners();
  }

  void toggleEmergencyExpanded(){
    _isEmergencyExpanded = !_isEmergencyExpanded;
    notifyListeners();
  }

  void updatePersonalInfo({
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
    _personalInfo = _personalInfo.copyWith(
      id: id,
      address: address,
      employeeId: employeeId,
      gender: gender,
      telNoOffice: telNoOffice,
      telNoHome: telNoHome,
      dateOfBirth: dateOfBirth,
      age: age,
      placeOfBirth: placeOfBirth,
      nationality: nationality,
      religion: religion,
      race: race,
      health: health,
      bloodType: bloodType,
      handUsage: handUsage,
      hairColor: hairColor,
      eyeColor: eyeColor,
      skinColor: skinColor,
      marriageStatus: marriageStatus,
      emergencyContactName: emergencyContactName,
      emergencyContactRelation: emergencyContactRelation,
      emergencyContactAddress: emergencyContactAddress,
      emergencyContactHomePhone: emergencyContactHomePhone,
      emergencyContactMobilePhone: emergencyContactMobilePhone,
      emergencyContactOfficePhone: emergencyContactOfficePhone,
      sportAndHobby: sportAndHobby,
      socialActivities: socialActivities,
      drivingLicenceColor: drivingLicenceColor,
      drivingLicenceStatus: drivingLicenceStatus,
      drivingLicenceType: drivingLicenceType,
      drivingLicenseFrontUrl: drivingLicenseFrontUrl,
      drivingLicenseBackUrl: drivingLicenseBackUrl,
      vehiclePunishment: vehiclePunishment,
      vehiclePunishmentDescription: vehiclePunishmentDescription,
      nrcFrontUrl: nrcFrontUrl,
      nrcBackUrl: nrcBackUrl,
      previousApplied: previousApplied,
      previousAppliedDescription: previousAppliedDescription,
      hRDepartmentRecord: hRDepartmentRecord,
      nrcNumber: nrcNumber,
      email: email
    );
    notifyListeners();
  }

  PersonalInfoRequest getPersonalRequest(){
    String nrcNumber = "$selectedState/$selectedTownship/($selectedNationalType) $_nrcNo";
    return PersonalInfoRequest(
        id: _personalInfo.id,
        address: _personalInfo.address,
        employeeId: _personalInfo.employeeId,
        gender: _personalInfo.gender,
        telNoOffice: _personalInfo.telNoOffice,
        telNoHome: _personalInfo.telNoHome,
        dateOfBirth: _personalInfo.dateOfBirth,
        age: _personalInfo.age,
        placeOfBirth: _personalInfo.placeOfBirth,
        nationality: _personalInfo.nationality,
        religion: _personalInfo.religion,
        race: _personalInfo.race,
        health: _personalInfo.health,
        bloodType: _personalInfo.bloodType,
        handUsage: _personalInfo.handUsage,
        hairColor: _personalInfo.hairColor,
        eyeColor: _personalInfo.eyeColor,
        skinColor: _personalInfo.skinColor,
        marriageStatus: _personalInfo.marriageStatus,
        emergencyContactName: _personalInfo.emergencyContactName,
        emergencyContactRelation: _personalInfo.emergencyContactRelation,
        emergencyContactAddress: _personalInfo.emergencyContactAddress,
        emergencyContactHomePhone: _personalInfo.emergencyContactHomePhone,
        emergencyContactMobilePhone: _personalInfo.emergencyContactMobilePhone,
        emergencyContactOfficePhone: _personalInfo.emergencyContactOfficePhone,
        sportAndHobby: _personalInfo.sportAndHobby,
        socialActivities: _personalInfo.socialActivities,
        drivingLicenceColor: _personalInfo.drivingLicenceColor,
        drivingLicenceStatus: _personalInfo.drivingLicenceStatus,
        drivingLicenceType: _personalInfo.drivingLicenceType,
        drivingLicenseFrontUrl: _personalInfo.drivingLicenseFrontUrl,
        drivingLicenseBackUrl: _personalInfo.drivingLicenseBackUrl,
        vehiclePunishment: _personalInfo.vehiclePunishment,
        vehiclePunishmentDescription: _personalInfo.vehiclePunishmentDescription,
        nrcFrontUrl: _personalInfo.nrcFrontUrl,
        nrcBackUrl: _personalInfo.nrcBackUrl,
        previousApplied: _personalInfo.previousApplied,
        previousAppliedDescription: _personalInfo.previousAppliedDescription,
        hRDepartmentRecord: _personalInfo.hRDepartmentRecord,
        nrcNumber: nrcNumber,
        email: _personalInfo.email
    );
  }

  set selectedState(int? value) {
    _selectedState = value;
    _selectedTownship = null;
    getTownship(value!);
    notifyListeners();
  }

  set selectedTownship(String? value) {
    _selectedTownship = value;
    notifyListeners();
  }

}