
import 'package:json_annotation/json_annotation.dart';
part 'add_post_request.g.dart';

@JsonSerializable()
class AddPostRequest{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'postName')
  String? postName;

  @JsonKey(name: 'postTitle')
  String? postTitle;

  @JsonKey(name: 'featureImageUrl')
  String? featureImage;

  @JsonKey(name: 'postContent')
  String? postContent;

  @JsonKey(name: 'categoryId')
  int? categoryId;

  @JsonKey(name: 'createdDate')
  String? createdDate;

  @JsonKey(name: 'isDeleted')
  bool? isDeleted;

  @JsonKey(name: 'showPostByCompany')
  String? showPostByCompany;

  @JsonKey(name: 'showPostByUserRoles')
  String? showPostByUserRole;

  @JsonKey(name: 'mofidiedBy')
  int? modifiedBy;

  @JsonKey(name: 'modifiedDate')
  String? modifiedDate;

  AddPostRequest(
      this.id,
      this.postName,
      this.postTitle,
      this.featureImage,
      this.postContent,
      this.categoryId,
      this.createdDate,
      this.isDeleted,
      this.showPostByCompany,
      this.showPostByUserRole,
      this.modifiedBy,
      this.modifiedDate);

  factory AddPostRequest.fromJson(Map<String,dynamic> json) => _$AddPostRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddPostRequestToJson(this);
}