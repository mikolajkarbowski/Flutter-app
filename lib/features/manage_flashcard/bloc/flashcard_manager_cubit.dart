import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

class FlashcardManagerCubit extends Cubit<FlashcardState> {
  FlashcardManagerCubit({required this.dataSource})
      : super(FlashcardState.initial());

  final FlashcardsDataSource dataSource;

  Future<void> addNewFlashcard(Flashcard flashcard) async {
    try {
      await dataSource.addNewFlashcard(flashcard);
      emit(FlashcardState.added(flashcard: flashcard));
    } catch (e) {
      emit(FlashcardState.err(err: e));
    }
  }

  Future<void> updateFlashcard(
      Flashcard oldFlashcard, Flashcard newFlashcard) async {
    try {
      await dataSource.updateFlashcard(newFlashcard);
      emit(FlashcardState.updated(
          oldFlashcard: oldFlashcard, newFlashcard: newFlashcard));
    } catch (e) {
      emit(FlashcardState.err(err: e));
    }
  }
}

sealed class FlashcardState with EquatableMixin {
  FlashcardState();
  factory FlashcardState.initial() = FlashcardInitialState;
  factory FlashcardState.err({dynamic err}) = FlashcardErrorState;
  factory FlashcardState.added({required Flashcard flashcard}) =
      FlashcardAddedState;
  factory FlashcardState.updated(
      {required Flashcard oldFlashcard,
      required Flashcard newFlashcard}) = FlashcardUpdatedState;
}

class FlashcardInitialState extends FlashcardState {
  @override
  List<Object?> get props => [];
}

class FlashcardErrorState extends FlashcardState {
  FlashcardErrorState({this.err});
  final dynamic err;
  @override
  List<Object?> get props => [err];
}

class FlashcardAddedState extends FlashcardState {
  FlashcardAddedState({required this.flashcard});
  final Flashcard flashcard;
  @override
  List<Object?> get props => [flashcard];
}

class FlashcardUpdatedState extends FlashcardState {
  FlashcardUpdatedState(
      {required this.oldFlashcard, required this.newFlashcard});
  final Flashcard oldFlashcard;
  final Flashcard newFlashcard;

  @override
  List<Object?> get props => [oldFlashcard, newFlashcard];
}
