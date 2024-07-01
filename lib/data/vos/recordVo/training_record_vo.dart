import 'package:json_annotation/json_annotation.dart';
import 'package:pahg_group/data/vos/training_vo.dart';
part 'training_record_vo.g.dart';

@JsonSerializable()
class TrainingRecordVo{
  @JsonKey(name: 'records')
  List<TrainingVo>? records;

  @JsonKey(name: 'pageNumber')
  int? pageNumber;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  TrainingRecordVo(this.records, this.pageNumber, this.totalRecords);

  factory TrainingRecordVo.fromJson(Map<String,dynamic> json) => _$TrainingRecordVoFromJson(json);

  Map<String,dynamic> toJson() => _$TrainingRecordVoToJson(this);
}