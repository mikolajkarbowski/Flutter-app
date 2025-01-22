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

  Future<void> fetchFlashcards() async {
    emit(FlashcardListState.loading());
    try {
      final res = await dataSource.getFlashcardsBatch(batchSize, lastDocument);
      final flashcards = res.flashcards;
      lastDocument = res.lastDocument;
      if (flashcards.isEmpty) {
        emit(FlashcardListState.end());
        return;
      }
      emit(FlashcardListState.ready(flashcards: flashcards));
    } catch (err) {
      emit(FlashcardListState.err(err: err));
    }
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
