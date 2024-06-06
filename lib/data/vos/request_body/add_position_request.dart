import 'package:json_annotation/json_annotation.dart';
part 'add_position_request.g.dart';

@JsonSerializable()
class AddPositionRequest{

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'departmentId')
  int? departmentId;

  @JsonKey(name: 'position')
  String? position;

  @JsonKey(name: 'isActive')
  bool? isActive;

  AddPositionRequest(this.id, this.departmentId, this.position, this.isActive);

  factory AddPositionRequest.fromJson(Map<String,dynamic> json) => _$AddPositionRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddPositionRequestToJson(this);
}