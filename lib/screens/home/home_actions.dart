part of '../home_screen.dart';

mixin _HomeActions on _HomeScreenStateBase {
  @override
  void _openRandomQuiz() {
    final competition = _competitions[_randomIndex(_competitions.length)];
    Navigator.pushNamed(context, AppRoutes.quiz, arguments: competition);
  }

  @override
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

  @override
  void _openReview() {
    Navigator.pushNamed(context, AppRoutes.review);
  }
}
