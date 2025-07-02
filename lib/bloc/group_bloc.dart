
import 'package:flutter/cupertino.dart';

import '../data/models/pahg_model.dart';
import '../data/vos/companies_vo.dart';
import 'home_bloc.dart';

class GroupBloc extends ChangeNotifier{

  String _token = "";
  final PahgModel _model = PahgModel();
  List<CompaniesVo> _companyList = [];
  HomeState _homeState = HomeState.initial;


  HomeState get homeState => _homeState;
  List<CompaniesVo> get companyList => _companyList;

  set companyList(List<CompaniesVo> value) {
    _companyList = value;
  }

  GroupBloc(String token){
    _token = token;
    getCompanyList();
  }

  Future<void> getCompanyList() async{
    _homeState = HomeState.loading;
    notifyListeners();
    _model.getCompanies(_token).then((companies) {
      _companyList = companies;
      _homeState = HomeState.success;
      notifyListeners();
    }).catchError((error){
      ///exception can found without toString()
      _homeState = HomeState.error;
      notifyListeners();
    });
  }
}