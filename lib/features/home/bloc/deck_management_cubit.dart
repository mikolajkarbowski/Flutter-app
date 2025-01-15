import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import '../../../shared/models/deck_entry.dart';

class DeckManagementCubit extends Cubit<DeckState> {
  DeckManagementCubit({required this.dataSource}) : super(DeckState.initial());

  final FlashcardsDataSource dataSource;

  Future<void> addNewDeckEntry(DeckEntry deck) async {
    try {
      await dataSource.addNewDeckEntry(deck);
      emit(DeckState.deckAdded(deckEntry: deck));
    } catch (err) {
      emit(DeckState.err(err: err));
    }
  }
  Future<void> removeDeck(DeckEntry deck) async{
    try{
      await dataSource.removeFlashcards(deck.deckId);
      await dataSource.removeDeckEntry(deck.deckId);
      emit(DeckState.deckRemoved(deckEntry: deck));
    }catch(err){
      emit(DeckState.err(err: err));
    }
  }
}

sealed class DeckState with EquatableMixin {
  DeckState();
  factory DeckState.initial() = DeckInitialState;
  factory DeckState.deckAdded({required DeckEntry deckEntry}) = DeckAddedState;
  factory DeckState.deckRemoved({required DeckEntry deckEntry}) = DeckRemovedState;
  factory DeckState.err({dynamic err}) = DeckErrorState;
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

class DeckRemovedState extends DeckState{

  DeckRemovedState({required this.deckEntry});
  final DeckEntry deckEntry;
  @override
  List<Object?> get props => [deckEntry];
}

class DeckErrorState extends DeckState {
  DeckErrorState({this.err});
  final dynamic err;

  @override
  List<Object?> get props => [err];
}

