
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/data_class_for_search_bloc.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import 'package:rxdart/rxdart.dart';


class SearchEmployeeBloc{

  final PahgModel _model = PahgModel();

  ///Stream Controllers
  StreamController<DataClassForSearchBloc> queryStreamController = StreamController();
  StreamController<List<EmployeeVo>> employeeStreamController = StreamController();

  BuildContext context;

  SearchEmployeeBloc(this.context){
    queryStreamController.stream.debounceTime(const Duration(milliseconds: 500)).listen((query){
      if(query.searchName.isNotEmpty){
        if(query.searchType == 1){
          _makeEmployeeSearchNetworkCall(query);
        }else{
          _makeEmployeeSearchByCompany(query);
        }
      }
    });
  }

  void _makeEmployeeSearchByCompany(DataClassForSearchBloc query){
    _model.searchEmployeeByCompany(query.token, query.searchName, query.companyId.toString()).then((onValue){
      employeeStreamController.sink.add(onValue);
    }).catchError((onError){
      employeeStreamController.addError(onError);
    });
  }

  void _makeEmployeeSearchNetworkCall(DataClassForSearchBloc query){
    _model.searchEmployeeResult(query.token, query.searchName).then((onValue){
      employeeStreamController.sink.add(onValue);
    }).catchError((onError){
      employeeStreamController.addError(onError);
    });
  }

  void onDispose(){
    queryStreamController.close();
    employeeStreamController.close();
  }
}