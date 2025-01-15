import 'package:flutter/cupertino.dart';
import 'package:memo_deck/features/home/widgets/deck_entry_tile.dart';
import 'package:memo_deck/features/home/widgets/empty_decks_list.dart';

import '../../../shared/models/deck_entry.dart';

class DeckList extends StatelessWidget {
  const DeckList({super.key, required this.decks});
  final List<DeckEntry> decks;

  @override
  Widget build(BuildContext context) {
    if (decks.isEmpty) {
      return EmptyDecksList();
    }
    return ListView.separated(
      itemBuilder: (context, index) =>
          DeckEntryTile(deck: decks.elementAt(index)),
      separatorBuilder: (context, index) => const SizedBox(
        height: 5,
      ),
      itemCount: decks.length,
    );
  }
}
