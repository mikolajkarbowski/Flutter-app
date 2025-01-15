// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flashcard _$FlashcardFromJson(Map<String, dynamic> json) => Flashcard(
      cardId: json['cardId'] as String,
      deckId: json['deckId'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      nextReviewDate: json['nextReviewDate'] == null
          ? null
          : DateTime.parse(json['nextReviewDate'] as String),
      repetitions: (json['repetitions'] as num).toInt(),
      easeFactor: (json['easeFactor'] as num).toDouble(),
    );

Map<String, dynamic> _$FlashcardToJson(Flashcard instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'deckId': instance.deckId,
      'question': instance.question,
      'answer': instance.answer,
      'nextReviewDate': instance.nextReviewDate?.toIso8601String(),
      'repetitions': instance.repetitions,
      'easeFactor': instance.easeFactor,
    };
