import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'study_session.g.dart';

@JsonSerializable()
class StudySession {
  StudySession({required this.sessionId, required this.deckId});
  final String sessionId;
  final String deckId;
  final _stopwatch = Stopwatch();
  DateTime? startTime;
  Duration totalDuration = Duration.zero;
  int cardsReviewed = 0;

  StudySession.create({required String deckId})
      : this(
          sessionId: Uuid().v8(),
          deckId: deckId,
        );

  factory StudySession.fromJson(Map<String, dynamic> json) =>
      _$StudySessionFromJson(json);

  Map<String, dynamic> toJson() => _$StudySessionToJson(this);

  void startSession() {
    startTime = DateTime.now();
    _stopwatch.start();
  }

  void suspendSession() {
    _stopwatch.stop();
  }

  void continueSession() {
    _stopwatch.start();
  }

  void endSession() {
    if (startTime == null) {
      return;
    }
    _stopwatch.stop();
    totalDuration = _stopwatch.elapsed;
  }

  void reviewCard() {
    cardsReviewed += 1;
  }
}
