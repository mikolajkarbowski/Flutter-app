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
          snapshot.docs.map((doc) => DeckEntry.fromJson(doc.data())).toList());

  List<Flashcard> _parseFlashcards(List<Map<String, dynamic>> rawData) {
    return rawData.map((data) => Flashcard.fromJson(data)).toList();
  }

  List<DeckEntry> _parseDeckEntries(List<Map<String, dynamic>> rawData) {
    return rawData.map((data) => DeckEntry.fromJson(data)).toList();
  }

  Future<void> addNewDeckEntry(DeckEntry deck) async {
    try {
      final res =
          await _decks.where('name', isEqualTo: deck.name).limit(1).get();
      if (res.docs.isNotEmpty) {
        throw 'Deck "${deck.name}" already exists!';
      }
      _decks.doc(deck.deckId).set(deck.toJson());
    } catch (e) {
      throw 'Failed to add new deck entry: $e';
    }
  }

  Future<List<DeckEntry>> getAllDeckEntries() async {
    try {
      QuerySnapshot<Map<String, dynamic>> res = await _decks.get();
      List<Map<String, dynamic>> rawData =
          res.docs.map((doc) => doc.data()).toList();
      return await compute(_parseDeckEntries, rawData);
    } catch (e) {
      throw 'Failed to load deck entries: $e';
    }
  }

  Future<List<Flashcard>> _getFlashcardsWhere(Filter filter) async {
    {
      try {
        QuerySnapshot<Map<String, dynamic>> res =
            await _flashcards.where(filter).get();
        List<Map<String, dynamic>> rawData =
            res.docs.map((doc) => doc.data()).toList();
        return await compute(_parseFlashcards, rawData);
      } catch (e) {
        throw Exception('Failed to load flashcards: $e');
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
            Filter('nextReviewDate', isLessThanOrEqualTo: nextMidnight)));
    return _getFlashcardsWhere(filter);
  }

  void addNewFlashcard(Flashcard flashcard) {
    _flashcards.doc(flashcard.cardId).set(flashcard.toJson());
  }

  void updateFlashcard(Flashcard flashcard) {
    _flashcards.doc(flashcard.cardId).update(flashcard.toJson());
  }

  Future<void> removeFlashcards(String deckId) async {
    QuerySnapshot querySnapshot =
        await _flashcards.where('deckId', isEqualTo: deckId).get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }

  void removeDeckEntry(String deckId) {
    _decks.doc(deckId).delete();
  }
}
