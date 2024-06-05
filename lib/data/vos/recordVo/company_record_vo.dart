import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/companies_vo.dart';
part 'company_record_vo.g.dart';

@JsonSerializable()
class CompanyRecordVo{

  @JsonKey(name: 'records')
  List<CompaniesVo>? records;

  @JsonKey(name: 'pageNumber')
  int? pageNumber;

  @JsonKey(name: 'pageSize')
  int? pageSize;

  CompanyRecordVo(this.records, this.pageNumber, this.pageSize);

  factory CompanyRecordVo.fromJson(Map<String,dynamic> json) => _$CompanyRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$CompanyRecordVoToJson(this);
}