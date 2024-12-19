import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/facility_assign_vo.dart';
import 'package:pahg_group/data/vos/facility_vo.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import 'package:pahg_group/utils/utils.dart';
import '../data/models/pahg_model.dart';

enum FacilityState { initial, loading, success, error }

class FacilityAssignBloc extends ChangeNotifier{

  String? _returnStatus;
  String? _returnReason;
  String? _assignStatus;
  String? _assignedDate;
  String? _returnedDate;
  String _token = '';
  String _employeeId = '';
  String _currentUserId = '';
  FacilityVo? _selectedItem;
  FacilityAssignVo? assignVoForUpdate;
  List<FacilityVo>? _itemList;
  List<FacilityAssignVo>? _facilityAssignList;
  List<FacilityAssignVo>? _returnList;
  List<FacilityAssignVo>? _pendingList;
  String errorMessage = '';
  FacilityState _facilityState = FacilityState.initial;
  final PahgModel _model = PahgModel();

  String? get returnedDate => _returnedDate;
  String? get returnStatus => _returnStatus;
  String? get returnReason => _returnReason;
  String? get assignStatus => _assignStatus;
  String? get assignedDate => _assignedDate;
  FacilityVo? get selectedItem => _selectedItem;
  List<FacilityVo>? get itemList => _itemList;
  List<FacilityAssignVo>? get pendingList => _pendingList;
  List<FacilityAssignVo>? get returnList => _returnList;
  List<FacilityAssignVo>? get facilityAssignList => _facilityAssignList;
  FacilityState get facilityState => _facilityState;

  FacilityAssignBloc(String token,String employeeId,String currentUserId,bool isAddPage,FacilityAssignVo? assignVo){
    _token = token;
    _employeeId = employeeId;
    _currentUserId = currentUserId;
    getFacilityByEmployeeId();
    if(assignVo!=null){
      _assignedDate = assignVo.assignedDate;
      assignVoForUpdate = assignVo;
      _assignStatus = assignVo.status;
      _returnedDate = assignVo.returnedDate;
      _returnStatus = assignVo.returnStatus;
    }
    if(isAddPage) {
      _assignedDate = Utils.getCurrentDateTime();
      getAllActiveFacility();
    }
  }

  set selectedItem(FacilityVo? value) {
    _selectedItem = value;
    notifyListeners();
  }

  set returnStatus(String? value) {
    _returnStatus = value;
    notifyListeners();
  }

  set returnReason(String? value) {
    _returnReason = value;
    notifyListeners();
  }

  set returnedDate(String? value) {
    _returnedDate = value;
    notifyListeners();
  }

  set assignedDate(String? value) {
    _assignedDate = value;
    notifyListeners();
  }

  Future<void> getFacilityByEmployeeId() async{
    _facilityState = FacilityState.loading;
    notifyListeners();
    GetRequest request = GetRequest(columnName: "employee_id", columnCondition: 1, columnValue: _employeeId);
    _model.getFacilityAssignByEmployee(_token, request).then((onValue){
      _facilityAssignList = onValue.where((value) => value.returnStatus == null).toList();
      _returnList = onValue.where((value) => value.returnStatus == 'true').toList();
      _pendingList = onValue.where((value) => value.returnStatus == 'false').toList();
      _facilityState = FacilityState.success;
      notifyListeners();
    }).catchError((onError){

      _facilityState = FacilityState.error;
      errorMessage = onError.toString();
      notifyListeners();
    });
  }

  Future<void> getAllActiveFacility() async{
    _model.getAllFacility(_token).then((onValue){
      _itemList = onValue?.where((value) => value.status == 'valid').toList();
      notifyListeners();
    }).catchError((onError){

    });
  }

  Future<void> addFacilityAssign(BuildContext context) async{
    FacilityAssignVo assignVo = FacilityAssignVo(
        0,
        selectedItem?.id,
        _employeeId,
        _assignedDate,
        'approved',
        null,
        null,
        null,
        _currentUserId,
        _currentUserId,
        Utils.getCurrentDateTime(),
        Utils.getCurrentDateTime(),
        '',
        '',
        '');
    if(selectedItem == null){
      showScaffoldMessage(context, 'Please select a facility');
    }else if(_assignedDate == null){
      showScaffoldMessage(context, 'Assigned date cannot be empty');
    }else{
      _model.addFacilityAssign(_token, assignVo).then((onValue){
        showSuccessScaffold(context, onValue!.message.toString());
        Navigator.pop(context,true);
      }).catchError((onError){
        showScaffoldMessage(context, onError.toString());
      });
    }
  }

  Future<void> updateFacilityAssign(BuildContext context) async{
    FacilityAssignVo assignVo = FacilityAssignVo(
        assignVoForUpdate!.id,
        assignVoForUpdate!.facilityId,
        assignVoForUpdate!.employeeId,
        _assignedDate,
        _assignStatus,
        _returnStatus,
        _returnedDate,
        _returnReason,
        assignVoForUpdate!.createdBy,
        _currentUserId,
        assignVoForUpdate!.createdAt,
        Utils.getCurrentDateTime(),
        '',
        '',
        '');

    _model.updateFacilityAssign(_token, assignVoForUpdate!.id!, assignVo).then((onValue){
      showSuccessScaffold(context, onValue!.message.toString());
      Navigator.pop(context,true);
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

}