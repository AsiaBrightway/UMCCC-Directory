
import 'package:json_annotation/json_annotation.dart';
part 'get_request.g.dart';

@JsonSerializable()
class GetRequest{
  @JsonKey(name: 'columnName')
  String columnName = '';

  @JsonKey(name: 'columnCondition')
  int columnCondition ;

  @JsonKey(name: 'columnValue')
  String columnValue = '';

  GetRequest({required this.columnName,required this.columnCondition,required this.columnValue} );

  factory GetRequest.fromJson(Map<String,dynamic> json) => _$GetRequestFromJson(json);

  Map<String,dynamic> toJson() => _$GetRequestToJson(this);
}