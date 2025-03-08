import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';

class DailyStatsCubit extends Cubit<DailyStatsState> {
  DailyStatsCubit({required this.dataSource})
      : super(DailyStatsState.initial());
  final ActivityHistoryDataSource dataSource;

  Future<void> getDailyStats() async {
    emit(DailyStatsState.loading());
    try {
      final sessions = await dataSource.loadTodaySessions();
      double totalTimeSec = 0;
      int cardsAnswered = 0;
      for (final session in sessions) {
        totalTimeSec += session.totalDuration.inSeconds;
        cardsAnswered += session.cardsReviewed;
      }
      if (cardsAnswered == 0) {
        emit(DailyStatsState.empty());
        return;
      }
      emit(DailyStatsState.ready(
          totalTimeSec: totalTimeSec, cardsAnswered: cardsAnswered,),);
    } catch (err) {
      emit(DailyStatsState.err(err: err));
    }
  }
}

sealed class DailyStatsState with EquatableMixin {
  DailyStatsState();

  factory DailyStatsState.initial() = DailyStatsInitialState;
  factory DailyStatsState.loading() = DailyStatsLoadingState;
  factory DailyStatsState.err({dynamic err}) = DailyStatsErrorState;
  factory DailyStatsState.ready(
      {required double totalTimeSec,
      required int cardsAnswered,}) = DailyStatsReadyState;
  factory DailyStatsState.empty() = DailyStatsEmptyState;
}

class DailyStatsInitialState extends DailyStatsState {
  DailyStatsInitialState();

  @override
  List<Object?> get props => [];
}

class DailyStatsLoadingState extends DailyStatsState {
  DailyStatsLoadingState();

  @override
  List<Object?> get props => [];
}

class DailyStatsErrorState extends DailyStatsState {
  DailyStatsErrorState({this.err});
  final dynamic err;

  @override
  List<Object?> get props => [err];
}

class DailyStatsReadyState extends DailyStatsState {
  DailyStatsReadyState(
      {required this.totalTimeSec, required this.cardsAnswered,});
  final double totalTimeSec;
  final int cardsAnswered;

  @override
  List<Object?> get props => [totalTimeSec, cardsAnswered];
}

class DailyStatsEmptyState extends DailyStatsState {
  DailyStatsEmptyState();

  @override
  List<Object?> get props => [];
}
