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
    final startDate = DateTime(now.year - 1, now.month, now.day);
    final Filter filter = Filter.and(Filter('startTime', isNull: false),
        Filter('startTime', isGreaterThan: startDate.toIso8601String()));
    return await _getStudySessionsWhere(filter);
  }
}
