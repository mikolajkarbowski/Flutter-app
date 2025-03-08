import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

class FlashcardsDataSource {
  FlashcardsDataSource({required this.authService, required this.firestore});
  final FirebaseAuth authService;
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _decks => firestore
      .collection('users')
      .doc(authService.currentUser!.uid)
      .collection('deck_entries');

  CollectionReference<Map<String, dynamic>> get _flashcards => firestore
      .collection('users')
      .doc(authService.currentUser!.uid)
      .collection('flashcards');

  Stream<List<DeckEntry>> get deckEntriesStream =>
      _decks.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => DeckEntry.fromJson(doc.data())).toList(),);

  List<Flashcard> _parseFlashcards(List<Map<String, dynamic>> rawData) {
    return rawData.map(Flashcard.fromJson).toList();
  }

  List<DeckEntry> _parseDeckEntries(List<Map<String, dynamic>> rawData) {
    return rawData.map(DeckEntry.fromJson).toList();
  }

  Future<void> addNewDeckEntry(DeckEntry deck) async {
    try {
      final res =
          await _decks.where('name', isEqualTo: deck.name).limit(1).get();
      if (res.docs.isNotEmpty) {
        throw Exception('Deck "${deck.name}" already exists!');
      }
      unawaited(_decks.doc(deck.deckId).set(deck.toJson()));
    } catch (err) {
      throw Exception('Failed to add new deck entry: $err');
    }
  }

  Future<List<DeckEntry>> getAllDeckEntries() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> res = await _decks.get();
      final List<Map<String, dynamic>> rawData =
          res.docs.map((doc) => doc.data()).toList();
      return await compute(_parseDeckEntries, rawData);
    } catch (err) {
      throw Exception('Failed to load deck entries: $err');
    }
  }

  Future<List<Flashcard>> _getFlashcardsWhere(Filter filter) async {
    {
      try {
        final QuerySnapshot<Map<String, dynamic>> res =
            await _flashcards.where(filter).get();
        final List<Map<String, dynamic>> rawData =
            res.docs.map((doc) => doc.data()).toList();
        return await compute(_parseFlashcards, rawData);
      } catch (err) {
        throw Exception('Failed to load flashcards: $err');
      }
    }
  }

  Future<List<Flashcard>> getFlashcards(String deckId) async {
    final filter = Filter('deckId', isEqualTo: deckId);
    return _getFlashcardsWhere(filter);
  }

  Future<List<Flashcard>> getFlashcardsForStudy(String deckId) async {
    final now = DateTime.now();
    final nextMidnight =
        DateTime(now.year, now.month, now.day + 1).toIso8601String();
    final filter = Filter.and(
        Filter('deckId', isEqualTo: deckId),
        Filter.or(Filter('nextReviewDate', isNull: true),
            Filter('nextReviewDate', isLessThanOrEqualTo: nextMidnight),),);
    return _getFlashcardsWhere(filter);
  }

  Future<FlashcardsBatch> getFlashcardsBatch(
      int batchSize, DocumentSnapshot? lastDocument, Filter? filter,) async {
    Query<Map<String, dynamic>> query =
        _flashcards.orderBy('cardId', descending: true);
    if (filter != null) {
      query = query.where(filter);
    }
    query = query.limit(batchSize);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    try {
      final res = await query.get();
      final lastDocument = res.docs.lastOrNull;
      final rawData = res.docs.map((doc) => doc.data()).toList();
      final flashcards = await compute(_parseFlashcards, rawData);

      return FlashcardsBatch(
          flashcards: flashcards, lastDocument: lastDocument,);
    } catch (err) {
      throw Exception('Failed to get flashcards: $err');
    }
  }

  void addNewFlashcard(Flashcard flashcard) {
    _flashcards.doc(flashcard.cardId).set(flashcard.toJson());
  }

  void updateFlashcard(Flashcard flashcard) {
    _flashcards.doc(flashcard.cardId).update(flashcard.toJson());
  }

  Future<void> _removeFlashcardsWhere(Filter filter) async {
    try {
      final querySnapshot = await _flashcards.where(filter).get();
      for (final doc in querySnapshot.docs) {
        unawaited(doc.reference.delete());
      }
    } catch (err) {
      throw Exception('Failed to remove flashcards: $err');
    }
  }

  Future<void> removeFlashcardsFromDeck(String deckId) async {
    final filter = Filter('deckId', isEqualTo: deckId);
    return _removeFlashcardsWhere(filter);
  }

  Future<void> removeFlashcard(Flashcard flashcard) async {
    final filter = Filter('cardId', isEqualTo: flashcard.cardId);
    return _removeFlashcardsWhere(filter);
  }

  void removeDeckEntry(String deckId) {
    _decks.doc(deckId).delete();
  }
}

class FlashcardsBatch {
  FlashcardsBatch({required this.flashcards, this.lastDocument});
  List<Flashcard> flashcards;
  DocumentSnapshot? lastDocument;
}
