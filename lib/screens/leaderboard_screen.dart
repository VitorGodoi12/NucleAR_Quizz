import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/data/mock_competitions.dart';
import 'package:nuclear_quizdefinitivo/data/mock_participants.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/models/participant.dart';
import 'package:nuclear_quizdefinitivo/screens/quiz_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';

/// Placar local: combina a pontuação real do usuário com participantes fictícios.
/// Pode ser filtrado por tema (melhor pontuação) ou exibir o ranking geral.
/// Um ranking compartilhado entre dispositivos exige um backend.
class LeaderboardScreen extends StatefulWidget {
  final Competition competition;

  /// Quando verdadeiro abre no ranking geral; senão, no tema de [competition].
  final bool startGeneral;

  const LeaderboardScreen({
    super.key,
    required this.competition,
    this.startGeneral = false,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  /// Tema selecionado; nulo = ranking geral.
  late String? _topicId = widget.startGeneral ? null : widget.competition.id;

  static const _medalColors = [
    AppColors.gold,
    AppColors.silver,
    AppColors.bronze,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Placar')),
      body: AnimatedBuilder(
        animation: AppProgress.instance,
        builder: (context, _) => _buildBoard(),
      ),
    );
  }

  Widget _filterChip(
    String label,
    IconData icon,
    Color color,
    bool selected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 18, color: selected ? Colors.white : color),
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: color,
        backgroundColor: Colors.white,
        side: BorderSide(color: selected ? color : AppColors.border),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.text,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _buildBoard() {
    final progress = AppProgress.instance;
    final Competition? topic = _topicId == null
        ? null
        : mockCompetitions.firstWhere((c) => c.id == _topicId);
    final userScore = topic == null
        ? progress.totalPoints
        : (progress.topicBestScore[topic.id] ?? 0);
    final userName = progress.displayName.trim().isEmpty
        ? 'Você'
        : progress.displayName.trim();

    // Reúne os participantes na pontuação do filtro atual e ordena.
    final ranking = <Participant>[
      ...participantsFor(_topicId),
      Participant(
        name: userName,
        score: userScore,
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

    String hint;
    if (userScore == 0) {
      hint = topic == null
          ? 'Complete um quiz para entrar na disputa.'
          : 'Jogue o quiz deste tema para entrar na disputa.';
    } else if (userRank == 1) {
      hint = 'Você lidera o ranking!';
    } else {
      final gap = ranking[userRank - 2].score - userScore;
      hint = 'Faltam $gap pts para alcançar o ${userRank - 1}º lugar.';
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      children: [
        GradientHeader(
          child: Column(
            children: [
              Text(
                topic == null ? 'Ranking geral' : 'Ranking · ${topic.title}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                topic == null
                    ? 'Classificação por pontos acumulados'
                    : 'Classificação pela melhor pontuação no tema',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFCFE0F0)),
              ),
              const SizedBox(height: AppSpacing.m),
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
        const SizedBox(height: AppSpacing.m),
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            children: [
              _filterChip(
                'Geral',
                Icons.public_rounded,
                AppColors.navy,
                _topicId == null,
                () => setState(() => _topicId = null),
              ),
              for (final c in mockCompetitions)
                _filterChip(
                  c.theme,
                  c.icon,
                  c.color,
                  _topicId == c.id,
                  () => setState(() => _topicId = c.id),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_pin_circle_rounded,
                          color: AppColors.blue,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Sua posição: $userRankº lugar • $userScore pontos',
                            style: const TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hint,
                      style: const TextStyle(color: AppColors.text, height: 1.35),
                    ),
                    if (topic != null) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: topic.color,
                          minimumSize: const Size.fromHeight(46),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(competition: topic),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Jogar este quiz'),
                      ),
                    ],
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
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 26,
                          child: Text(
                            '${i + 4}º',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: others[i].isCurrentUser
                              ? AppColors.blue
                              : AppColors.cyanBg,
                          child: Text(
                            others[i].avatar,
                            style: const TextStyle(fontSize: 19),
                          ),
                        ),
                      ],
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
        rank == 0
            ? const Icon(
                Icons.workspace_premium_rounded,
                color: AppColors.gold,
                size: 30,
              )
            : const SizedBox(height: 30),
        const SizedBox(height: 4),
        Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: Text(participant.avatar, style: const TextStyle(fontSize: 26)),
        ),
        const SizedBox(height: 6),
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
