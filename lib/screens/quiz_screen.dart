import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/models/question.dart';
import 'package:nuclear_quizdefinitivo/screens/result_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/answer_option.dart';

/// Tela 4: quiz. Usa StatefulWidget + setState() para atualizar a interface.
class QuizScreen extends StatefulWidget {
  final Competition competition;

  const QuizScreen({super.key, required this.competition});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // ----- ESTADO: quando algo aqui muda dentro de setState(), a tela é redesenhada.
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _correctCount = 0;
  int _score = 0;
  int _pointsEarnedForCurrent = 0;
  int _secondsLeft = Competition.secondsPerQuestion;
  bool _isFinishing = false;
  final List<WrongAnswer> _wrongAnswers = [];
  Timer? _timer;

  List<Question> get _questions => widget.competition.questions;
  Question get _question => _questions[_currentIndex];
  bool get _isLast => _currentIndex == _questions.length - 1;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = Competition.secondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        _confirm(timeout: true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  /// Pergunta antes de abandonar o quiz (evita perder a tentativa sem querer).
  Future<void> _askExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.exit_to_app_rounded,
          color: AppColors.error,
          size: 40,
        ),
        title: const Text('Sair do quiz?'),
        content: const Text('Sua pontuação desta tentativa será perdida.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Continuar jogando'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.pop(context);
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() => _selectedIndex = index);
  }

  void _confirm({bool timeout = false}) {
    if (_answered) return;
    _timer?.cancel();

    final chosen = timeout ? null : _selectedIndex;
    final isCorrect = chosen == _question.correctIndex;
    // Pontuação estilo Kahoot: 20 pontos se acertar nos primeiros 25s;
    // depois disso, ainda ganha os 10 pontos-base por acerto.
    final pointsEarned = isCorrect
        ? (_secondsLeft >= Competition.secondsPerQuestion - 25
              ? Competition.pointsPerCorrect * 2
              : Competition.pointsPerCorrect)
        : 0;

    setState(() {
      _pointsEarnedForCurrent = pointsEarned;
      _score += pointsEarned;
      _answered = true;
      if (timeout) {
        _secondsLeft = 0;
        _selectedIndex = null;
      }
      if (isCorrect) {
        _correctCount++;
      } else {
        _wrongAnswers.add(
          WrongAnswer(question: _question, chosenIndex: chosen),
        );
      }
    });
  }

  void _next() {
    if (!_answered || _isFinishing) return;

    if (_isLast) {
      // Evita contabilizar a tentativa novamente durante a troca de rota.
      _isFinishing = true;
      AppProgress.instance.recordQuiz(
        topicId: widget.competition.id,
        correct: _correctCount,
        total: _questions.length,
        score: _score,
        wrongAnswers: _wrongAnswers,
      );
      // Passagem de parâmetros: resultado desta tentativa vai para a tela de resultado.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            competition: widget.competition,
            correctCount: _correctCount,
            score: _score,
            wrongAnswers: _wrongAnswers,
          ),
        ),
      );
    } else {
      // Reinicia o cronômetro ANTES do setState: assim a interface já mostra
      // 30s na nova pergunta (antes exibia o tempo antigo por 1 segundo).
      _startTimer();
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _answered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final competition = widget.competition;
    final total = _questions.length;
    final progress = (_currentIndex + (_answered ? 1 : 0)) / total;
    final lowTime = _secondsLeft <= 5 && !_answered;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _askExit();
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(competition.title),
        backgroundColor: competition.color,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Faixa de progresso, tempo e pontos
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.m,
                AppSpacing.m,
                AppSpacing.m,
                20,
              ),
              decoration: BoxDecoration(
                color: competition.color,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Pergunta ${_currentIndex + 1} de $total',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        label: '${_secondsLeft}s',
                        color: lowTime ? AppColors.error : AppColors.navy,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.star_rounded,
                        label: '$_score pts',
                        color: AppColors.navy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: const Color(0x40FFFFFF),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.m),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.035, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Column(
                    key: ValueKey<int>(_currentIndex),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: appCardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  competition.icon,
                                  size: 18,
                                  color: competition.color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  competition.theme.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: competition.color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _question.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      for (int i = 0; i < _question.options.length; i++)
                        AnswerOption(
                          letter: String.fromCharCode(65 + i),
                          text: _question.options[i],
                          selected: _selectedIndex == i,
                          showCorrect: _answered && i == _question.correctIndex,
                          showWrong:
                              _answered &&
                              _selectedIndex == i &&
                              i != _question.correctIndex,
                          onTap: _answered ? null : () => _selectOption(i),
                        ),
                      if (_answered)
                        AnimatedScale(
                          scale: 1,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          child: _buildFeedback(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.m,
                  0,
                  AppSpacing.m,
                  AppSpacing.m,
                ),
                child: _answered
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: competition.color,
                        ),
                        onPressed: _next,
                        child: Text(
                          _isLast ? 'Ver resultado' : 'Próxima pergunta',
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: competition.color,
                        ),
                        onPressed: _selectedIndex == null
                            ? null
                            : () => _confirm(),
                        child: const Text('Confirmar resposta'),
                      ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildFeedback() {
    final wasCorrect = _selectedIndex == _question.correctIndex;
    final timedOut = _selectedIndex == null;
    final correctText = _question.options[_question.correctIndex];

    final Color color = wasCorrect ? AppColors.success : AppColors.error;
    final Color background = wasCorrect
        ? AppColors.successBg
        : AppColors.errorBg;
    final String title = wasCorrect
        ? 'Correto! +$_pointsEarnedForCurrent pontos${_pointsEarnedForCurrent > Competition.pointsPerCorrect ? ' — bônus de rapidez!' : ''}'
        : (timedOut ? 'Tempo esgotado!' : 'Resposta incorreta');
    final String body = wasCorrect
        ? (_pointsEarnedForCurrent > Competition.pointsPerCorrect
              ? 'Resposta rápida! Você acertou em até 25 segundos e dobrou os pontos desta pergunta.'
              : 'Muito bem! Você ganhou os pontos-base. Respostas corretas nos primeiros 25 segundos valem o dobro.')
        : 'Resposta certa: $correctText\n\n${_question.explanation}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            wasCorrect ? Icons.celebration_rounded : Icons.info_outline_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(color: AppColors.text, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
