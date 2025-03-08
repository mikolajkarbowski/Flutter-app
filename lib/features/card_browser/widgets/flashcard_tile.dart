import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/features/card_browser/bloc/flashcard_list_cubit.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/flashcard.dart';

class FlashcardTile extends StatelessWidget {
  const FlashcardTile({
    required this.flashcard,
    super.key,
  });
  final Flashcard flashcard;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                flashcard.question,
                style: AppTheme.bodyLarge,
              ),),
              const VerticalDivider(),
              Expanded(
                  child: Text(
                flashcard.answer,
                style: AppTheme.bodyLarge,
              ),),
              const VerticalDivider(),
              _flashcardMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flashcardMenu(BuildContext context) {
    final listCubit = context.read<FlashcardListCubit>();
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        switch (value) {
          case 'remove_card':
            {
              listCubit.removeFlashcard(flashcard);
            }
          case 'edit_card':
            {
              final res = await context.pushNamed('ManageFlashcardPage',
                  pathParameters: {'deckId': flashcard.deckId},
                  extra: flashcard,);
              if (res != null) {
                final resCasted = res as List<Flashcard>;
                final updatedFlashcard = resCasted.last;
                listCubit.flashcardUpdated(flashcard, updatedFlashcard);
              }
            }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: 'edit_card',
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(
                  width: 8,
                ),
                Text('Edit card'),
              ],
            ),),
        const PopupMenuItem(
            value: 'remove_card',
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Remove card'),
              ],
            ),),
      ],
    );
  }
}
