import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

class AddFlashcardCubit extends Cubit<FlashcardState> {
  AddFlashcardCubit({required this.dataSource})
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
}

sealed class FlashcardState with EquatableMixin {
  FlashcardState();
  factory FlashcardState.initial() = FlashcardInitialState;
  factory FlashcardState.err({dynamic err}) = FlashcardErrorState;
  factory FlashcardState.added({required Flashcard flashcard}) =
      FlashcardAddedState;
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
