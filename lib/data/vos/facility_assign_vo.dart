
import 'package:json_annotation/json_annotation.dart';
part 'facility_assign_vo.g.dart';

@JsonSerializable()
class FacilityAssignVo{
  @JsonKey(name: 'facility_assign_id')
  int? id;

  @JsonKey(name: 'facility_id')
  int? facilityId;

  @JsonKey(name: 'employee_id')
  String? employeeId;

  @JsonKey(name: 'assigned_date')
  String? assignedDate;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'return_status')
  String? returnStatus;

  @JsonKey(name: 'returned_date')
  String? returnedDate;

  @JsonKey(name: 'return_reason')
  String? returnReason;

  @JsonKey(name: 'createdBy')
  String? createdBy;

  @JsonKey(name: 'updatedBy')
  String? updatedBy;

  @JsonKey(name: 'createdAt')
  String? createdAt;

  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  @JsonKey(name: 'facilityName')
  String? facilityName;

  @JsonKey(name: 'facilityDescription')
  String? description;

  @JsonKey(name: 'facilityStatus')
  String? facilityStatus;

  FacilityAssignVo(
      this.id,
      this.facilityId,
      this.employeeId,
      this.assignedDate,
      this.status,
      this.returnStatus,
      this.returnedDate,
      this.returnReason,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.facilityName,
      this.description,
      this.facilityStatus);

  factory FacilityAssignVo.fromJson(Map<String,dynamic> json) => _$FacilityAssignVoFromJson(json);

  Map<String,dynamic> toJson() => _$FacilityAssignVoToJson(this);
}