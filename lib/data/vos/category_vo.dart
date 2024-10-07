
import 'package:json_annotation/json_annotation.dart';
part 'category_vo.g.dart';

@JsonSerializable()
class CategoryVo{

  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'Category')
  String? category;

  @JsonKey(name: 'ParentId')
  int? parentId;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  @JsonKey(name: 'ModifiedBy')
  String? modifiedBy;

  @JsonKey(name: 'ModifiedDate')
  String? modifiedDate;

  CategoryVo(this.id, this.category, this.parentId, this.isActive,
      this.modifiedBy, this.modifiedDate);

  factory CategoryVo.fromJson(Map<String,dynamic> json) => _$CategoryVoFromJson(json);

  Map<String,dynamic> toJson() => _$CategoryVoToJson(this);
}