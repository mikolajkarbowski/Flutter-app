import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/core/service_locator.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/features/activity_tracker/bloc/repetitions_chart_cubit.dart';
import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';
import 'package:memo_deck/features/activity_tracker/widgets/chart_error_screen.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewsChartCubit(
          dataSource: serviceLocator<ActivityHistoryDataSource>())
        ..fetchData(),
      child: Card(
        child: Column(
          children: [
            Text(
              'Reviews',
              style: AppTheme.headlineLarge,
            ),
            Text('Time spent learning'),
            TimeInterval(),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800, maxHeight: 400),
              child: Chart(),
            )
          ],
        ),
      ),
    );
  }
}

enum TimeRange {
  month,
  quarter,
  year,
}

class TimeInterval extends StatefulWidget {
  const TimeInterval({super.key});

  @override
  State<TimeInterval> createState() => _TimeIntervalState();
}

class _TimeIntervalState extends State<TimeInterval> {
  TimeRange? _timeInterval = TimeRange.month;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          Radio<TimeRange>(
            value: TimeRange.month,
            groupValue: _timeInterval,
            onChanged: onTimeRangeChanged,
          ),
          Text('1 month'),
        ]),
        SizedBox(
          width: 10,
        ),
        Row(children: [
          Radio<TimeRange>(
            value: TimeRange.quarter,
            groupValue: _timeInterval,
            onChanged: onTimeRangeChanged,
          ),
          Text('3 months'),
        ]),
        SizedBox(
          width: 10,
        ),
        Row(children: [
          Radio<TimeRange>(
            value: TimeRange.year,
            groupValue: _timeInterval,
            onChanged: onTimeRangeChanged,
          ),
          Text('1 year'),
        ]),
      ],
    );
  }

  void onTimeRangeChanged(TimeRange? value) {
    if (value != null) {
      context.read<ReviewsChartCubit>().getStudyTimeChartData(value);
    }
    setState(() {
      _timeInterval = value;
    });
  }
}

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ReviewsChartCubit, ReviewsChartState>(
            builder: (context, state) {
          return switch (state) {
            // TODO: dodac obsluge
            ReviewsChartInitialState() => LoadingIndicator(),
            ReviewsChartLoadingState() => LoadingIndicator(),
            ReviewsChartErrorState() => ChartErrorScreen(),
            ReviewsChartReadyState() => BarChart(BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('  ${value.toInt()} min',
                            style: TextStyle(fontSize: 12));
                      },
                      reservedSize: 50,
                    )),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value % 10 == 0) {
                              return Text('${value.toInt()}');
                            }
                            return SizedBox.shrink();
                          }),
                    ),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: false,
                    ))),
                borderData: FlBorderData(show: true),
                barGroups: state.barChartData)),
          };
        }),
      ),
    );
  }
}
