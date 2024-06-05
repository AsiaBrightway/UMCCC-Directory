import 'package:json_annotation/json_annotation.dart';
part 'image_vo.g.dart';

@JsonSerializable()
class ImageVo{

  @JsonKey(name:'file')
  String? file;

  ImageVo(this.file);

  factory ImageVo.fromJson(Map<String,dynamic> json) => _$ImageVoFromJson(json);

  Map<String,dynamic> toJson() => _$ImageVoToJson(this);
}