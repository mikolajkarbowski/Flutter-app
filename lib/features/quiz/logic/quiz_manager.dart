import 'dart:math';

import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/features/quiz/logic/super_memo.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

class QuizManager {
  QuizManager({required this.dataSource, required this.deckId});
  final FlashcardsDataSource dataSource;
  final String deckId;
  final random = Random();
  final List<Flashcard> answeredFlashcards = [];
  late List<Flashcard> flashcards;

  int answerCount = 0;

  double get quizProgress {
    if (answerCount + flashcards.length == 0) {
      return 0;
    }
    return answerCount / (answerCount + flashcards.length);
  }

  bool get isQuizFinished {
    return flashcards.isEmpty;
  }

  void submitResponse(Flashcard flashcard, double grade) {
    answerCount += 1;

    flashcards.remove(flashcard);
    answeredFlashcards.removeWhere((card) => card.cardId == flashcard.cardId);
    answeredFlashcards.add(flashcard);

    final updatedFlashcard = SuperMemo.sm2Algorithm(flashcard, grade);
    dataSource.updateFlashcard(updatedFlashcard);

    if (updatedFlashcard.interval == 0) {
      flashcards.add(updatedFlashcard);
    }
  }

  Future<void> prepareQuiz() async {
    answerCount = 0;
    flashcards = await dataSource.getFlashcardsForStudy(deckId);
  }

  Flashcard? getNextFlashcard() {
    if (isQuizFinished) {
      return null;
    }
    return flashcards[random.nextInt(flashcards.length)];
  }

  Flashcard? getPreviousFlashcard() {
    if (answeredFlashcards.isNotEmpty) {
      return answeredFlashcards.removeLast();
    }
    return null;
  }

  void flashcardChanged(Flashcard oldFlashcard, Flashcard newFlashcard) {
    flashcards.remove(oldFlashcard);
    if (newFlashcard.deckId == deckId) {
      flashcards.add(newFlashcard);
    }
  }
}
