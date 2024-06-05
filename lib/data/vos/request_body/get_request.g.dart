// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetRequest _$GetRequestFromJson(Map<String, dynamic> json) => GetRequest(
      columnName: json['columnName'] as String,
      columnCondition: (json['columnCondition'] as num).toInt(),
      columnValue: json['columnValue'] as String,
    );

Map<String, dynamic> _$GetRequestToJson(GetRequest instance) =>
    <String, dynamic>{
      'columnName': instance.columnName,
      'columnCondition': instance.columnCondition,
      'columnValue': instance.columnValue,
    };
