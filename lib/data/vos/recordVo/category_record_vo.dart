
import 'package:json_annotation/json_annotation.dart';

import '../category_vo.dart';
part 'category_record_vo.g.dart';

@JsonSerializable()
class CategoryRecordVo{
  @JsonKey(name: 'records')
  List<CategoryVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  CategoryRecordVo(this.records, this.totalRecords);

  factory CategoryRecordVo.fromJson(Map<String,dynamic> json) => _$CategoryRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$CategoryRecordVoToJson(this);
}