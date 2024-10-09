
import 'package:json_annotation/json_annotation.dart';
part 'add_category_vo.g.dart';

@JsonSerializable()
class AddCategoryVo{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'category')
  String? category;

  @JsonKey(name: 'parentId')
  int? parentId;

  @JsonKey(name: 'isActive')
  bool? isActive;

  @JsonKey(name: 'modifiedBy')
  String? modifyBy;

  @JsonKey(name: 'modifiedDate')
  String? modifiedDate;

  AddCategoryVo(this.id, this.category, this.parentId, this.isActive,
      this.modifyBy, this.modifiedDate);

  factory AddCategoryVo.fromJson(Map<String,dynamic> json) => _$AddCategoryVoFromJson(json);

  Map<String,dynamic> toJson() => _$AddCategoryVoToJson(this);
}