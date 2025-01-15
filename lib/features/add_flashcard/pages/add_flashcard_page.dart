import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/features/add_flashcard/bloc/deck_fetch_cubit.dart';
import 'package:memo_deck/features/add_flashcard/bloc/flashcard_add_cubit.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

import '../../../shared/models/flashcard.dart';

class AddFlashCardPage extends StatefulWidget {
  const AddFlashCardPage({super.key, required this.selectedDeckId});

  final String selectedDeckId;

  @override
  State<AddFlashCardPage> createState() => _AddFlashCardPageState();
}

class _AddFlashCardPageState extends State<AddFlashCardPage> {
  final frontController = TextEditingController();
  final backController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String selectedDeckId;

  @override
  void initState() {
    selectedDeckId = widget.selectedDeckId;
    super.initState();
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => DeckFetchCubit(
                dataSource: serviceLocator<FlashcardsDataSource>())
              ..fetchDeckEntries()),
        BlocProvider(
            create: (context) => AddFlashcardCubit(
                dataSource: serviceLocator<FlashcardsDataSource>()))
      ],
      child: Builder(builder: (context) {
        return BlocListener<AddFlashcardCubit, FlashcardState>(
          bloc: context.read<AddFlashcardCubit>(),
          listener: (context, state) {
            if (state is FlashcardErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to add flashcard: ${state.err}')),
              );
            } else if (state is FlashcardAddedState) {
              clearFields();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('New flashcard added')),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add flashcard'),
            ),
            body: BlocBuilder<DeckFetchCubit, DeckListState>(
                builder: (context, state) {
              return switch (state) {
                DeckListInitialState() => LoadingIndicator(),
                DeckListLoadingState() => LoadingIndicator(),
                DeckListErrorState() => Container(
                    color: Colors.red,
                  ),
                DeckListReadyState() => _addPage(context, state.deckEntries),
              };
            }),
          ),
        );
      }),
    );
  }

  Widget _addPage(BuildContext context, List<DeckEntry> deckEntries) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _deckDropdownMenu(deckEntries),
                const SizedBox(
                  height: 20,
                ),
                _flashCardField(
                    labelText: 'Front', controller: frontController),
                const SizedBox(
                  height: 20,
                ),
                _flashCardField(labelText: 'Back', controller: backController),
                const SizedBox(
                  height: 20,
                ),
                _addButton(context),
              ],
            ),
          )),
    );
  }

  Widget _deckDropdownMenu(List<DeckEntry> deckEntries) {
    return DropdownButtonFormField<String>(
        value: selectedDeckId,
        decoration: const InputDecoration(
          labelText: 'Deck',
          border: OutlineInputBorder(),
        ),
        items: deckEntries.map((deckEntry) {
          return DropdownMenuItem(
            value: deckEntry.deckId,
            child: Text(deckEntry.name),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(
              () {
                clearFields();
                selectedDeckId = value;
              },
            );
          }
        });
  }

  Widget _flashCardField(
      {String? labelText, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      scrollPhysics: BouncingScrollPhysics(),
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'The term cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _addButton(BuildContext context) {
    final addCubit = context.read<AddFlashcardCubit>();
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Flashcard flashcard = Flashcard.create(
                      deckId: selectedDeckId,
                      question: frontController.text,
                      answer: backController.text);
                  addCubit.addNewFlashcard(flashcard);
                }
              },
              child: Text('Add Another Card')),
        ),
      ],
    );
  }

  void clearFields() {
    frontController.clear();
    backController.clear();
  }
}
