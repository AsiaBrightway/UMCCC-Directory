
import 'package:flutter/cupertino.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/models/status.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';

import '../../data/vos/employee_vo.dart';

class EmployeeProvider extends ChangeNotifier{

  PahgModel mPahgModel = PahgModel();
  List<EmployeeVo> employees = [];
  DataStatus employeeDataStatus = DataStatus.idle;
  String errorMessage = '';

  Future<bool> getEmployees(String token,int page,List<GetRequest> request) async{
    employees.clear();
    employeeDataStatus = DataStatus.loading;
    notifyListeners();

    notifyListeners();
    return true;
  }
}