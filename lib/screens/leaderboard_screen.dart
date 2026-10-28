import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/data/mock_participants.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/models/participant.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';

/// Placar local: combina a pontuação real do usuário com participantes fictícios.
/// Um ranking compartilhado entre dispositivos exige um backend.
class LeaderboardScreen extends StatefulWidget {
  final Competition competition;

  const LeaderboardScreen({super.key, required this.competition});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _showExample = false;

  static const _medalColors = [
    AppColors.gold,
    AppColors.silver,
    AppColors.bronze,
  ];

  @override
  Widget build(BuildContext context) {
    final released =
        widget.competition.resultsReleased ||
        _showExample ||
        AppProgress.instance.totalPoints > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Placar')),
      body: AnimatedBuilder(
        animation: AppProgress.instance,
        builder: (context, _) => released ? _buildBoard() : _buildLocked(),
      ),
    );
  }

  Widget _buildLocked() {
    final competition = widget.competition;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: appCardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: tintOf(competition.color),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_clock_rounded,
                  size: 52,
                  color: competition.color,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                competition.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              const Text(
                'O resultado ainda não está disponível.\nO placar é divulgado somente após o encerramento da competição.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, height: 1.45),
              ),
              const SizedBox(height: AppSpacing.l),
              OutlinedButton.icon(
                onPressed: () => setState(() => _showExample = true),
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('Ver exemplo de placar'),
              ),
              const SizedBox(height: 8),
              const Text(
                'O exemplo usa dados fictícios, apenas para demonstração.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    // Insere o usuário real no ranking local e ordena todos pela pontuação.
    // Os outros participantes continuam sendo exemplos fictícios nesta versão.
    final progress = AppProgress.instance;
    final userName = progress.displayName.trim().isEmpty
        ? 'Você'
        : progress.displayName.trim();
    final ranking =
        <Participant>[
          ...mockParticipants,
          Participant(
            name: userName,
            score: progress.totalPoints,
            isCurrentUser: true,
            avatar: progress.avatar,
          ),
        ]..sort((a, b) {
          final byScore = b.score.compareTo(a.score);
          if (byScore != 0) return byScore;
          if (a.isCurrentUser != b.isCurrentUser) {
            return a.isCurrentUser ? -1 : 1;
          }
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
    final others = ranking.skip(3).toList();
    final userRank =
        ranking.indexWhere((participant) => participant.isCurrentUser) + 1;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      children: [
        GradientHeader(
          child: Column(
            children: [
              const Text(
                'Ranking geral',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Classificação por pontos acumulados',
                style: TextStyle(color: Color(0xFFCFE0F0)),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final i in const [1, 0, 2])
                    Expanded(
                      child: _PodiumColumn(
                        rank: i,
                        participant: ranking[i],
                        height: const [110.0, 84.0, 64.0][i],
                        color: _medalColors[i],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                margin: const EdgeInsets.only(bottom: AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.cyanBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cyan.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_pin_circle_rounded,
                      color: AppColors.blue,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Sua posição: $userRankº lugar • ${progress.totalPoints} pontos',
                        style: const TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < others.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: others[i].isCurrentUser
                        ? AppColors.cyanBg
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: others[i].isCurrentUser
                          ? AppColors.cyan
                          : const Color(0xFFE4EAF1),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: others[i].isCurrentUser
                          ? AppColors.blue
                          : AppColors.cyanBg,
                      child: others[i].isCurrentUser
                          ? Text(
                              others[i].avatar,
                              style: const TextStyle(fontSize: 19),
                            )
                          : Text(
                              '${i + 4}',
                              style: const TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    title: Text(
                      others[i].isCurrentUser
                          ? '${others[i].name} (você)'
                          : others[i].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    trailing: Text(
                      '${others[i].score} pts',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.s),
              const Text(
                'Sua pontuação é real e salva neste dispositivo. Os demais participantes são exemplos; para um ranking compartilhado entre pessoas, é necessário conectar um servidor.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final int rank;
  final Participant participant;
  final double height;
  final Color color;

  const _PodiumColumn({
    required this.rank,
    required this.participant,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.emoji_events_rounded, color: color, size: 36),
        const SizedBox(height: 4),
        Text(
          participant.isCurrentUser
              ? 'Você'
              : participant.name.split(' ').first,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: participant.isCurrentUser ? AppColors.gold : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${participant.score} pts',
          style: const TextStyle(color: Color(0xFFCFE0F0), fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Text(
            '${rank + 1}º',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
