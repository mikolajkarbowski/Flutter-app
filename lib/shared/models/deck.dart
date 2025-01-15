import 'package:memo_deck/shared/models/flashcard.dart';

import 'deck_entry.dart';

class Deck {
  Deck({required DeckEntry entry})
      : deckId = entry.deckId,
        name = entry.name,
        flashCards = List<Flashcard>.empty(),
        toReview = 0;

  final String deckId;
  String name;
  List<Flashcard> flashCards;
  int toReview;
}
