import 'package:flutter/material.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';

import '../../../core/theme/app_theme.dart';

class DeleteDeckConfirmationDialog extends StatelessWidget {

  const DeleteDeckConfirmationDialog({
    super.key,
    required this.deckEntry,
    required this.onConfirm,
  });
  final DeckEntry deckEntry;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm deletion'),
      content: Text(
        'Are you sure you want to delete "${deckEntry.name}"?\n'
        ' This operation is irreversible.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: AppTheme.bodyLarge,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Delete',
            style: AppTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

Future<void> showDeleteDeckConfirmationDialog(
    BuildContext context, DeckEntry deckEntry, VoidCallback onConfirm,) {
  return showDialog(
    context: context,
    builder: (context) => DeleteDeckConfirmationDialog(
      deckEntry: deckEntry,
      onConfirm: onConfirm,
    ),
  );
}
