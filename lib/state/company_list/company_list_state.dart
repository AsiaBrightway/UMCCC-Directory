
import 'package:pahg_group/data/vos/companies_vo.dart';

sealed class CompanyListState{}

class CompanyListLoading extends CompanyListState{}

class CompanyListSuccess extends CompanyListState{
  final List<CompaniesVo> companies;

  CompanyListSuccess(this.companies);
}

class CompanyListFailed extends CompanyListState{
  final String error;

  CompanyListFailed(this.error);
}

class WidgetForEmployee extends CompanyListState{}