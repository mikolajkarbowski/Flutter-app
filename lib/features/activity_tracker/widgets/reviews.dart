import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/activity_tracker/bloc/reviews_data_cubit.dart';
import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews_chart.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews_metric_toggle.dart';
import 'package:memo_deck/features/activity_tracker/widgets/summary_statistics.dart';
import 'package:memo_deck/features/activity_tracker/widgets/time_intervals.dart';
import 'package:provider/provider.dart';

enum ReviewsMetric {
  reviewsTime,
  reviewsCount,
}

enum ReviewsTimeRange {
  month,
  quarter,
  year,
}

class ReviewsDataNotifier extends ChangeNotifier {
  ReviewsMetric _metric = ReviewsMetric.reviewsTime;
  ReviewsTimeRange _timeRange = ReviewsTimeRange.month;
  ReviewsMetric get metric => _metric;
  ReviewsTimeRange get timeRange => _timeRange;
  void changeMetric(ReviewsMetric type) {
    _metric = type;
    notifyListeners();
  }

  void changeTimeRange(ReviewsTimeRange range) {
    _timeRange = range;
    notifyListeners();
  }
}

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReviewsDataNotifier(),
      child: BlocProvider(
        create: (context) => ReviewsDataCubit(
            dataSource: serviceLocator<ActivityHistoryDataSource>())
          ..fetchData(),
        child: Builder(builder: (context) {
          final dataType = context.watch<ReviewsDataNotifier>().metric;
          return Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reviews',
                        style: AppTheme.headlineLarge,
                      ),
                      Spacer(),
                      ReviewsMetricToggle()
                    ],
                  ),
                ),
                Text(dataType == ReviewsMetric.reviewsTime
                    ? 'The time taken to answer the questions'
                    : 'The number of questions you have answered'),
                SizedBox(
                  height: 10,
                ),
                TimeInterval(),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800, maxHeight: 400),
                  child: ReviewsChart(),
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800, maxHeight: 140),
                    child: SummaryStatistics()),
              ],
            ),
          );
        }),
      ),
    );
  }
}
