import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nuclear_quizdefinitivo/models/question.dart';

/// Progresso persistido localmente no dispositivo; não é enviado a um servidor.
class AppProgress extends ChangeNotifier {
  AppProgress._();
  static final AppProgress instance = AppProgress._();
  static const _storageKey = 'nuclear_quiz_progress_v2';

  int quizzesCompleted = 0;
  int questionsAnswered = 0;
  int correctAnswers = 0;
  int totalPoints = 0;
  int currentStreak = 0;
  String lastStudyDay = '';
  String displayName = '';
  String avatar = '🚀';
  String themeMode = 'Sistema';
  final Map<String, int> topicLastScore = {};
  final Map<String, int> topicBestScore = {};
  final Map<String, int> topicAttempts = {};
  final Map<String, int> topicCorrect = {};
  final List<Map<String, dynamic>> reviewItems = [];

  double get accuracy =>
      questionsAnswered == 0 ? 0 : correctAnswers / questionsAnswered;
  int get level => 1 + (totalPoints ~/ 100);
  int get pointsToNextLevel => 100 - (totalPoints % 100);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      quizzesCompleted = data['quizzesCompleted'] ?? 0;
      questionsAnswered = data['questionsAnswered'] ?? 0;
      correctAnswers = data['correctAnswers'] ?? 0;
      totalPoints = data['totalPoints'] ?? 0;
      currentStreak = data['currentStreak'] ?? 0;
      lastStudyDay = data['lastStudyDay'] ?? '';
      displayName = data['displayName'] ?? '';
      avatar = data['avatar'] ?? '🚀';
      themeMode = data['themeMode'] ?? 'Sistema';
      _readMap(data['topicLastScore'], topicLastScore);
      _readMap(data['topicBestScore'], topicBestScore);
      _readMap(data['topicAttempts'], topicAttempts);
      _readMap(data['topicCorrect'], topicCorrect);
      reviewItems
        ..clear()
        ..addAll(
          ((data['reviewItems'] as List?) ?? []).whereType<Map>().map(
            (e) => Map<String, dynamic>.from(e),
          ),
        );
      notifyListeners();
    } catch (_) {
      // Um arquivo de preferências inválido não deve impedir a abertura do app.
    }
  }

  Future<void> updateProfile({
    String? name,
    String? avatarValue,
    String? theme,
  }) async {
    if (name != null) displayName = name;
    if (avatarValue != null) avatar = avatarValue;
    if (theme != null) themeMode = theme;
    await _save();
  }

  void recordQuiz({
    required String topicId,
    required int correct,
    required int total,
    required int score,
    List<WrongAnswer> wrongAnswers = const [],
  }) {
    quizzesCompleted++;
    questionsAnswered += total;
    correctAnswers += correct;
    totalPoints += score;
    topicLastScore[topicId] = score;
    if (score > (topicBestScore[topicId] ?? 0)) topicBestScore[topicId] = score;
    topicAttempts[topicId] = (topicAttempts[topicId] ?? 0) + total;
    topicCorrect[topicId] = (topicCorrect[topicId] ?? 0) + correct;
    final today = _dayKey(DateTime.now());
    if (lastStudyDay != today) {
      final yesterday = _dayKey(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      currentStreak = lastStudyDay == yesterday ? currentStreak + 1 : 1;
      lastStudyDay = today;
    }
    for (final wrong in wrongAnswers) {
      final item = <String, dynamic>{
        'topicId': topicId,
        'text': wrong.question.text,
        'options': wrong.question.options,
        'correctIndex': wrong.question.correctIndex,
        'explanation': wrong.question.explanation,
      };
      reviewItems.removeWhere(
        (e) => e['topicId'] == topicId && e['text'] == wrong.question.text,
      );
      reviewItems.insert(0, item);
    }
    if (reviewItems.length > 100) {
      reviewItems.removeRange(100, reviewItems.length);
    }
    _save();
  }

  void removeReviewItem(Map<String, dynamic> item) {
    reviewItems.remove(item);
    _save();
  }

  static String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
  void _readMap(dynamic source, Map<String, int> target) {
    target.clear();
    if (source is Map) {
      source.forEach((k, v) {
        if (v is num) {
          target[k.toString()] = v.toInt();
        }
      });
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode({
        'quizzesCompleted': quizzesCompleted,
        'questionsAnswered': questionsAnswered,
        'correctAnswers': correctAnswers,
        'totalPoints': totalPoints,
        'currentStreak': currentStreak,
        'lastStudyDay': lastStudyDay,
        'displayName': displayName,
        'avatar': avatar,
        'themeMode': themeMode,
        'topicLastScore': topicLastScore,
        'topicBestScore': topicBestScore,
        'topicAttempts': topicAttempts,
        'topicCorrect': topicCorrect,
        'reviewItems': reviewItems,
      }),
    );
    notifyListeners();
  }
}
