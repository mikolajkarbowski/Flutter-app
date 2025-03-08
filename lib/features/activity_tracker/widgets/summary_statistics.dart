import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/activity_tracker/bloc/reviews_data_cubit.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews.dart';

class SummaryStatistics extends StatelessWidget {
  const SummaryStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<ReviewsDataNotifier>();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BlocBuilder<ReviewsDataCubit, ReviewsDataState>(
          builder: (context, state) {
        if (state is! ReviewsDataReadyState) {
          return const SizedBox.shrink();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Days studied: '),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Total: '),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Average for days studied: '),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Average over period: '),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${state.daysStudied} of ${state.daysInTimeRange} '
                      '(${((state.daysStudied / state.daysInTimeRange) * 100).toStringAsFixed(2)}%)'),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(notifier.metric == ReviewsMetric.reviewsTime
                      ? '${state.totalTime.toStringAsFixed(2)} minutes'
                      : '${state.totalAnswers} reviews',),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(notifier.metric == ReviewsMetric.reviewsTime
                      ? '${(state.totalTime / state.daysStudied).toStringAsFixed(2)} minute/day'
                      : '${(state.totalAnswers / state.daysStudied).toStringAsFixed(2)} reviews/day',),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(notifier.metric == ReviewsMetric.reviewsTime
                      ? '${(state.totalTime / state.daysInTimeRange).toStringAsFixed(2)} minute/day'
                      : '${(state.totalAnswers / state.daysInTimeRange).toStringAsFixed(2)} reviews/day',),
                ],
              ),
            ),
          ],
        );
      },),
    );
  }
}
