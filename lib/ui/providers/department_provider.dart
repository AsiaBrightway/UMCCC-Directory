import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/department_vo.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';

class DepartmentProvider extends ChangeNotifier {
  final PahgModel _model = PahgModel();
  List<DepartmentVo> _departments = [];
  List<DepartmentVo> get departments => _departments;

  Future<void> getDepartmentList(String token, int companyId) async {
    var request = GetRequest(columnName: 'CompanyId', columnCondition: 1, columnValue: companyId.toString());
    try {
      _departments = await _model.getDepartmentListByCompany(token, request);
      notifyListeners();
    } catch (error) {
      rethrow; // Handle error as needed
    }
  }
}