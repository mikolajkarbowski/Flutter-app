import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/flashcard.dart';
import 'package:memo_deck/shared/utilities/delay_action.dart';

class FlashcardManagerCubit extends Cubit<FlashcardState> {
  FlashcardManagerCubit({required this.dataSource})
      : super(FlashcardState.initial());

  final FlashcardsDataSource dataSource;

  Future<void> addNewFlashcard(Flashcard flashcard) async {
    emit(FlashcardState.processing());
    dataSource.addNewFlashcard(flashcard);
    await delayAction(
        action: () => emit(FlashcardState.added(flashcard: flashcard)),);
  }

  Future<void> updateFlashcard(
      Flashcard oldFlashcard, Flashcard newFlashcard,) async {
    emit(FlashcardState.processing());
    dataSource.updateFlashcard(newFlashcard);
    await delayAction(
        action: () => emit(FlashcardState.updated(
            oldFlashcard: oldFlashcard, newFlashcard: newFlashcard,),),);
  }
}

sealed class FlashcardState with EquatableMixin {
  FlashcardState();
  factory FlashcardState.initial() = FlashcardInitialState;
  factory FlashcardState.processing() = FlashcardProcessingState;
  factory FlashcardState.added({required Flashcard flashcard}) =
      FlashcardAddedState;
  factory FlashcardState.updated(
      {required Flashcard oldFlashcard,
      required Flashcard newFlashcard,}) = FlashcardUpdatedState;
}

class FlashcardInitialState extends FlashcardState {
  @override
  List<Object?> get props => [];
}

class FlashcardProcessingState extends FlashcardState {
  FlashcardProcessingState();
  @override
  List<Object?> get props => [];
}

class FlashcardAddedState extends FlashcardState {
  FlashcardAddedState({required this.flashcard});
  final Flashcard flashcard;
  @override
  List<Object?> get props => [flashcard];
}

class FlashcardUpdatedState extends FlashcardState {
  FlashcardUpdatedState(
      {required this.oldFlashcard, required this.newFlashcard,});
  final Flashcard oldFlashcard;
  final Flashcard newFlashcard;

  @override
  List<Object?> get props => [oldFlashcard, newFlashcard];
}
