import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/models/question.dart';
import 'package:nuclear_quizdefinitivo/screens/home_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/leaderboard_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/login_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/quiz_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/register_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/result_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/review_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/topic_detail_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/welcome_screen.dart';

abstract final class AppRoutes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const topic = '/topic';
  static const quiz = '/quiz';
  static const result = '/result';
  static const leaderboard = '/leaderboard';
  static const review = '/review';

  static Route<dynamic> onGenerate(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      topic => TopicDetailScreen(
        competition: _argument<Competition>(settings),
      ),
      quiz => QuizScreen(competition: _argument<Competition>(settings)),
      result => _resultPage(settings),
      leaderboard => _leaderboardPage(settings),
      review => const ReviewScreen(),
      _ => const _UnknownRouteScreen(),
    };
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }

  static Widget _resultPage(RouteSettings settings) {
    final args = _argument<ResultRouteArgs>(settings);
    return ResultScreen(
      competition: args.competition,
      correctCount: args.correctCount,
      score: args.score,
      wrongAnswers: args.wrongAnswers,
    );
  }

  static Widget _leaderboardPage(RouteSettings settings) {
    final args = _argument<LeaderboardRouteArgs>(settings);
    return LeaderboardScreen(
      competition: args.competition,
      startGeneral: args.startGeneral,
    );
  }

  static T _argument<T>(RouteSettings settings) {
    final value = settings.arguments;
    if (value is T) return value;
    throw ArgumentError.value(
      value,
      'settings.arguments',
      'Argumento inválido para a rota ${settings.name}.',
    );
  }
}

class ResultRouteArgs {
  const ResultRouteArgs({
    required this.competition,
    required this.correctCount,
    required this.score,
    required this.wrongAnswers,
  });

  final Competition competition;
  final int correctCount;
  final int score;
  final List<WrongAnswer> wrongAnswers;
}

class LeaderboardRouteArgs {
  const LeaderboardRouteArgs({
    required this.competition,
    this.startGeneral = false,
  });

  final Competition competition;
  final bool startGeneral;
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Página não encontrada')),
    body: Center(
      child: FilledButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.welcome,
          (_) => false,
        ),
        child: const Text('Voltar ao início'),
      ),
    ),
  );
}
