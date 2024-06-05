import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/network/api_constants.dart';
part 'companies_vo.g.dart';

@JsonSerializable()
class CompaniesVo{

  @JsonKey(name:'Id')
  int? id;

  @JsonKey(name: 'CompanyName')
  String? companyName;

  @JsonKey(name: 'Address')
  String? address;

  @JsonKey(name: 'CompanyLogo')
  String? companyLogo;

  @JsonKey(name: 'PhoneNo')
  String? phoneNO;

  @JsonKey(name: 'About')
  String? about;

  @JsonKey(name: 'StartDate')
  String? startDate;

  @JsonKey(name: 'SortOrder')
  int? sortOrder;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  CompaniesVo(this.id, this.companyName, this.address, this.companyLogo,
      this.phoneNO, this.about, this.startDate, this.sortOrder, this.isActive);

  factory CompaniesVo.fromJson(Map<String,dynamic> json) => _$CompaniesVoFromJson(json);

  Map<String,dynamic> toJson() => _$CompaniesVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (companyLogo ?? "");
  }
}