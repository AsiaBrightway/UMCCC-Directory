import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/company_record_vo.dart';
part 'company_list_response.g.dart';

@JsonSerializable()
class CompanyListResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  CompanyRecordVo? document;

  CompanyListResponse(this.code, this.message, this.document);

  factory CompanyListResponse.fromJson(Map<String,dynamic> json) => _$CompanyListResponseFromJson(json);

  Map<String,dynamic> toJson() => _$CompanyListResponseToJson(this);
}
