
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import '../data/models/pahg_model.dart';
import '../data/vos/request_body/path_user_request.dart';

enum EmployeeState{initial,loading,success,error}

class EmployeeNotifier extends ChangeNotifier{
  final PahgModel _model = PahgModel();
  EmployeeState _state = EmployeeState.initial;
  EmployeeVo? employee;
  bool isUploading = false;
  EmployeeState get state => _state;
  String _token = '';
  String _userId = '';

  set state(EmployeeState value) {
    _state = value;
    notifyListeners();
  }

  EmployeeNotifier(String token, String userId) {
    _token = token;
    _userId = userId;
    getEmployee();
  }

  void getEmployee() async{
    _state = EmployeeState.loading;
    notifyListeners();
    _model.getEmployeeById(_token,_userId).then((response){
      if(response != null){
        employee = response;
        _state = EmployeeState.success;
        notifyListeners();
      }
      else{
        _state = EmployeeState.error;
        notifyListeners();
      }
    }).catchError((error){
      _state = EmployeeState.error;
      notifyListeners();
    });
  }

  void uploadProfile(File image) async {

    isUploading = true;
    notifyListeners();
    _model.uploadImage(_token, image).then((uploadResponse) {
      PathUserRequest request = PathUserRequest('image_Url', 'replace', uploadResponse?.file);
      _model.patchProfileImage(_token, _userId, request).then((onValue){
        isUploading = false;
        notifyListeners();
      }).catchError((onError){
        isUploading = false;
        notifyListeners();
      });
      getEmployee();
      notifyListeners();
    }).catchError((error) {
      isUploading = false;
      notifyListeners();
    });
  }
}