import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/deck_entry.dart';

class DeckEntryTile extends StatelessWidget {
  const DeckEntryTile({super.key, required this.deck});
  final DeckEntry deck;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: Text(deck.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _practiceButton(context),
            const SizedBox(
              width: 5,
            ),
            _deckMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _practiceButton(BuildContext context) {
    return FilledButton.tonal(
        onPressed: () {
          context.pushNamed('QuizPage', extra: deck.deckId);
        },
        child: Text('Practice'));
  }

  Widget _deckMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        context.pushNamed('AddFlashcardPage', extra: deck.deckId);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: 'add_card',
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 8,
                ),
                Text('Add Card'),
              ],
            ))
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
