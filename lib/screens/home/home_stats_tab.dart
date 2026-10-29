part of '../home_screen.dart';

mixin _HomeStatsTab on _HomeScreenStateBase {
  Widget _buildStatsPage() {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        final progress = _progress;
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.insights_rounded,
                    color: AppColors.cyan,
                    size: 34,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Seu progresso em números',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cada tentativa ajuda você a aprender um pouco mais.',
                    style: TextStyle(color: Color(0xFFD8E7F5), height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _StatBox(
                        value: '${progress.totalPoints}',
                        label: 'pontos',
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        value: '${progress.quizzesCompleted}',
                        label: 'quizzes',
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        value: '${(progress.accuracy * 100).round()}%',
                        label: 'acertos',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: appCardDecoration(context: context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.replay_circle_filled_rounded,
                        color: AppColors.cyan,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Revisar questões erradas (${progress.reviewItems.length})',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pratique novamente as perguntas que você errou e releia as explicações.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: progress.reviewItems.isEmpty
                        ? null
                        : _openReview,
                    icon: const Icon(Icons.menu_book_rounded),
                    label: Text('Abrir revisão'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const SectionTitle(
              title: 'Desempenho por assunto',
              subtitle: 'Veja onde você já praticou e o que pode revisar.',
            ),
            const SizedBox(height: 12),
            for (final topic in _competitions) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: appCardDecoration(context: context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(topic.icon, color: topic.color),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            topic.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Text(
                          '${_progress.topicCorrect[topic.id] ?? 0}/${_progress.topicAttempts[topic.id] ?? 0}',
                          style: TextStyle(
                            color: topic.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value:
                            (_progress.topicAttempts[topic.id] ??
                                    0) ==
                                0
                            ? 0
                            : (_progress.topicCorrect[topic.id] ??
                                      0) /
                                  (_progress.topicAttempts[topic
                                          .id] ??
                                      1),
                        minHeight: 8,
                        backgroundColor: tintOf(topic.color),
                        color: topic.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (progress.quizzesCompleted == 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Suas estatísticas aparecerão aqui depois que você concluir seu primeiro quiz.',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, height: 1.4),
                ),
              ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => setState(() => _tab = 4),
              icon: const Icon(Icons.person_outline),
              label: Text('Personalizar meu perfil'),
            ),
          ],
        );
      },
    );
  }

}
