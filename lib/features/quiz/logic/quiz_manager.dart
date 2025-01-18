import 'dart:math';

import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/features/quiz/logic/super_memo.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

class QuizManager {
  QuizManager({required this.dataSource, required this.deckId});
  final FlashcardsDataSource dataSource;
  final String deckId;
  final random = Random();
  late List<Flashcard> flashcards;

  bool get isQuizFinished {
    return flashcards.isEmpty;
  }

  Future<void> submitResponse(Flashcard flashcard, double grade) async {
    final updatedFlashcard = SuperMemo.sm2Algorithm(flashcard, grade);
    await dataSource.updateFlashcard(updatedFlashcard);
    if (updatedFlashcard.interval != 0) {
      flashcards.remove(flashcard);
    }
  }

  Future<void> prepareQuiz() async {
    flashcards = await dataSource.getFlashcardsForStudy(deckId);
  }

  Flashcard? getNextFlashcard() {
    if (isQuizFinished) {
      return null;
    }
    return flashcards[random.nextInt(flashcards.length)];
  }

  void flashcardChanged(Flashcard oldFlashcard, Flashcard newFlashcard) {
    flashcards.remove(oldFlashcard);
    if (newFlashcard.deckId == deckId) {
      flashcards.add(newFlashcard);
    }
  }
}
