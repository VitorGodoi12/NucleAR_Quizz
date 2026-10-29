part of '../home_screen.dart';

mixin _HomeQuizTab on _HomeScreenState {
  Widget _buildQuizPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.m),
      children: [
        const SectionTitle(
          title: 'Escolha seu desafio',
          subtitle: 'Todas as competições estão liberadas para jogar',
        ),
        const SizedBox(height: 14),
        for (final competition in _competitions)
          AnimatedBuilder(
            animation: _progress,
            builder: (context, _) => CompetitionCard(
              competition: competition,
              lastScore: _progress.topicLastScore[competition.id],
              bestScore: _progress.topicBestScore[competition.id],
              onParticipate: () => Navigator.pushNamed(context, AppRoutes.quiz, arguments: competition),
              onLeaderboard: () => Navigator.pushNamed(context, AppRoutes.leaderboard, arguments: LeaderboardRouteArgs(competition: competition)),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _openGeneralLeaderboard,
          icon: const Icon(Icons.leaderboard_rounded),
          label: const Text('Abrir ranking geral'),
        ),
      ],
    );
  }

}
