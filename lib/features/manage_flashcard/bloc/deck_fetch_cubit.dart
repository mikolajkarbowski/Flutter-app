import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';

class DeckFetchCubit extends Cubit<DeckListState> {
  DeckFetchCubit({required this.dataSource}) : super(DeckListState.initial());

  final FlashcardsDataSource dataSource;

  Future<void> fetchDeckEntries() async {
    emit(DeckListState.loading());
    try {
      final List<DeckEntry> entries = await dataSource.getAllDeckEntries();
      emit(DeckListState.ready(deckEntries: entries));
    } catch (err) {
      emit(DeckListState.err(err: err));
    }
  }
}

sealed class DeckListState with EquatableMixin {
  DeckListState();
  factory DeckListState.initial() = DeckListInitialState;
  factory DeckListState.loading() = DeckListLoadingState;
  factory DeckListState.ready({required List<DeckEntry> deckEntries}) =
      DeckListReadyState;
  factory DeckListState.err({dynamic err}) = DeckListErrorState;
}

class DeckListInitialState extends DeckListState {
  @override
  List<Object?> get props => [];
}

class DeckListLoadingState extends DeckListState {
  @override
  List<Object?> get props => [];
}

class DeckListReadyState extends DeckListState {
  DeckListReadyState({required this.deckEntries});
  final List<DeckEntry> deckEntries;
  @override
  List<Object?> get props => deckEntries;
}

class DeckListErrorState extends DeckListState {
  DeckListErrorState({this.err});
  final dynamic err;
  @override
  List<Object?> get props => [err];
}
