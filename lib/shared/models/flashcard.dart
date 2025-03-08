import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'flashcard.g.dart';

@JsonSerializable()
class Flashcard {
  Flashcard(
      {required this.cardId,
      required this.deckId,
      required this.question,
      required this.answer,
      required this.nextReviewDate,
      required this.interval,
      required this.repetitions,
      required this.easeFactor,});

  Flashcard.create(
      {required String deckId,
      required String question,
      required String answer,})
      : this(
            cardId: const Uuid().v8(),
            deckId: deckId,
            question: question,
            answer: answer,
            nextReviewDate: null,
            interval: 0,
            repetitions: 0,
            easeFactor: 2.5,);

  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFromJson(json);

  final String cardId;
  final String deckId;
  final String question;
  final String answer;
  final DateTime? nextReviewDate;
  final int interval;
  final int repetitions;
  final double easeFactor;

  Flashcard copyWith({
    String? cardId,
    String? deckId,
    String? question,
    String? answer,
    DateTime? nextReviewDate,
    int? interval,
    int? repetitions,
    double? easeFactor,
  }) {
    return Flashcard(
        cardId: cardId ?? this.cardId,
        deckId: deckId ?? this.deckId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        nextReviewDate: nextReviewDate,
        interval: interval ?? this.interval,
        repetitions: repetitions ?? this.repetitions,
        easeFactor: easeFactor ?? this.easeFactor,);
  }

  Map<String, dynamic> toJson() => _$FlashcardToJson(this);
}
