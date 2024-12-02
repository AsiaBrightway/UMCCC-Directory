

import 'package:flutter/cupertino.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';

import '../data/vos/category_vo.dart';
import '../data/vos/companies_vo.dart';

enum HomeState { initial, loading, success, error }

class HomeBloc extends ChangeNotifier{

  List<CategoryVo> _categoryList = [];
  final PahgModel _model = PahgModel();
  HomeState _homeState = HomeState.initial;
  final String _companyError = "";
  List<CompaniesVo> _companyList = [];
  String _token = "";
  int _role = 4;

  List<CategoryVo> get categoryList => _categoryList;
  String get companyError => _companyError;
  HomeState get homeState => _homeState;
  List<CompaniesVo> get companyList => _companyList;

  HomeBloc(String token,int role,String userId){
    _token = token;
    _role = role;
    getCompanyList(userId);
    getCategory();
  }

  ///column 0 is root parent
  Future<void> getCategory() async{
    GetRequest request = GetRequest(columnName: "ParentId", columnCondition: 1, columnValue: "0");
    _model.getCategories(_token, request).then((onValue){
      //filter isActive is true
      _categoryList = onValue.where((category) => category.isActive == true).toList();
      notifyListeners();
    }).catchError((onError){
      ///do something
    });
  }

  Future<void> getCompanyList(String userId) async{
    _homeState = HomeState.loading;
    notifyListeners();
    if(_role == 3){
      _model.getEmployeeById(_token, userId).then((onValue){
        _model.getCompanyId(_token, onValue?.companyId ?? 0).then((company) {
          _companyList = [company];
          _homeState = HomeState.success;
          notifyListeners();
        }).catchError((onError) {
          _homeState = HomeState.error;
          notifyListeners();
        });
      }).catchError((error){
        _homeState = HomeState.error;
        notifyListeners();
      });
    }
    else if(_role == 2 || _role == 1){
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
    else{
      _homeState = HomeState.initial;
      notifyListeners();
    }
  }

}