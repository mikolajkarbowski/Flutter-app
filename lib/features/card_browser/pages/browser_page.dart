import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/features/card_browser/bloc/flashcard_list_cubit.dart';
import 'package:memo_deck/features/card_browser/widgets/flashcards_list.dart';
import 'package:memo_deck/features/home/data/flashcards_data_source.dart';
import 'package:memo_deck/shared/utilities/app_drawer.dart';

class BrowserPage extends StatelessWidget {
  const BrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FlashcardListCubit(dataSource: serviceLocator<FlashcardsDataSource>())
            ..fetchFlashcards(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Browser'),
        ),
        drawer: AppDrawer(),
        body: Builder(builder: (context) {
          return FlashcardsList();
        }),
      ),
    );
  }
}
