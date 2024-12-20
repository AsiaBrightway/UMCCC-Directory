import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import 'package:pahg_group/utils/utils.dart';
import '../data/models/pahg_model.dart';
import '../data/vos/discipline_vo.dart';

enum DisciplineState { initial, loading, success, error }
class DisciplineBloc extends ChangeNotifier{

  final PahgModel _model = PahgModel();
  DisciplineState _disciplineState = DisciplineState.initial;
  List<DisciplineVo>? _disciplineList;
  String? errorMessage;
  String _token = '';
  String _empId = '';
  DisciplineVo? disciplineForUpdate;
  String _currentUserId = '';
  String type = '';
  String? description;
  String? _date;
  String? status;
  String? actionTaken;

  DisciplineState get disciplineState => _disciplineState;
  List<DisciplineVo>? get disciplineList => _disciplineList;
  String? get date => _date;

  set date(String? value) {
    _date = value;
    notifyListeners();
  }

  set disciplineList(List<DisciplineVo>? value) {
    _disciplineList = value;
    notifyListeners();
  }

  DisciplineBloc(String token,String empId,String currentUserId,DisciplineVo? discipline){
    _empId = empId;
    _token = token;
    _currentUserId = currentUserId;
    getDisciplineListByEmployee();
    if(discipline != null){
      disciplineForUpdate = discipline;
      type = discipline.disciplineType ?? '';
      status = discipline.status;
      actionTaken = discipline.actionTakenBy;
      description = discipline.description;
      _date = discipline.disciplineDate;
    }
  }

  Future<void> getDisciplineListByEmployee() async{
    _disciplineState = DisciplineState.loading;
    notifyListeners();
    GetRequest request = GetRequest(columnName: "employee_id", columnCondition: 1, columnValue: _empId);
    _model.getDiscipline(_token, request).then((onValue){
      _disciplineList = onValue;
      _disciplineState = DisciplineState.success;
      notifyListeners();
    }).catchError((onError){
      errorMessage = onError.toString();
      _disciplineState = DisciplineState.error;
      notifyListeners();

    });
  }

  Future<void> addDiscipline(BuildContext context) async{
    DisciplineVo discipline = DisciplineVo(
        0,
        _empId,
        type,
        description,
        _date,
        actionTaken,
        status,
        _currentUserId,
        _currentUserId,
        Utils.getCurrentDateTime(),
        Utils.getCurrentDateTime()
    );
    if(type.isEmpty){
      showScaffoldMessage(context, 'Discipline Type cannot be empty');
    }else if(date == null){
      showScaffoldMessage(context, 'Date cannot be empty');
    }else{
      _model.addDiscipline(_token, discipline).then((onValue){

        showSuccessScaffold(context, onValue!.message.toString());
        Navigator.pop(context,true);
      }).catchError((onError){

        showScaffoldMessage(context, onError.toString());
      });
    }
  }

  Future<void> updateDiscipline(BuildContext context) async{
    DisciplineVo discipline = DisciplineVo(
        0,
        _empId,
        type,
        description,
        _date,
        actionTaken,
        status,
        disciplineForUpdate?.createdBy,
        _currentUserId,
        disciplineForUpdate?.createdAt,
        Utils.getCurrentDateTime()
    );
    if(type.isEmpty){
      showScaffoldMessage(context, 'Discipline Type cannot be empty');
    }else if(date == null){
      showScaffoldMessage(context, 'Date should cannot be empty');
    }else{
      _model.updateDiscipline(_token, disciplineForUpdate!.id ?? 0, discipline).then((onValue){

        showSuccessScaffold(context, onValue!.message.toString());
        Navigator.pop(context,true);
      }).catchError((onError){
        showScaffoldMessage(context, onError.toString());
      });
    }
  }

  Future<void> deleteDiscipline(BuildContext context, int id)async{
    _model.deleteDiscipline(_token, id).then((onValue){

      showSuccessScaffold(context, onValue!.message.toString());
      getDisciplineListByEmployee();
    }).catchError((onError){

      showScaffoldMessage(context, onError.toString());
    });
  }

}