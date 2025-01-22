import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews.dart';

import '../bloc/reviews_data_cubit.dart';

class TimeInterval extends StatelessWidget {
  const TimeInterval({super.key});

  @override
  Widget build(BuildContext context) {
    ReviewsTimeRange? timeInterval =
        context.watch<ReviewsDataNotifier>().timeRange;
    void onTimeRangeChanged(ReviewsTimeRange? value) {
      if (value != null) {
        final notifier = context.read<ReviewsDataNotifier>();
        final cubit = context.read<ReviewsDataCubit>();
        notifier.changeTimeRange(value);
        cubit.getStudyTimeChartData(timeRange: value, metric: notifier.metric);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          Radio<ReviewsTimeRange>(
            value: ReviewsTimeRange.month,
            groupValue: timeInterval,
            onChanged: onTimeRangeChanged,
          ),
          Text('1 month'),
        ]),
        SizedBox(
          width: 10,
        ),
        Row(children: [
          Radio<ReviewsTimeRange>(
            value: ReviewsTimeRange.quarter,
            groupValue: timeInterval,
            onChanged: onTimeRangeChanged,
          ),
          Text('3 months'),
        ]),
        SizedBox(
          width: 10,
        ),
        Row(children: [
          Radio<ReviewsTimeRange>(
            value: ReviewsTimeRange.year,
            groupValue: timeInterval,
            onChanged: onTimeRangeChanged,
          ),
          Text('1 year'),
        ]),
      ],
    );
  }
}
