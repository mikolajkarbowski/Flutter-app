// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudySession _$StudySessionFromJson(Map<String, dynamic> json) => StudySession(
      sessionId: json['sessionId'] as String,
      deckId: json['deckId'] as String,
    )
      ..startTime = json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String)
      ..totalDuration =
          Duration(seconds: (json['totalDuration'] as num).toInt())
      ..cardsReviewed = (json['cardsReviewed'] as num).toInt();

Map<String, dynamic> _$StudySessionToJson(StudySession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'deckId': instance.deckId,
      'startTime': instance.startTime?.toIso8601String(),
      'totalDuration': instance.totalDuration.inSeconds,
      'cardsReviewed': instance.cardsReviewed,
    };
