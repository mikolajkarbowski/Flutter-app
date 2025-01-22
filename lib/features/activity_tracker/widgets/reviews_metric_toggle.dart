import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/activity_tracker/bloc/reviews_data_cubit.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews.dart';

class ReviewsMetricToggle extends StatelessWidget {
  const ReviewsMetricToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ReviewsDataNotifier>();
    final cubit = context.read<ReviewsDataCubit>();
    return SegmentedButton<ReviewsMetric>(
      segments: [
        ButtonSegment<ReviewsMetric>(
          value: ReviewsMetric.reviewsTime,
          label: Text('Time'),
        ),
        ButtonSegment<ReviewsMetric>(
          value: ReviewsMetric.reviewsCount,
          label: Text('Count'),
        ),
      ],
      selected: <ReviewsMetric>{notifier.metric},
      onSelectionChanged: (selected) {
        final metric = selected.first;
        cubit.getStudyTimeChartData(
            timeRange: notifier.timeRange, metric: metric);
        notifier.changeMetric(metric);
      },
    );
  }
}
