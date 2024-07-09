import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/companies_vo.dart';
part 'company_by_id_response.g.dart';

@JsonSerializable()
class CompanyByIdResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  CompaniesVo? document;

  CompanyByIdResponse(this.code, this.message, this.document);

  factory CompanyByIdResponse.fromJson(Map<String,dynamic> json) => _$CompanyByIdResponseFromJson(json);

  Map<String,dynamic> toJson() => _$CompanyByIdResponseToJson(this);
}