import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:memo_deck/shared/models/study_session.dart';

class ActivityHistoryDataSource {
  ActivityHistoryDataSource(
      {required this.authService, required this.firestore});
  final FirebaseAuth authService;
  final FirebaseFirestore firestore;
  CollectionReference<Map<String, dynamic>> get _history => firestore
      .collection('users')
      .doc(authService.currentUser!.uid)
      .collection('history');

  List<StudySession> _parseStudySessions(List<Map<String, dynamic>> rawData) {
    return rawData.map((doc) => StudySession.fromJson(doc)).toList();
  }

  void saveSession(StudySession session) {
    _history.doc(session.sessionId).set(session.toJson());
  }

  Future<List<StudySession>> _getStudySessionsWhere(Filter filter) async {
    try {
      QuerySnapshot<Map<String, dynamic>> res =
          await _history.where(filter).get();
      List<Map<String, dynamic>> rawData =
          res.docs.map((doc) => doc.data()).toList();
      return await compute(_parseStudySessions, rawData);
    } catch (e) {
      throw 'Failed to load study sessions: $e';
    }
  }

  Future<List<StudySession>> loadStudySessionsWithinLastYear() async {
    final now = DateTime.now();
    final startDate =
        DateTime(now.year - 1, now.month, now.day).toIso8601String();
    final Filter filter = Filter.and(Filter('startTime', isNull: false),
        Filter('startTime', isGreaterThan: startDate));
    return await _getStudySessionsWhere(filter);
  }

  Future<List<StudySession>> loadTodaySessions() async {
    final now = DateTime.now();
    final lastMidnight = DateTime(
      now.year,
      now.month,
      now.day,
    ).toIso8601String();
    final nextMidnight = DateTime(
      now.year,
      now.month,
      now.day + 1,
    ).toIso8601String();

    final nullFilter = Filter('startTime', isNull: false);
    final timeIntervalFilter = Filter.and(
        Filter('startTime', isGreaterThan: lastMidnight),
        Filter('startTime', isLessThan: nextMidnight));

    final filter = Filter.and(nullFilter, timeIntervalFilter);
    return await _getStudySessionsWhere(filter);
  }
}
