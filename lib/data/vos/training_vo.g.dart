// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingVo _$TrainingVoFromJson(Map<String, dynamic> json) => TrainingVo(
      (json['Id'] as num?)?.toInt(),
      json['EmployeeId'] as String?,
      json['CourseName'] as String?,
      (json['TrainingType'] as num?)?.toInt(),
      json['TrainingProvidedBy'] as String?,
      json['Place'] as String?,
      json['StartDate'] as String?,
      json['EndDate'] as String?,
      json['TotalTrainingTime'] as String?,
      (json['TrainingResult'] as num?)?.toInt(),
      json['Certificate'] as bool?,
      json['Note'] as String?,
      json['ImageUrl'] as String?,
      json['Remark'] as String?,
    );

Map<String, dynamic> _$TrainingVoToJson(TrainingVo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'EmployeeId': instance.employeeId,
      'CourseName': instance.courseName,
      'TrainingType': instance.trainingType,
      'TrainingProvidedBy': instance.trainingProvidedBy,
      'Place': instance.place,
      'StartDate': instance.startDate,
      'EndDate': instance.endDate,
      'TotalTrainingTime': instance.totalTrainingTime,
      'TrainingResult': instance.trainingResult,
      'Certificate': instance.certificate,
      'Note': instance.note,
      'ImageUrl': instance.imageUrl,
      'Remark': instance.remark,
    };
