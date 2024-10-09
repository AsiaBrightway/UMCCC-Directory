
import 'package:json_annotation/json_annotation.dart';
import '../post_vo.dart';
part 'post_record_vo.g.dart';

@JsonSerializable()
class PostRecordVo{
  @JsonKey(name: 'records')
  List<PostVo>? records;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  PostRecordVo(this.records, this.totalRecords);

  factory PostRecordVo.fromJson(Map<String,dynamic> json) => _$PostRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$PostRecordVoToJson(this);
}