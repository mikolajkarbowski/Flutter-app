import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/activity_tracker/bloc/daily_stats_cubit.dart';
import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

import '../../../shared/widgets/error_screen.dart';

class DailyStats extends StatelessWidget {
  const DailyStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyStatsCubit(
          dataSource: serviceLocator<ActivityHistoryDataSource>())
        ..getDailyStats(),
      child: BlocBuilder<DailyStatsCubit, DailyStatsState>(
          builder: (context, state) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Today',
                      style: AppTheme.headlineLarge,
                    ),
                    Spacer(),
                  ],
                ),
                Divider(),
                switch (state) {
                  DailyStatsEmptyState() =>
                    Text('No cards have been studied today'),
                  DailyStatsReadyState() => Text(
                      'Studied ${state.cardsAnswered} cards in ${(state.totalTimeSec / 60).toStringAsFixed(2)} '
                      'minutes today (${(state.totalTimeSec / state.cardsAnswered).toStringAsFixed(2)}s/card)'),
                  DailyStatsErrorState() => ErrorScreen(),
                  _ => LoadingIndicator(),
                },
              ],
            ),
          ),
        );
      }),
    );
  }
}
