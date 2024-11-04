
import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
import '../../network/api_constants.dart';
part 'post_vo.g.dart';

@JsonSerializable()
class PostVo{
  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'PostName')
  String? postName;

  @JsonKey(name: 'PostTitle')
  String? postTitle;

  @JsonKey(name: 'FeatureImageUrl')
  String? featureImageUrl;

  @JsonKey(name: 'PostContent')
  String? postContent;

  @JsonKey(name: 'CategoryId')
  int? categoryId;

  @JsonKey(name: 'CreatedDate')
  String? createdDate;

  @JsonKey(name: 'IsDeleted')
  bool? isDeleted;

  @JsonKey(name: 'ShowPostByCompany')
  String? showPostByCompany;

  @JsonKey(name: 'ShowPostByUserRoles')
  String? showPostByUserRoles;

  @JsonKey(name: 'MofidiedBy')
  String? modifiedBy;

  @JsonKey(name: 'ModifiedDate')
  String? modifiedDate;

  PostVo(
      this.id,
      this.postName,
      this.postTitle,
      this.featureImageUrl,
      this.postContent,
      this.categoryId,
      this.createdDate,
      this.isDeleted,
      this.showPostByCompany,
      this.showPostByUserRoles,
      this.modifiedBy,
      this.modifiedDate);

  factory PostVo.fromJson(Map<String,dynamic> json) => _$PostVoFromJson(json);

  Map<String,dynamic> toJson() => _$PostVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (featureImageUrl ?? "");
  }
}