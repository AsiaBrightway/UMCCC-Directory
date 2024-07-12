// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_training_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTrainingRequest _$AddTrainingRequestFromJson(Map<String, dynamic> json) =>
    AddTrainingRequest(
      (json['id'] as num?)?.toInt(),
      json['employeeId'] as String?,
      json['courseName'] as String?,
      (json['trainingType'] as num?)?.toInt(),
      json['trainingProvidedBy'] as String?,
      json['place'] as String?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      json['totalTrainingTime'] as String?,
      (json['trainingResult'] as num?)?.toInt(),
      json['certificate'] as bool?,
      json['note'] as String?,
    );

Map<String, dynamic> _$AddTrainingRequestToJson(AddTrainingRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'courseName': instance.courseName,
      'trainingType': instance.trainingType,
      'trainingProvidedBy': instance.trainingProvidedBy,
      'place': instance.place,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'totalTrainingTime': instance.totalTrainingTime,
      'trainingResult': instance.trainingResult,
      'certificate': instance.certificate,
      'note': instance.note,
    };
