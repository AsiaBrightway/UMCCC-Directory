import 'package:json_annotation/json_annotation.dart';
part 'position_vo.g.dart';

@JsonSerializable()
class PositionVo{

  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'DepartmentId')
  int? deptId;

  @JsonKey(name: 'Position')
  String? position;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  PositionVo(this.id, this.deptId, this.position, this.isActive);

  factory PositionVo.fromJson(Map<String,dynamic> json) => _$PositionVoFromJson(json);

  Map<String,dynamic> toJson() => _$PositionVoToJson(this);
}