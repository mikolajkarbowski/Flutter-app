import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> addNewDeckEntry(DeckEntry deck) async {
    try {
      await _decks.doc(deck.deckId).set(deck.toJson());
    } catch (e) {
      throw Exception('Failed to add deck entry: $e');
    }
  }

  Future<List<DeckEntry>> getAllDeckEntries() async {
    try {
      QuerySnapshot<Map<String, dynamic>> res = await _decks.get();
      return res.docs.map((doc) => DeckEntry.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to load deck entries: $e');
    }
  }

  Future<List<Flashcard>> getFlashCards(String deckId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> res =
          await _flashcards.where('deckId', isEqualTo: deckId).get();
      return res.docs.map((doc) => Flashcard.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to load flashcards: $e');
    }
  }

  Future<void> addNewFlashcard(Flashcard flashcard) async {
    try {
      await _flashcards.doc(flashcard.cardId).set(flashcard.toJson());
    } catch (e) {
      throw Exception('Failed to add flashcard: $e');
    }
  }
}
