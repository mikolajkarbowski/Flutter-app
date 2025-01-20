import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/activity_tracker/logic/study_session_manager.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/features/quiz/bloc/quiz_manager_cubit.dart';
import 'package:memo_deck/features/quiz/logic/quiz_manager.dart';
import 'package:memo_deck/features/quiz/widgets/animated_flip_card.dart';
import 'package:memo_deck/features/quiz/widgets/quiz_end_screen.dart';
import 'package:memo_deck/shared/models/flashcard.dart';
import 'package:memo_deck/shared/widgets/loading_screen.dart';

import '../widgets/quiz_error_screen.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, required this.deckId});

  final String deckId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizManagerCubit(
          quizManager: QuizManager(
              dataSource: serviceLocator<FlashcardsDataSource>(),
              deckId: deckId))
        ..startQuiz(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Quiz'),
            actions: [
              _popupMenu(context),
              SizedBox(
                width: 30,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<QuizManagerCubit, QuizState>(
              builder: (context, state) {
                final cubit = context.read<QuizManagerCubit>();
                if (state is QuizEndState) {
                  serviceLocator<StudySessionManager>().endSession();
                }
                return switch (state) {
                  QuizInitialState() => LoadingScreen(),
                  QuizLoadingState() => LoadingScreen(),
                  QuizEndState() => QuizEndScreen(),
                  QuizErrorState() => QuizErrorScreen(
                      errorMessage: 'Failed to load flashcards.\n'
                          '${state.err}'
                          ' Please try again later.'),
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
                                    flashcard: state.flashcard)),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: Row(
                            children: [
                              _quizButton(context, 'Wrong', Colors.red, () {
                                cubit.submitResponse(state.flashcard, 0);
                                cubit.getNextCard();
                              }),
                              const SizedBox(
                                width: 4,
                              ),
                              _quizButton(context, 'Hard', Colors.yellow, () {
                                cubit.submitResponse(state.flashcard, 2);
                                cubit.getNextCard();
                              }),
                              const SizedBox(
                                width: 4,
                              ),
                              _quizButton(context, 'Good', Colors.green, () {
                                cubit.submitResponse(state.flashcard, 3);
                                cubit.getNextCard();
                              }),
                              const SizedBox(
                                width: 4,
                              ),
                              _quizButton(context, 'Easy', Colors.blue, () {
                                cubit.submitResponse(state.flashcard, 5);
                                cubit.getNextCard();
                              })
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

  Widget _quizButton(BuildContext context, String text, Color color,
      void Function()? onPressed) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(backgroundColor: color),
        child: Text(
          text,
          style: TextStyle(color: AppTheme.bodyTextColor),
        ),
      ),
    );
  }

  Widget _popupMenu(BuildContext context) {
    final cubit = context.watch<QuizManagerCubit>();
    return PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: AppTheme.bodyTextColor,
        ),
        onSelected: (value) async {
          switch (value) {
            case 'Edit':
              {
                final state = cubit.state;
                if (state is QuizNextCardState) {
                  serviceLocator<StudySessionManager>().suspendSession();
                  final res = await context.pushNamed('ManageFlashcardPage',
                      pathParameters: {'deckId': state.flashcard.deckId},
                      extra: state.flashcard);
                  if (res != null) {
                    final resCasted = res as List<Flashcard>;
                    cubit.flashcardUpdated(resCasted.first, resCasted.last);
                  }
                  serviceLocator<StudySessionManager>().continueSession();
                }
              }
          }
        },
        itemBuilder: (BuildContext context) => cubit.state is QuizNextCardState
            ? [
                const PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Edit'),
                      ],
                    )),
                const PopupMenuItem(
                    value: 'Delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Delete'),
                      ],
                    )),
              ]
            : []);
  }
}
