import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews.dart';
import 'package:memo_deck/shared/models/study_session.dart';

class ReviewsChartCubit extends Cubit<ReviewsChartState> {
  ReviewsChartCubit({required this.dataSource})
      : super(ReviewsChartState.initial());

  final ActivityHistoryDataSource dataSource;
  List<StudySession>? sessions;

  int rodsCount = 31;

  Future<void> fetchData() async {
    try {
      emit(ReviewsChartState.loading());
      sessions = await dataSource.loadStudySessionsWithinLastYear();
    } catch (e) {
      emit(ReviewsChartState.err(err: e));
    }
    getStudyTimeChartData(TimeRange.month);
  }

  void getStudyTimeChartData(TimeRange timeRange) {
    if (sessions == null) {
      emit(ReviewsChartState.err(err: 'Data not loaded'));
      return;
    }
    int daysInTimeRange = switch (timeRange) {
      TimeRange.year => 365,
      TimeRange.quarter => 90,
      TimeRange.month => 30,
    };
    List<int> res = List<int>.filled(rodsCount, 0);
    int intervalSize = (daysInTimeRange / rodsCount).round();

    final now = DateTime.now();
    for (var session in sessions!) {
      Duration diff = session.startTime!.difference(now);
      int days = diff.inDays.abs();
      if (0 <= days && days <= daysInTimeRange) {
        int interval = (days / intervalSize).floor();
        res[interval] += session.totalDuration.inSeconds;
      }
    }

    List<BarChartGroupData> data = [];
    for (int i = 0; i < res.length; i++) {
      double timeInMin = res[i] / 60;
      String timeString = timeInMin.toStringAsFixed(2);
      double timeRounded = double.parse(timeString);
      data.add(BarChartGroupData(x: -i * intervalSize, barRods: [
        BarChartRodData(
          toY: timeRounded,
          color: Colors.blue,
        ),
      ]));
    }
    data = data.reversed.toList();
    emit(ReviewsChartState.ready(barChartData: data));
  }
}

sealed class ReviewsChartState with EquatableMixin {
  ReviewsChartState();
  factory ReviewsChartState.initial() = ReviewsChartInitialState;
  factory ReviewsChartState.loading() = ReviewsChartLoadingState;
  factory ReviewsChartState.err({required dynamic err}) =
      ReviewsChartErrorState;
  factory ReviewsChartState.ready(
      {required List<BarChartGroupData> barChartData}) = ReviewsChartReadyState;
}

class ReviewsChartInitialState extends ReviewsChartState {
  ReviewsChartInitialState();

  @override
  List<Object?> get props => [];
}

class ReviewsChartLoadingState extends ReviewsChartState {
  ReviewsChartLoadingState();

  @override
  List<Object?> get props => [];
}

class ReviewsChartErrorState extends ReviewsChartState {
  ReviewsChartErrorState({required this.err});
  final dynamic err;

  @override
  List<Object?> get props => [err];
}

class ReviewsChartReadyState extends ReviewsChartState {
  ReviewsChartReadyState({required this.barChartData});
  final List<BarChartGroupData> barChartData;
  @override
  List<Object?> get props => barChartData;
}
