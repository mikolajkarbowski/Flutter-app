import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/quiz/logic/quiz_manager.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

class QuizManagerCubit extends Cubit<QuizState> {
  QuizManagerCubit({required this.quizManager}) : super(QuizState.initial());
  final QuizManager quizManager;

  Future<void> startQuiz() async {
    emit(QuizState.loading());
    try {
      await quizManager.prepareQuiz();
      getNextCard();
    } catch (err) {
      emit(QuizState.err(err: err));
    }
  }

  void submitResponse(Flashcard flashcard, double grade) {
    quizManager.submitResponse(flashcard, grade);
  }

  void flashcardUpdated(Flashcard oldFlashcard, Flashcard newFlashcard) {
    quizManager.flashcardChanged(oldFlashcard, newFlashcard);
    if (newFlashcard.deckId == quizManager.deckId) {
      emit(QuizState.nextCard(
          flashcard: newFlashcard, quizProgress: quizManager.quizProgress,),);
    } else {
      getNextCard();
    }
  }

  void getNextCard() {
    if (quizManager.isQuizFinished) {
      emit(QuizState.end());
      return;
    }
    final Flashcard? flashcard = quizManager.getNextFlashcard();
    if (flashcard == null) {
      emit(QuizState.err(err: 'Unable to load next flashcard'));
      return;
    }
    emit(QuizState.nextCard(
        flashcard: flashcard, quizProgress: quizManager.quizProgress,),);
  }

  void getPreviousCard() {
    if (quizManager.isQuizFinished) {
      return;
    }

    final Flashcard? previous = quizManager.getPreviousFlashcard();
    if (previous != null) {
      emit(QuizState.nextCard(
          flashcard: previous, quizProgress: quizManager.quizProgress,),);
    }
  }
}

sealed class QuizState with EquatableMixin {
  QuizState();
  factory QuizState.initial() = QuizInitialState;
  factory QuizState.loading() = QuizLoadingState;
  factory QuizState.nextCard(
      {required Flashcard flashcard,
      required double quizProgress,}) = QuizNextCardState;
  factory QuizState.end() = QuizEndState;
  factory QuizState.err({dynamic err}) = QuizErrorState;
}

class QuizInitialState extends QuizState {
  QuizInitialState();
  @override
  List<Object?> get props => [];
}

class QuizLoadingState extends QuizState {
  QuizLoadingState();
  @override
  List<Object?> get props => [];
}

class QuizNextCardState extends QuizState {
  QuizNextCardState({required this.flashcard, required this.quizProgress});
  final Flashcard flashcard;
  final double quizProgress;

  @override
  List<Object?> get props => [flashcard, quizProgress];
}

class QuizEndState extends QuizState {
  QuizEndState();
  @override
  List<Object?> get props => [];
}

class QuizErrorState extends QuizState {
  QuizErrorState({this.err});
  final dynamic err;
  @override
  List<Object?> get props => [err];
}
