import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/features/manage_flashcard/bloc/deck_fetch_cubit.dart';
import 'package:memo_deck/features/manage_flashcard/bloc/flashcard_manager_cubit.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/models/deck_entry.dart';
import 'package:memo_deck/shared/utilities/app_drawer.dart';
import 'package:memo_deck/shared/utilities/snack_bar_utils.dart';
import 'package:memo_deck/shared/widgets/error_screen.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';
import 'package:memo_deck/shared/widgets/loading_screen.dart';

import '../../../shared/models/flashcard.dart';

enum FlashcardAction {
  create,
  edit,
}

class ManageFlashcardPage extends StatefulWidget {
  const ManageFlashcardPage(
      {super.key, required this.selectedDeckId, this.selectedFlashcard});

  final String selectedDeckId;
  final Flashcard? selectedFlashcard;

  @override
  State<ManageFlashcardPage> createState() => _ManageFlashcardPageState();
}

class _ManageFlashcardPageState extends State<ManageFlashcardPage> {
  final frontController = TextEditingController();
  final backController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String selectedDeckId;
  late Flashcard? selectedFlashcard;
  late FlashcardAction mode;

  @override
  void initState() {
    selectedDeckId = widget.selectedDeckId;
    selectedFlashcard = widget.selectedFlashcard;
    mode = FlashcardAction.create;
    if (selectedFlashcard != null) {
      mode = FlashcardAction.edit;
      frontController.text = selectedFlashcard!.question;
      backController.text = selectedFlashcard!.answer;
    }
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
            create: (context) => FlashcardManagerCubit(
                dataSource: serviceLocator<FlashcardsDataSource>()))
      ],
      child: Builder(builder: (context) {
        return BlocListener<FlashcardManagerCubit, FlashcardState>(
          bloc: context.read<FlashcardManagerCubit>(),
          listener: (context, state) {
            if (state is FlashcardAddedState) {
              clearFields();
              SnackBarUtils.showSuccessSnackBar(context, 'New flashcard added');
            } else if (state is FlashcardUpdatedState) {
              context.pop([state.oldFlashcard, state.newFlashcard]);
            }
          },
          child: Scaffold(
            appBar: AppBar(
                title: switch (mode) {
              FlashcardAction.edit => Text('Edit flashcard'),
              FlashcardAction.create => Text('Add flashcard')
            }),
            body: BlocBuilder<DeckFetchCubit, DeckListState>(
                builder: (context, state) {
              return switch (state) {
                DeckListInitialState() => LoadingScreen(),
                DeckListLoadingState() => LoadingScreen(),
                DeckListErrorState() => Scaffold(
                    appBar: AppBar(),
                    drawer: AppDrawer(),
                    body: ErrorScreen(),
                  ),
                DeckListReadyState() => _managePage(context, state.deckEntries),
              };
            }),
          ),
        );
      }),
    );
  }

  Widget _managePage(BuildContext context, List<DeckEntry> deckEntries) {
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
                _confirmButton(context),
              ],
            ),
          )),
    );
  }

  Widget _deckDropdownMenu(List<DeckEntry> deckEntries) {
    return DropdownButtonFormField<String>(
        value: selectedDeckId,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Deck',
          border: OutlineInputBorder(),
        ),
        items: deckEntries.map((deckEntry) {
          return DropdownMenuItem(
            value: deckEntry.deckId,
            child: Text(deckEntry.name, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(
              () {
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

  Widget _confirmButton(BuildContext context) {
    final managerCubit = context.read<FlashcardManagerCubit>();
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: ElevatedButton(onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              switch (mode) {
                case FlashcardAction.create:
                  {
                    Flashcard flashcard = Flashcard.create(
                        deckId: selectedDeckId,
                        question: frontController.text,
                        answer: backController.text);
                    await managerCubit.addNewFlashcard(flashcard);
                  }
                case FlashcardAction.edit:
                  {
                    Flashcard newFlashcard = selectedFlashcard!.copyWith(
                        deckId: selectedDeckId,
                        question: frontController.text,
                        answer: backController.text);
                    await managerCubit.updateFlashcard(
                        selectedFlashcard!, newFlashcard);
                  }
              }
            }, child: BlocBuilder<FlashcardManagerCubit, FlashcardState>(
                builder: (context, state) {
              if (state is FlashcardProcessingState) {
                return LoadingIndicator();
              }
              switch (mode) {
                case FlashcardAction.edit:
                  {
                    return Text('Edit Flashcard');
                  }
                case FlashcardAction.create:
                  {
                    return Text('Add Another Card');
                  }
              }
            })),
          ),
        ),
      ],
    );
  }

  void clearFields() {
    frontController.clear();
    backController.clear();
  }
}
