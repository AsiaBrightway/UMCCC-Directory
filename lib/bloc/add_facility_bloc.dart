import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/facility_vo.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import '../data/models/pahg_model.dart';
import '../utils/utils.dart';

class AddFacilityBloc extends ChangeNotifier{

  final PahgModel _model = PahgModel();
  String _token = '';
  String _createdUserId = '';
  String _userId = '';
  String? _facilityName;
  String? _description;
  String _status = 'valid';
  bool? _statusCondition;
  bool isLoading = false;
  int? _selectedId;
  List<FacilityVo>? _facilityList;

  bool? get statusCondition => _statusCondition;
  int? get selectedId => _selectedId;
  String? get description => _description;
  List<FacilityVo>? get facilityList => _facilityList;
  String? get facilityName => _facilityName;

  set statusCondition(bool? value) {
    _statusCondition = value;
    if(statusCondition == true) {
      _status = "valid";
    }else{
      _status = "invalid";
    }
    notifyListeners();
  }

  set setFacilityName(String? value) {
    _facilityName = value;
  }

  set description(String? value) {
    _description = value;
  }

  void setSelectedId(int value) {
    _selectedId = value;
    _createdUserId = _facilityList!.firstWhere((facility) => facility.id == value).createdBy ?? '';
    _facilityName = _facilityList!.firstWhere((facility) => facility.id == value).facilityName;
    _description = _facilityList!.firstWhere((facility) => facility.id == value).description;
    _status = _facilityList!.firstWhere((facility) => facility.id == value).status!;
    if(_status == "valid"){
      _statusCondition = true;
    }else{
      _statusCondition = false;
    }
    notifyListeners();
  }

  AddFacilityBloc(String token,String userId){
    _token = token;
    _userId = userId;
    getAllFacility();
  }

  Future<void> addFacility(BuildContext context) async{
    if(_facilityName == null || _facilityName!.isEmpty){
      showScaffoldMessage(context, 'Facility Name cannot be empty');
    }
    else{
      isLoading = true;
      notifyListeners();
      FacilityVo facility = FacilityVo(0, _facilityName, _description, _status, _userId, _userId, Utils.getCurrentDateTime(), Utils.getCurrentDateTime());
      _model.addFacility(_token, facility).then((onValue){
        isLoading = false;
        showSuccessScaffold(context, onValue?.message.toString() ?? '');
        notifyListeners();
      }).catchError((onError){
        isLoading = false;
        showScaffoldMessage(context, onError.toString());
        notifyListeners();
      });
    }
  }

  Future<void> updateFacility(BuildContext context) async{
    FacilityVo updateFacility = FacilityVo(_selectedId, _facilityName, _description, _status, _createdUserId, _userId, Utils.getCurrentDateTime(), Utils.getCurrentDateTime());
    if(_selectedId == null){
      showScaffoldMessage(context, "Please select item to edit");
    }else{
      isLoading = true;
      notifyListeners();
      _model.updateFacility(_token, _selectedId!, updateFacility).then((onValue){
        isLoading = false;
        showSuccessScaffold(context, onValue!.message.toString());
        getAllFacility();
        notifyListeners();
      }).catchError((onError){
        isLoading = false;
        showScaffoldMessage(context, onError.toString());
        notifyListeners();
      });
    }
  }

  Future<void> getAllFacility() async{
    _model.getAllFacility(_token).then((onValue){
      _facilityList = onValue;
      notifyListeners();
    }).catchError((onError){

    });
  }
}