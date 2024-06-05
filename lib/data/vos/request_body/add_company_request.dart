import 'package:json_annotation/json_annotation.dart';
part 'add_company_request.g.dart';

@JsonSerializable()
class AddCompanyRequest{

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'companyName')
  String? companyName;

  @JsonKey(name: 'address')
  String? address;

  @JsonKey(name: 'phoneNo')
  String? phoneNo;

  @JsonKey(name: 'about')
  String? about;

  @JsonKey(name: 'companyLogo')
  String? companyLogo;

  @JsonKey(name: 'startDate')
  String? startDate;

  @JsonKey(name: 'sortOrder')
  int? sortOrder;

  @JsonKey(name: 'isActive')
  bool? isActive;

  AddCompanyRequest(
      this.id,
      this.companyName,
      this.address,
      this.phoneNo,
      this.about,
      this.companyLogo,
      this.startDate,
      this.sortOrder,
      this.isActive);

  factory AddCompanyRequest.fromJson(Map<String,dynamic> json) => _$AddCompanyRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddCompanyRequestToJson(this);
}