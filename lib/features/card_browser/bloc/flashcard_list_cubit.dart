import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';

import '../../../shared/models/flashcard.dart';

class FlashcardListCubit extends Cubit<FlashcardListState> {
  FlashcardListCubit({required this.dataSource})
      : super(FlashcardListState.initial());
  final FlashcardsDataSource dataSource;
  DocumentSnapshot? lastDocument;
  final int batchSize = 20;

  Future<void> fetchFlashcards(String deckId) async {
    if (state is FlashcardListLoadingState) {
      return;
    }
    emit(FlashcardListState.loading());
    try {
      Filter? filter;
      if (deckId != '0') {
        filter = Filter('deckId', isEqualTo: deckId);
      }
      final res =
          await dataSource.getFlashcardsBatch(batchSize, lastDocument, filter);
      final flashcards = res.flashcards;
      if (flashcards.isEmpty) {
        emit(FlashcardListState.end());
        return;
      }
      lastDocument = res.lastDocument;
      emit(FlashcardListState.ready(flashcards: flashcards));
    } catch (err) {
      emit(FlashcardListState.err(err: err));
    }
  }

  void removeFlashcard(Flashcard flashcard) {
    try {
      dataSource.removeFlashcard(flashcard);
      emit(FlashcardListState.itemRemoved(removed: flashcard));
    } catch (e) {
      emit(FlashcardListState.err(err: e));
    }
  }

  void flashcardUpdated(Flashcard oldFlashcard, Flashcard updatedFlashcard) {
    emit(FlashcardListState.itemUpdated(
        oldFlashcard: oldFlashcard, updatedFlashcard: updatedFlashcard));
  }

  void reset() {
    lastDocument = null;
    emit(FlashcardListState.initial());
  }
}

sealed class FlashcardListState with EquatableMixin {
  FlashcardListState();
  factory FlashcardListState.initial() = FlashcardListInitialState;
  factory FlashcardListState.loading() = FlashcardListLoadingState;
  factory FlashcardListState.ready({required List<Flashcard> flashcards}) =
      FlashcardListReadyState;
  factory FlashcardListState.end() = FlashcardListEndState;
  factory FlashcardListState.err({dynamic err}) = FlashcardListErrorState;
  factory FlashcardListState.itemRemoved({required Flashcard removed}) =
      FlashcardListItemRemovedState;
  factory FlashcardListState.itemUpdated(
      {required Flashcard oldFlashcard,
      required Flashcard updatedFlashcard}) = FlashcardListItemUpdatedState;
}

class FlashcardListInitialState extends FlashcardListState {
  FlashcardListInitialState();
  @override
  List<Object?> get props => [];
}

class FlashcardListLoadingState extends FlashcardListState {
  FlashcardListLoadingState();

  @override
  List<Object?> get props => [];
}

class FlashcardListReadyState extends FlashcardListState {
  FlashcardListReadyState({required this.flashcards});
  final List<Flashcard> flashcards;

  @override
  List<Object?> get props => [flashcards];
}

class FlashcardListErrorState extends FlashcardListState {
  FlashcardListErrorState({this.err});
  final dynamic err;
  @override
  List<Object?> get props => [err];
}

class FlashcardListEndState extends FlashcardListState {
  FlashcardListEndState();

  @override
  List<Object?> get props => [];
}

class FlashcardListItemRemovedState extends FlashcardListState {
  FlashcardListItemRemovedState({required this.removed});
  final Flashcard removed;
  @override
  List<Object?> get props => [removed];
}

class FlashcardListItemUpdatedState extends FlashcardListState {
  FlashcardListItemUpdatedState(
      {required this.oldFlashcard, required this.updatedFlashcard});
  final Flashcard oldFlashcard;
  final Flashcard updatedFlashcard;

  @override
  List<Object?> get props => [oldFlashcard, updatedFlashcard];
}
