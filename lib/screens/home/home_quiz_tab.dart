part of '../home_screen.dart';

mixin _HomeQuizTab on _HomeScreenStateBase {
  Widget _buildQuizPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.m),
      children: [
        const SectionTitle(
          title: 'Escolha seu desafio',
          subtitle: '12 perguntas por tema, 6 por partida. Treine sem cronômetro quando quiser.',
        ),
        const SizedBox(height: 14),
        for (final competition in _competitions)
          Column(
            children: [
              AnimatedBuilder(
                animation: _progress,
                builder: (context, _) => CompetitionCard(
                  competition: competition,
                  lastScore: _progress.topicLastScore[competition.id],
                  bestScore: _progress.topicBestScore[competition.id],
                  onParticipate: () => Navigator.pushNamed(
                    context,
                    AppRoutes.quiz,
                    arguments: competition,
                  ),
                  onLeaderboard: () => Navigator.pushNamed(
                    context,
                    AppRoutes.leaderboard,
                    arguments: LeaderboardRouteArgs(competition: competition),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.quiz,
                    arguments: QuizRouteArgs(
                      competition: competition,
                      trainingMode: true,
                    ),
                  ),
                  icon: const Icon(Icons.school_outlined),
                  label: Text('Treinar sem cronômetro'),
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _openGeneralLeaderboard,
          icon: const Icon(Icons.leaderboard_rounded),
          label: Text('Abrir ranking geral'),
        ),
      ],
    );
  }

}
