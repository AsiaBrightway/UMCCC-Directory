
import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/recordVo/category_record_vo.dart';
part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse{
  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'document')
  CategoryRecordVo? document;

  CategoryResponse(this.code, this.message, this.document);

  factory CategoryResponse.fromJson(Map<String,dynamic> json) => _$CategoryResponseFromJson(json);

  Map<String,dynamic> toJson() => _$CategoryResponseToJson(this);
}