import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/models/deck_entry.dart';

class DeckAddCubit extends Cubit<DeckAddState> {
  DeckAddCubit({required this.dataSource}) : super(DeckAddState.initial());

  final FlashcardsDataSource dataSource;

  Future<void> addNewDeckEntry(DeckEntry deck) async {
    try {
      await dataSource.addNewDeckEntry(deck);
      emit(DeckAddState.success(deckEntry: deck));
    } catch (err) {
      emit(DeckAddState.err(err: err));
    }
  }
}

sealed class DeckAddState with EquatableMixin {
  DeckAddState();
  factory DeckAddState.initial() = DeckAddInitialState;
  factory DeckAddState.success({required DeckEntry deckEntry}) =
      DeckAddSuccessState;
  factory DeckAddState.err({dynamic err}) = DeckAddErrorState;
}

class DeckAddInitialState extends DeckAddState {
  @override
  List<Object?> get props => [];
}

class DeckAddSuccessState extends DeckAddState {
  DeckAddSuccessState({required this.deckEntry});
  final DeckEntry deckEntry;
  @override
  List<Object?> get props => [deckEntry];
}

class DeckAddErrorState extends DeckAddState {
  DeckAddErrorState({this.err});
  final dynamic err;

  @override
  List<Object?> get props => [err];
}
