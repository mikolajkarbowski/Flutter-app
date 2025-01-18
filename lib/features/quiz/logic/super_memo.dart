import 'package:memo_deck/shared/models/flashcard.dart';

class SuperMemo {
  static Flashcard sm2Algorithm(Flashcard flashcard, double grade) {
    int n = flashcard.repetitions;
    double ef = flashcard.easeFactor;
    int interval = flashcard.interval;
    if (grade >= 3) {
      if (n == 0) {
        interval = 1;
      } else if (n == 1) {
        interval = 6;
      } else {
        interval = (interval * ef).round();
      }
      n += 1;
    } else {
      n = 0;
      interval = grade == 0 ? 0 : 1;
    }
    ef = ef + (0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02));
    if (ef < 1.3) {
      ef = 1.3;
    }
    return flashcard.copyWith(
      repetitions: n,
      easeFactor: ef,
      interval: interval,
      nextReviewDate: DateTime.now().add(Duration(days: interval)),
    );
  }
}
