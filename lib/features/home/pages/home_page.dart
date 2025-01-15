import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/authentication/data/auth_service.dart';
import 'package:memo_deck/features/home/bloc/deck_management_cubit.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';
import 'package:memo_deck/shared/utilities/snackbar_utils.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

import '../widgets/deck_list.dart';

// TODO: dodaj opcje usuniecia decku
// TODO: popraw okno dodawania decku
// TODO: dodac jakis pading na dole bo nie mozna klikac w action button

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeckManagementCubit(
          dataSource: serviceLocator<FlashcardsDataSource>()),
      child: Builder(builder: (context) {
        final cubit = context.read<DeckManagementCubit>();

        return BlocListener<DeckManagementCubit, DeckState>(
          listener: (context, state) {
            if (state is DeckErrorState) {
              SnackBarUtils.showErrorSnackBar(context, state.err);
            } else if (state is DeckAddedState) {
              SnackBarUtils.showSuccessSnackBar(context,
                  'Deck "${state.deckEntry.name}" successfully added');
            }
            else if(state is DeckRemovedState){
              SnackBarUtils.showSuccessSnackBar(context,
              'Deck "${state.deckEntry.name}" removed');
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
