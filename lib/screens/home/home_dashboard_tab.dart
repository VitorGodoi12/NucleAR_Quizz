part of '../home_screen.dart';

mixin _HomeDashboardTab on _HomeScreenStateBase {
  Widget _buildTextPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        GradientHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $_displayName!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A tecnologia nuclear está presente na medicina, na produção de alimentos, na indústria e na geração de energia. Explore os conteúdos em seu ritmo e depois pratique o que aprendeu nos desafios.',
                style: TextStyle(color: Color(0xFFCFE0F0), height: 1.4),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _StatBox(value: '${_competitions.length}', label: 'temas'),
                  const SizedBox(width: 10),
                  _StatBox(
                    value:
                        '${_competitions.fold<int>(0, (sum, c) => sum + c.questions.length)}',
                    label: 'perguntas',
                  ),
                  const SizedBox(width: 10),
                  const _StatBox(value: '20s', label: 'por questão'),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: AnimatedBuilder(
            animation: _progress,
            builder: (context, _) {
              final p = _progress;
              final dailyDone = p.answeredToday > AppProgress.dailyGoal
                  ? AppProgress.dailyGoal
                  : p.answeredToday;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: appCardDecoration(context: context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.gold,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sequência: ${p.activeStreak} dia(s)',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Text(
                          'Nível ${p.level}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Missão diária: responda 10 perguntas para manter seu ritmo de aprendizado.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: dailyDone / AppProgress.dailyGoal,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$dailyDone/${AppProgress.dailyGoal} perguntas hoje • ${p.pointsToNextLevel} pts para o próximo nível',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _AchievementChip(
                          icon: Icons.school_rounded,
                          label: 'Primeiro quiz',
                          unlocked: p.quizzesCompleted >= 1,
                        ),
                        _AchievementChip(
                          icon: Icons.star_rounded,
                          label: '100 pontos',
                          unlocked: p.totalPoints >= 100,
                        ),
                        _AchievementChip(
                          icon: Icons.local_fire_department_rounded,
                          label: '3 dias seguidos',
                          unlocked: p.activeStreak >= 3,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.m,
            AppSpacing.m,
            AppSpacing.m,
            0,
          ),
          child: AnimatedBuilder(
            animation: _progress,
            builder: (context, _) => Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.shuffle_rounded,
                    label: 'Quiz aleatório',
                    color: AppColors.cyan,
                    onTap: _openRandomQuiz,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.leaderboard_rounded,
                    label: 'Placar',
                    color: AppColors.gold,
                    onTap: _openGeneralLeaderboard,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.replay_circle_filled_rounded,
                    label:
                        'Revisar (${_progress.reviewItems.length})',
                    color: AppColors.blue,
                    onTap: _progress.reviewItems.isEmpty
                        ? null
                        : _openReview,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Explore por assunto',
                subtitle: 'Abra um tema por vez, aprenda no seu ritmo e depois teste seus conhecimentos.',
              ),
              const SizedBox(height: 12),
              for (final competition in _competitions)
                _TopicPreviewCard(
                  competition: competition,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.topic, arguments: competition),
                ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_rounded, color: AppColors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Dica: depois de estudar, abra a aba Quiz. Se errar uma questão, o app mostrará uma explicação para ajudar você a aprender.',
                        style: TextStyle(height: 1.4, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => setState(() => _tab = 2),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text('Explorar os quizzes'),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
