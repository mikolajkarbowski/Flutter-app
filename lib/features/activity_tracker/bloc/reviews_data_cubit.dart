import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews.dart';
import 'package:memo_deck/shared/models/study_session.dart';

class ReviewsDataCubit extends Cubit<ReviewsDataState> {
  ReviewsDataCubit({required this.dataSource})
      : super(ReviewsDataState.initial());

  final ActivityHistoryDataSource dataSource;
  List<StudySession>? sessions;

  int rodsCount = 31;

  Future<void> fetchData() async {
    try {
      emit(ReviewsDataState.loading());
      sessions = await dataSource.loadStudySessionsWithinLastYear();
    } catch (e) {
      emit(ReviewsDataState.err(err: e));
    }
    getStudyTimeChartData();
  }

  void getStudyTimeChartData(
      {ReviewsTimeRange timeRange = ReviewsTimeRange.month,
      ReviewsMetric metric = ReviewsMetric.reviewsTime}) {
    if (sessions == null) {
      emit(ReviewsDataState.err(err: 'Data not loaded'));
      return;
    }
    int daysInTimeRange = switch (timeRange) {
      ReviewsTimeRange.year => 365,
      ReviewsTimeRange.quarter => 90,
      ReviewsTimeRange.month => 30,
    };
    List<int> studyTime = List<int>.filled(rodsCount, 0);
    List<int> cardsAnswered = List<int>.filled(rodsCount, 0);
    int intervalSize = (daysInTimeRange / rodsCount).round();

    final daysStudied = HashSet<int>();
    final now = DateTime.now();
    for (var session in sessions!) {
      Duration diff = session.startTime!.difference(now);
      int days = diff.inDays.abs();
      if (0 <= days && days <= daysInTimeRange) {
        int interval = (days / intervalSize).floor();
        studyTime[interval] += session.totalDuration.inSeconds;
        cardsAnswered[interval] += session.cardsReviewed;

        if (session.totalDuration.inSeconds > 0) {
          daysStudied.add(days);
        }
      }
    }

    List<BarChartGroupData> data = [];
    double totalTime = 0;
    int totalAnswers = 0;
    for (int i = 0; i < studyTime.length; i++) {
      totalTime += studyTime[i];
      totalAnswers += cardsAnswered[i];

      double timeInMin = studyTime[i] / 60;
      String timeString = timeInMin.toStringAsFixed(2);
      double timeRounded = double.parse(timeString);

      data.add(BarChartGroupData(x: -i * intervalSize, barRods: [
        BarChartRodData(
          toY: metric == ReviewsMetric.reviewsTime
              ? timeRounded
              : cardsAnswered[i].toDouble(),
          color: metric == ReviewsMetric.reviewsTime ? Colors.blue : Colors.red,
        ),
      ]));
    }
    totalTime /= 60;
    data = data.reversed.toList();
    emit(ReviewsDataState.ready(
        barChartData: data,
        totalTime: totalTime,
        totalAnswers: totalAnswers,
        daysStudied: daysStudied.length,
        daysInTimeRange: daysInTimeRange));
  }
}

sealed class ReviewsDataState with EquatableMixin {
  ReviewsDataState();
  factory ReviewsDataState.initial() = ReviewsDataInitialState;
  factory ReviewsDataState.loading() = ReviewsDataLoadingState;
  factory ReviewsDataState.err({required dynamic err}) = ReviewsDataErrorState;
  factory ReviewsDataState.ready(
      {required List<BarChartGroupData> barChartData,
      required int daysStudied,
      required double totalTime,
      required int totalAnswers,
      required int daysInTimeRange}) = ReviewsDataReadyState;
}

class ReviewsDataInitialState extends ReviewsDataState {
  ReviewsDataInitialState();

  @override
  List<Object?> get props => [];
}

class ReviewsDataLoadingState extends ReviewsDataState {
  ReviewsDataLoadingState();

  @override
  List<Object?> get props => [];
}

class ReviewsDataErrorState extends ReviewsDataState {
  ReviewsDataErrorState({required this.err});
  final dynamic err;

  @override
  List<Object?> get props => [err];
}

class ReviewsDataReadyState extends ReviewsDataState {
  ReviewsDataReadyState(
      {required this.barChartData,
      required this.totalTime,
      required this.totalAnswers,
      required this.daysStudied,
      required this.daysInTimeRange});
  final List<BarChartGroupData> barChartData;
  final double totalTime;
  final int totalAnswers;
  final int daysStudied;
  final int daysInTimeRange;
  @override
  List<Object?> get props => barChartData;
}
