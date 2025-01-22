import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/card_browser/widgets/flashcard_tile.dart';
import 'package:memo_deck/shared/models/flashcard.dart';

import '../bloc/flashcard_list_cubit.dart';

class FlashcardsList extends StatefulWidget {
  const FlashcardsList({required this.deckId, super.key});

  final String deckId;
  @override
  State<StatefulWidget> createState() {
    return _FlashcardsListState();
  }
}

class _FlashcardsListState extends State<FlashcardsList> {
  final List<Flashcard> _flashcards = [];
  final _scrollController = ScrollController();
  late String _deckId;

  @override
  void initState() {
    super.initState();
    _deckId = widget.deckId;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<FlashcardListCubit>().fetchFlashcards(_deckId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlashcardsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deckId != widget.deckId) {
      setState(() {
        _flashcards.clear();
        _deckId = widget.deckId;
        context.read<FlashcardListCubit>()
          ..reset()
          ..fetchFlashcards(widget.deckId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlashcardListCubit, FlashcardListState>(
      listener: (context, state) {
        if (state is FlashcardListReadyState) {
          _flashcards.addAll(state.flashcards);
        }
        if (state is FlashcardListItemRemovedState) {
          _flashcards.remove(state.removed);
        }
        if (state is FlashcardListItemUpdatedState) {
          int index = _flashcards
              .indexWhere((e) => e.cardId == state.oldFlashcard.cardId);
          if (index != -1) {
            _flashcards[index] = state.updatedFlashcard;
          }
        }
      },
      child: BlocBuilder<FlashcardListCubit, FlashcardListState>(
          builder: (context, state) {
        return ListView.separated(
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
            return FlashcardTile(flashcard: flashcard);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 5,
            );
          },
        );
      }),
    );
  }
}
