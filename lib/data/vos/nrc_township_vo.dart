
import 'package:json_annotation/json_annotation.dart';
part 'nrc_township_vo.g.dart';

@JsonSerializable()
class NrcTownshipVo{
  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'StateDistrictNo')
  int? stateDistrictNo;

  @JsonKey(name: 'Name')
  String? name;

  @JsonKey(name: 'Description')
  String? description;

  NrcTownshipVo(this.id, this.stateDistrictNo, this.name, this.description);

  factory NrcTownshipVo.fromJson(Map<String,dynamic> json) => _$NrcTownshipVoFromJson(json);

  Map<String,dynamic> toJson() => _$NrcTownshipVoToJson(this);
}