import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/utilities/delay_action.dart';
import '../../../shared/models/deck_entry.dart';

class DeckManagementCubit extends Cubit<DeckState> {
  DeckManagementCubit({required this.dataSource}) : super(DeckState.initial());

  final FlashcardsDataSource dataSource;

  Future<void> addNewDeckEntry(DeckEntry deck) async {
    try {
      await dataSource.addNewDeckEntry(deck);
      await delayAction(
          action: () => emit(DeckState.deckAdded(deckEntry: deck)));
    } catch (err) {
      emit(DeckState.err(err: err, deckEntry: deck));
    }
  }

  Future<void> removeDeck(DeckEntry deck) async {
    dataSource.removeFlashcards(deck.deckId);
    dataSource.removeDeckEntry(deck.deckId);
    await delayAction(
        action: () => emit(DeckState.deckRemoved(deckEntry: deck)));
  }
}

sealed class DeckState with EquatableMixin {
  DeckState();
  factory DeckState.initial() = DeckInitialState;
  factory DeckState.deckAdded({required DeckEntry deckEntry}) = DeckAddedState;
  factory DeckState.deckRemoved({required DeckEntry deckEntry}) =
      DeckRemovedState;
  factory DeckState.err({dynamic err, DeckEntry? deckEntry}) = DeckErrorState;
}

class DeckInitialState extends DeckState {
  @override
  List<Object?> get props => [];
}

class DeckAddedState extends DeckState {
  DeckAddedState({required this.deckEntry});
  final DeckEntry deckEntry;
  @override
  List<Object?> get props => [deckEntry];
}

class DeckRemovedState extends DeckState {
  DeckRemovedState({required this.deckEntry});
  final DeckEntry deckEntry;
  @override
  List<Object?> get props => [deckEntry];
}

class DeckErrorState extends DeckState {
  DeckErrorState({this.err, this.deckEntry});
  final dynamic err;
  final DeckEntry? deckEntry;

  @override
  List<Object?> get props => [err, deckEntry];
}
