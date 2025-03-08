import 'package:memo_deck/features/activity_tracker/data/activity_history_data_source.dart';

import '../../../shared/models/study_session.dart';

class StudySessionManager {
  StudySessionManager({required this.dataSource});
  final ActivityHistoryDataSource dataSource;
  StudySession? session;

  void startNewSession(String deckId) {
    if (session != null) {
      endSession();
    }
    session = StudySession.create(deckId: deckId);
    session!.startSession();
  }

  void suspendSession() {
    session?.suspendSession();
  }

  void continueSession() {
    session?.continueSession();
  }

  void endSession() {
    if (session == null) {
      return;
    }
    session!.endSession();
    if (session!.totalDuration > const Duration(seconds: 10)) {
      dataSource.saveSession(session!);
    }
    session = null;
  }

  void reviewCard() {
    session!.reviewCard();
  }
}
