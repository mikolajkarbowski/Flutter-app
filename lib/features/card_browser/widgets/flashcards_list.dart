import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

import '../bloc/flashcard_list_cubit.dart';

class FlashcardsList extends StatefulWidget {
  const FlashcardsList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FlashcardsListState();
  }
}

class _FlashcardsListState extends State<FlashcardsList> {
  final List<Flashcard> _flashcards = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<FlashcardListCubit>().fetchFlashcards();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardListCubit, FlashcardListState>(
        builder: (context, state) {
      if (state is FlashcardListReadyState) {
        _flashcards.addAll(state.flashcards);
      }
      //TODO: pamietac o obsludze pustej listy
      return ListView.builder(
          controller: _scrollController,
          itemCount: _flashcards.length + 1,
          itemBuilder: (context, index) {
            if (index == _flashcards.length) {
              return Center(
                child: state is FlashcardListLoadingState
                    ? LinearProgressIndicator()
                    : SizedBox.shrink(),
              );
            }
            final flashcard = _flashcards[index];
            return Text(flashcard.answer);
          });
    });
  }
}
