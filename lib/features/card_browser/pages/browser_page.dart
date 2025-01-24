import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/features/card_browser/bloc/flashcard_list_cubit.dart';
import 'package:memo_deck/features/card_browser/widgets/flashcards_list.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/features/manage_flashcard/bloc/deck_fetch_cubit.dart';
import 'package:memo_deck/shared/utilities/app_drawer.dart';
import 'package:memo_deck/shared/widgets/error_screen.dart';
import 'package:provider/provider.dart';

import '../../../shared/models/deck_entry.dart';
import '../../../shared/widgets/loading_screen.dart';

class BrowseParametersNotifier extends ChangeNotifier {
  String _selectedDeckId = '0';
  String get selectedDeckId => _selectedDeckId;
  void changeDeckId(String newDeckId) {
    _selectedDeckId = newDeckId;
    notifyListeners();
  }
}

class BrowserPage extends StatelessWidget {
  const BrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
            create: (context) => DeckFetchCubit(
                dataSource: serviceLocator<FlashcardsDataSource>())
              ..fetchDeckEntries()),
        BlocProvider(
            create: (context) => FlashcardListCubit(
                dataSource: serviceLocator<FlashcardsDataSource>())
              ..fetchFlashcards('0')),
        ChangeNotifierProvider(create: (context) => BrowseParametersNotifier()),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<DeckFetchCubit, DeckListState>(
            builder: (context, state) {
          return switch (state) {
            DeckListInitialState() => Scaffold(body: LoadingScreen()),
            DeckListLoadingState() => Scaffold(body: LoadingScreen()),
            DeckListErrorState() => Scaffold(
                appBar: AppBar(), drawer: AppDrawer(), body: ErrorScreen()),
            DeckListReadyState() => Scaffold(
                appBar: AppBar(
                  title: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: _deckDropdownMenu(context, state.deckEntries)),
                ),
                drawer: AppDrawer(),
                body: Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                  child: FlashcardsList(
                    deckId: context
                        .watch<BrowseParametersNotifier>()
                        .selectedDeckId,
                  ),
                ),
              ),
          };
        });
      }),
    );
  }

  Widget _deckDropdownMenu(BuildContext context, List<DeckEntry> deckEntries) {
    final allDecks = DropdownMenuItem(value: '0', child: Text('All decks'));

    return DropdownButtonFormField<String>(
        value: context.watch<BrowseParametersNotifier>().selectedDeckId,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        items: deckEntries.map((deckEntry) {
          return DropdownMenuItem(
            value: deckEntry.deckId,
            child: Text(
              deckEntry.name,
            ),
          );
        }).toList()
          ..insert(0, allDecks),
        onChanged: (value) {
          if (value != null) {
            context.read<BrowseParametersNotifier>().changeDeckId(value);
          }
        });
  }
}
