import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/authentication/data/auth_service.dart';
import 'package:memo_deck/features/home/bloc/deck_add_cubit.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

import '../widgets/deck_list.dart';

// TODO: dodaj opcje usuniecia decku
// TODO: popraw okno dodawania decku

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DeckAddCubit(dataSource: serviceLocator<FlashcardsDataSource>()),
      child: Builder(builder: (context) {
        final cubit = context.read<DeckAddCubit>();

        return BlocListener<DeckAddCubit, DeckAddState>(
          listener: (context, state) {
            if (state is DeckAddErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.err)));
            } else if (state is DeckAddSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Deck "${state.deckEntry.name}" successfully added')));
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('HomePage'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final newDeckName = await showDialog<String>(
                    context: context, builder: (context) => AddDeckDialog());
                if (newDeckName != null) {
                  cubit.addNewDeckEntry(DeckEntry.create(name: newDeckName));
                }
              },
              child: Icon(Icons.add),
            ),
            body: StreamBuilder<List<DeckEntry>>(
                stream:
                    serviceLocator<FlashcardsDataSource>().deckEntriesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      color: Colors.red,
                    );
                  } else if (snapshot.hasData) {
                    return DeckList(
                      decks: snapshot.data!,
                    );
                  }
                  return LoadingIndicator();
                }),
            drawer: Drawer(
                child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                  ),
                  child: Text('Menu'),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    serviceLocator<AuthService>().signOut();
                    context.goNamed('SplashPage');
                  },
                )
              ],
            )),
          ),
        );
      }),
    );
  }
}

class AddDeckDialog extends StatefulWidget {
  const AddDeckDialog({super.key});
  @override
  State<StatefulWidget> createState() => _AddDeckDialogState();
}

class _AddDeckDialogState extends State<AddDeckDialog> {
  final _deckNameController = TextEditingController();

  @override
  void dispose() {
    _deckNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _deckNameController,
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: () => context.pop(_deckNameController.text),
            child: const Text('Add')),
      ],
    );
  }
}
