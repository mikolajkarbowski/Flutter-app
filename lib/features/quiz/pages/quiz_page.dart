import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/features/quiz/bloc/quiz_manager_cubit.dart';
import 'package:memo_deck/features/quiz/logic/quiz_manager.dart';
import 'package:memo_deck/features/quiz/widgets/animated_flip_card.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

// TODO: dodac obsluge edycji karty

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, required this.deckId});

  final String deckId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizManagerCubit(
          quizManager: QuizManager(
              dataSource: serviceLocator<FlashcardsDataSource>(),
              deckId: deckId))..startQuiz(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<QuizManagerCubit, QuizState>(
              builder: (context, state) {
                return switch (state) {
                  QuizInitialState() => LoadingIndicator(),
                  QuizLoadingState() => LoadingIndicator(),
                  QuizEndState() => Placeholder(),
                  // TODO: dodac obsluge zakonczenia quizu
                  QuizErrorState() => Placeholder(),
                  // Todo: dodac obsluge bledu quiz
                  QuizNextCardState() => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 600,
                                  maxHeight: 600,
                                ),
                                child: AnimatedFlipCard(
                                    flashcard: state.flashcard)
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // Obluga Hard
                                    context.read<QuizManagerCubit>().getNextCard();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: Text(
                                    'Hard',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // Obsługa "Good"
                                    context.read()<QuizManagerCubit>().getNextCard();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  child: Text(
                                    'Good',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // Obsługa "Easy"
                                    context.read<QuizManagerCubit>().getNextCard();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  child: Text(
                                    'Easy',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                };
              },
            ),
          ),
        );
      }),
    );
  }
}
