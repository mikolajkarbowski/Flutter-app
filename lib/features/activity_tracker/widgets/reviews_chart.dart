import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews.dart';

import '../../../shared/widgets/error_screen.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../bloc/reviews_data_cubit.dart';

class ReviewsChart extends StatelessWidget {
  const ReviewsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ReviewsDataCubit, ReviewsDataState>(
            builder: (context, state) {
          final dataNotifier = context.read<ReviewsDataNotifier>();
          return switch (state) {
            ReviewsDataInitialState() => const LoadingIndicator(),
            ReviewsDataLoadingState() => const LoadingIndicator(),
            ReviewsDataErrorState() => const ErrorScreen(),
            ReviewsDataReadyState() => BarChart(BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        var metric = '';
                        if (dataNotifier.metric == ReviewsMetric.reviewsTime) {
                          metric = 'min';
                        }
                        return Text('  ${value.toInt()} $metric',
                            style: const TextStyle(fontSize: 12),);
                      },
                      reservedSize: 50,
                    ),),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value % 10 == 0) {
                              return Text('${value.toInt()}');
                            }
                            return const SizedBox.shrink();
                          },),
                    ),
                    topTitles: const AxisTitles(
                        ),),
                borderData: FlBorderData(show: true),
                barGroups: state.barChartData,),),
          };
        },),
      ),
    );
  }
}
