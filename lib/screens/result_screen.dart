import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/models/question.dart';
import 'package:nuclear_quizdefinitivo/screens/leaderboard_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/quiz_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';
import 'package:nuclear_quizdefinitivo/widgets/section_title.dart';

/// Tela 5: resultado e aprendizado (explicações das respostas incorretas).
class ResultScreen extends StatelessWidget {
  final Competition competition;
  final int correctCount;
  final int score;
  final List<WrongAnswer> wrongAnswers;

  const ResultScreen({
    super.key,
    required this.competition,
    required this.correctCount,
    required this.score,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final total = competition.questions.length;
    final ratio = correctCount / total;

    String title;
    String subtitle;
    if (ratio >= 0.75) {
      title = 'Excelente!';
      subtitle = 'Você domina o tema.';
    } else if (ratio >= 0.5) {
      title = 'Bom trabalho!';
      subtitle = 'Veja as explicações abaixo para aprender ainda mais.';
    } else {
      title = 'Continue aprendendo!';
      subtitle = 'As explicações abaixo ajudam a entender o tema.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.l),
        children: [
          GradientHeader(
            child: Column(
              children: [
                Text(
                  competition.title,
                  style: const TextStyle(
                    color: Color(0xFFCFE0F0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: ratio,
                        strokeWidth: 11,
                        backgroundColor: const Color(0x33FFFFFF),
                        color: AppColors.gold,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$score',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'pontos',
                              style: TextStyle(color: Color(0xFFCFE0F0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFCFE0F0), height: 1.4),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.s),
                Row(
                  children: [
                    _StatTile(
                      icon: Icons.star_rounded,
                      label: 'Pontos',
                      value: '$score',
                      color: AppColors.blue,
                    ),
                    const SizedBox(width: 12),
                    _StatTile(
                      icon: Icons.check_circle_rounded,
                      label: 'Acertos',
                      value: '$correctCount',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    _StatTile(
                      icon: Icons.cancel_rounded,
                      label: 'Erros',
                      value: '${wrongAnswers.length}',
                      color: AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
                if (wrongAnswers.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_rounded, color: AppColors.success),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Você acertou todas as perguntas! Não há explicações de erros para mostrar.',
                            style: TextStyle(
                              color: AppColors.text,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  const SectionTitle(
                    title: 'Aprenda com os erros',
                    subtitle: 'Entenda cada pergunta que você errou',
                  ),
                  const SizedBox(height: AppSpacing.m),
                  for (final wrong in wrongAnswers)
                    _WrongAnswerCard(wrong: wrong, color: competition.color),
                ],
                const SizedBox(height: AppSpacing.m),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: competition.color,
                  ),
                  // Troca a rota: o botão "voltar" do novo quiz leva à Home.
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(competition: competition),
                    ),
                  ),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Jogar novamente'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LeaderboardScreen(competition: competition),
                      ),
                    );
                  },
                  icon: const Icon(Icons.leaderboard_rounded),
                  label: const Text('Ver placar'),
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  // Home é a primeira rota da pilha, então voltamos até ela.
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Voltar ao início'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: appCardDecoration(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: tintOf(color),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _WrongAnswerCard extends StatelessWidget {
  final WrongAnswer wrong;
  final Color color;

  const _WrongAnswerCard({required this.wrong, required this.color});

  @override
  Widget build(BuildContext context) {
    final question = wrong.question;
    final chosen = wrong.chosenIndex;
    final chosenText = chosen == null
        ? 'Tempo esgotado (sem resposta)'
        : question.options[chosen];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: appCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.text,
              height: 1.4,
              fontSize: 15.5,
            ),
          ),
          const SizedBox(height: 12),
          _AnswerLine(
            icon: Icons.cancel_rounded,
            color: AppColors.error,
            label: 'Sua resposta',
            text: chosenText,
          ),
          const SizedBox(height: 6),
          _AnswerLine(
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            label: 'Resposta correta',
            text: question.options[question.correctIndex],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tintOf(color),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.explanation,
                    style: const TextStyle(color: AppColors.text, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String text;

  const _AnswerLine({
    required this.icon,
    required this.color,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                TextSpan(
                  text: text,
                  style: const TextStyle(color: AppColors.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
