
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pahg_group/state/employee_state/employee_state.dart';

import '../../data/models/pahg_model.dart';

class EmployeeNotifier extends Notifier<EmployeeState>{
  final PahgModel _model = PahgModel();

  @override
  EmployeeState build() {
    return EmployeeStateLoading();
  }

  void getEmployee(String token,String userId) async{
    state = EmployeeStateLoading();
    await Future.delayed(Duration(seconds: 3));
    _model.getEmployeeById(token, userId).then((response){
      if(response != null){
        state = EmployeeStateSuccess(response);
      }
      else{
        state = EmployeeStateFailed("Null");
      }
    }).catchError((error){
      state = EmployeeStateFailed(error.toString());
    });
  }
}