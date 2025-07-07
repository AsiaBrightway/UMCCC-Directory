import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import '../data/models/pahg_model.dart';
import '../data/vos/data_class_for_search_bloc.dart';
import '../data/vos/employee_vo.dart';

class SearchEmployeeBloc{

  final PahgModel _model = PahgModel();

  ///Stream Controllers
  StreamController<DataClassForSearchBloc> queryStreamController = StreamController();
  StreamController<List<EmployeeVo>> employeeStreamController = StreamController();

  BuildContext context;

  SearchEmployeeBloc(this.context){
    queryStreamController.stream.debounceTime(const Duration(milliseconds: 500)).listen((query){
      final q = query.searchName.trim();
      if (q.isEmpty) return;

      String lang;
      if (_containsChinese(q)) {
        lang = 'zh';
      } else if (_containsBurmese(q)) {
        lang = 'mm';
      } else {
        lang = 'en';
      }
      final enriched = DataClassForSearchBloc(
        query.token,
        query.searchType,
        query.companyId,
        query.searchName,
        lang: lang,
        entity: query.entity,
      );

      if(query.searchName.isNotEmpty){
        if(query.searchType == 1){
          _makeEmployeeSearchNetworkCall(enriched);
        }else{
          _makeEmployeeSearchByCompany(enriched);
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
    _model.searchEmployeeResult(query.token, 50, query.searchName).then((onValue){
      employeeStreamController.sink.add(onValue);
    }).catchError((onError){
      employeeStreamController.addError(onError);
    });
  }

  void onDispose(){
    queryStreamController.close();
    employeeStreamController.close();
  }

  bool _containsChinese(String input) {
    return input.runes.any((r) => (r >= 0x4E00 && r <= 0x9FFF));
  }

  bool _containsBurmese(String input) {
    return input.runes.any((r) => (r >= 0x1000 && r <= 0x109F));
  }
}