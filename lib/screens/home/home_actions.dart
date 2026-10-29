part of '../home_screen.dart';

mixin _HomeActions on _HomeScreenStateBase {
  void _openRandomQuiz() {
    final competition = _competitions[Random().nextInt(
      _competitions.length,
    )];
    Navigator.pushNamed(context, AppRoutes.quiz, arguments: competition);
  }

  void _openGeneralLeaderboard() {
    Navigator.pushNamed(
      context,
      AppRoutes.leaderboard,
      arguments: LeaderboardRouteArgs(
        competition: _competitions.first,
        startGeneral: true,
      ),
    );
  }

  void _openReview() {
    Navigator.pushNamed(context, AppRoutes.review);
  }
}
