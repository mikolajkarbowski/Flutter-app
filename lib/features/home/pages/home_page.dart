import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/features/home/bloc/deck_management_cubit.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';
import 'package:memo_deck/shared/utilities/app_drawer.dart';
import 'package:memo_deck/shared/utilities/snack_bar_utils.dart';
import 'package:memo_deck/shared/widgets/error_screen.dart';
import 'package:memo_deck/shared/widgets/loading_screen.dart';

import '../widgets/deck_list.dart';

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
              SnackBarUtils.showSuccessSnackBar(
                  context, 'Deck "${state.deckEntry.name}" successfully added');
            } else if (state is DeckRemovedState) {
              SnackBarUtils.showSuccessSnackBar(
                  context, 'Deck "${state.deckEntry.name}" removed');
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('HomePage'),
            ),
            drawer: AppDrawer(),
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
                    return Scaffold(
                      appBar: AppBar(),
                      drawer: AppDrawer(),
                      body: ErrorScreen(),
                    );
                  } else if (snapshot.hasData) {
                    return DeckList(
                      decks: snapshot.data!,
                    );
                  }
                  return LoadingScreen(
                    message: "Loading Decks...",
                  );
                }),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _deckNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _deckNameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Deck name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.pop(_deckNameController.text);
              }
            },
            child: const Text('Add')),
      ],
    );
  }
}
