import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

/// Card de uma competição na Home.
class CompetitionCard extends StatelessWidget {
  final Competition competition;
  final VoidCallback onParticipate;
  final VoidCallback onLeaderboard;
  final int? lastScore;
  final int? bestScore;

  const CompetitionCard({
    super.key,
    required this.competition,
    required this.onParticipate,
    required this.onLeaderboard,
    this.lastScore,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    final color = competition.color;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      clipBehavior: Clip.antiAlias,
      decoration: appCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Faixa colorida com ícone, título e tema
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.m),
            color: color,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(competition.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        competition.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tema: ${competition.theme}',
                        style: const TextStyle(color: Color(0xE6FFFFFF)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competition.description,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: lastScore == null
                        ? AppColors.background
                        : tintOf(color),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: lastScore == null
                          ? AppColors.border
                          : color.withAlpha(70),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.history_rounded, color: color, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lastScore == null
                                  ? 'Ainda não jogou este quiz'
                                  : 'Última pontuação: $lastScore pts',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                            if (bestScore != null)
                              Text(
                                'Seu recorde: $bestScore pts',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (lastScore != null)
                        Icon(Icons.check_circle_rounded, color: color),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Você sabia?
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tintOf(color),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_rounded, color: color, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Você sabia? ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              TextSpan(
                                text: competition.curiosity,
                                style: const TextStyle(color: AppColors.text),
                              ),
                            ],
                          ),
                          style: const TextStyle(height: 1.35, fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoPill(
                      icon: Icons.quiz_rounded,
                      label: '${competition.questions.length} perguntas',
                    ),
                    const _InfoPill(
                      icon: Icons.timer_outlined,
                      label: '${Competition.secondsPerQuestion}s por pergunta',
                    ),
                    const _InfoPill(
                      icon: Icons.star_rounded,
                      label:
                          '${Competition.pointsPerCorrect} pts / ${Competition.pointsPerCorrect * 2} pts rápido',
                    ),
                    const _InfoPill(
                      icon: Icons.lock_open_rounded,
                      label: 'Placar desbloqueado',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: color),
                        onPressed: onParticipate,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Participar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: onLeaderboard,
                        icon: const Icon(Icons.leaderboard_rounded),
                        label: const Text('Placar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.blue),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
