
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/state/company_list/company_list_state.dart';

class CompanyListNotifier extends Notifier<CompanyListState>{

  final PahgModel _model = PahgModel();

  @override
  CompanyListState build() {
    return CompanyListLoading();
  }

}