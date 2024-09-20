
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/state/company_list/company_list_state.dart';

class CompanyListNotifier extends Notifier<CompanyListState>{

  final PahgModel _model = PahgModel();

  @override
  CompanyListState build() {
    return CompanyListLoading();
  }

  void getCompanyList(int role,String token,String userId) async{
    state = CompanyListLoading();
    if(role == 3){
      _model.getEmployeeById(token, userId).then((onValue){
        _model.getCompanyId(token, onValue?.companyId ?? 0).then((company) {
          state = CompanyListSuccess([company]);
        }).catchError((onError) {
          state = CompanyListFailed(onError.toString());
        });
      }).catchError((error){
        state = CompanyListFailed(error.toString());
      });
    }
    else if(role == 2 || role == 1){
      _model.getCompanies(token).then((companies) {
        state = CompanyListSuccess(companies);
      }).catchError((error){
        ///exception can found without toString()
        state = CompanyListFailed(error.toString());
      });
    }
    else{
      state = WidgetForEmployee();
    }
  }
}