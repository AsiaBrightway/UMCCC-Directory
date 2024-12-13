import 'package:json_annotation/json_annotation.dart';
part 'facility_vo.g.dart';

@JsonSerializable()
class FacilityVo{
  @JsonKey(name:'facility_id')
  int? id;

  @JsonKey(name:'facility_name')
  String? facilityName;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'createdBy')
  String? createdBy;

  @JsonKey(name: 'updatedBy')
  String? updatedBy;

  @JsonKey(name: 'createdAt')
  String? createdAt;

  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  FacilityVo(this.id, this.facilityName, this.description, this.status,
      this.createdBy, this.updatedBy, this.createdAt, this.updatedAt);

  factory FacilityVo.fromJson(Map<String,dynamic> json) => _$FacilityVoFromJson(json);

  Map<String,dynamic> toJson() => _$FacilityVoToJson(this);
}