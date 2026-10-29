import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/models/question.dart';

class Competition {
  static const int secondsPerQuestion = 30;
  static const int pointsPerCorrect = 10;

  final String id;
  final String title;
  final String theme;
  final String description;
  final String curiosity;
  final IconData icon;
  final Color color;
  final List<Question> questions;

  /// Simula se a competição já foi encerrada e o placar liberado.
  final bool resultsReleased;

  const Competition({
    required this.id,
    required this.title,
    required this.theme,
    required this.description,
    required this.curiosity,
    required this.icon,
    required this.color,
    required this.questions,
    this.resultsReleased = false,
  });

  Competition withQuestions(List<Question> loadedQuestions) => Competition(
    id: id,
    title: title,
    theme: theme,
    description: description,
    curiosity: curiosity,
    icon: icon,
    color: color,
    questions: loadedQuestions,
    resultsReleased: resultsReleased,
  );
}
