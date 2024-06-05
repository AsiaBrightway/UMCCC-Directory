import 'package:json_annotation/json_annotation.dart';

import '../company_images_vo.dart';
part 'company_images_record_vo.g.dart';

@JsonSerializable()
class CompanyImagesRecordVo{

  @JsonKey(name: 'records')
  List<CompanyImagesVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  CompanyImagesRecordVo(this.records, this.totalRecords);

  factory CompanyImagesRecordVo.fromJson(Map<String,dynamic> json) => _$CompanyImagesRecordVoFromJson(json);
  
  Map<String,dynamic> toJson() => _$CompanyImagesRecordVoToJson(this);
}