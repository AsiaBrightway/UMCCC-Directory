
import 'package:pahg_group/data/vos/employee_vo.dart';

sealed class EmployeeState{}


class EmployeeStateLoading extends EmployeeState{}

class EmployeeStateSuccess extends EmployeeState{
  final EmployeeVo employee;

  EmployeeStateSuccess(this.employee);
}

class EmployeeStateFailed extends EmployeeState{
  final String error;

  EmployeeStateFailed(this.error);
}