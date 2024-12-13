import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:pahg_group/data/vos/facility_assign_vo.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import '../data/models/pahg_model.dart';

enum FacilityState { initial, loading, success, error }

class FacilityAssignBloc extends ChangeNotifier{

  String _token = '';
  String _employeeId = '';
  List<FacilityAssignVo>? _facilityAssignList;
  List<FacilityAssignVo>? _returnList;
  List<FacilityAssignVo>? _pendingList;
  final PahgModel _model = PahgModel();
  FacilityState _facilityState = FacilityState.initial;

  List<FacilityAssignVo>? get pendingList => _pendingList;
  List<FacilityAssignVo>? get returnList => _returnList;
  List<FacilityAssignVo>? get facilityAssignList => _facilityAssignList;
  FacilityState get facilityState => _facilityState;

  FacilityAssignBloc(String token,String employeeId){
    _token = token;
    _employeeId = employeeId;
    getFacilityByEmployeeId();
  }

  Future<void> getFacilityByEmployeeId() async{
    GetRequest request = GetRequest(columnName: "employee_id", columnCondition: 1, columnValue: _employeeId);
    _model.getFacilityAssignByEmployee(_token, request).then((onValue){
      _facilityAssignList = onValue.where((value) => value.status == null && value.status != 'pending').toList();
      _returnList = onValue.where((value) => value.status == 'true').toList();
      _pendingList = onValue.where((value) => value.returnStatus == 'pending').toList();
      notifyListeners();
    }).catchError((onError){

    });
  }

}