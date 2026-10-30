import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/routes/app_routes.dart';
import 'package:nuclear_quizdefinitivo/models/question.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/answer_option.dart';

/// Tela 6: quiz. Usa StatefulWidget + setState() para atualizar a interface.
class QuizScreen extends StatefulWidget {
  final Competition competition;
  final bool trainingMode;

  const QuizScreen({
    super.key,
    required this.competition,
    this.trainingMode = false,
  });

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
  bool _allowPop = false;
  bool _exitPromptOpen = false;
  final List<WrongAnswer> _wrongAnswers = [];
  Timer? _timer;
  final Random _random = Random();
  late Competition _sessionCompetition;

  List<Question> get _questions => _sessionCompetition.questions;
  Question get _question => _questions[_currentIndex];
  bool get _isLast => _currentIndex == _questions.length - 1;

  @override
  void initState() {
    super.initState();
    final shuffledQuestions = [...widget.competition.questions]
      ..shuffle(_random);
    _sessionCompetition = widget.competition.withQuestions(
      shuffledQuestions
          .take(min(Competition.questionsPerMatch, shuffledQuestions.length))
          .map(_shuffleOptions)
          .toList(growable: false),
    );
    _startTimer();
  }

  Question _shuffleOptions(Question question) {
    final order = List<int>.generate(question.options.length, (index) => index)
      ..shuffle(_random);
    return Question(
      text: question.text,
      options: [for (final index in order) question.options[index]],
      correctIndex: order.indexOf(question.correctIndex),
      explanation: question.explanation,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = Competition.secondsPerQuestion;
    if (widget.trainingMode) return;
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
    if (_exitPromptOpen || _allowPop) return;
    _exitPromptOpen = true;
    bool? leave;
    try {
      leave = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: Icon(
            Icons.exit_to_app_rounded,
            color: semanticStatusColor(context, success: false),
            size: 40,
          ),
          title: Text('Sair do quiz?'),
          content: Text('Sua pontuação desta tentativa será perdida.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text('Continuar jogando'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('Sair'),
            ),
          ],
        ),
      );
    } finally {
      _exitPromptOpen = false;
    }
    if (leave != true || !mounted) return;

    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
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
    // O modo cronometrado dobra os pontos nos primeiros 35 segundos.
    final pointsEarned = isCorrect
        ? (!widget.trainingMode &&
                  _secondsLeft >=
                      Competition.secondsPerQuestion -
                          Competition.doublePointsWindowSeconds
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
      context.read<AppProgress>().recordQuiz(
        topicId: widget.competition.id,
        correct: _correctCount,
        total: _questions.length,
        score: _score,
        wrongAnswers: _wrongAnswers,
      );
      // Passagem de parâmetros: resultado desta tentativa vai para a tela de resultado.
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.result,
        arguments: ResultRouteArgs(
          competition: _sessionCompetition,
          sourceCompetition: widget.competition,
          trainingMode: widget.trainingMode,
          correctCount: _correctCount,
          score: _score,
          wrongAnswers: List.unmodifiable(_wrongAnswers),
        ),
      );
    } else {
      // Reinicia o cronômetro antes do setState para mostrar o tempo completo
      // junto com a próxima pergunta.
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
    final competition = _sessionCompetition;
    final total = _questions.length;
    final progress = (_currentIndex + (_answered ? 1 : 0)) / total;
    final lowTime = !widget.trainingMode && _secondsLeft <= 5 && !_answered;

    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _askExit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.trainingMode
                ? '${competition.title} · Treino'
                : competition.title,
          ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        if (!widget.trainingMode) ...[
                          _InfoChip(
                            icon: Icons.timer_outlined,
                            label: '${_secondsLeft}s',
                            color: lowTime ? AppColors.error : AppColors.navy,
                          ),
                          const SizedBox(width: 8),
                        ],
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
                          decoration: appCardDecoration(context: context),
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
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
                            showCorrect:
                                _answered && i == _question.correctIndex,
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
                          child: Text('Confirmar resposta'),
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

    final Color color = semanticStatusColor(context, success: wasCorrect);
    final Color background = tintOf(context, color);
    final String title = wasCorrect
        ? 'Correto! +$_pointsEarnedForCurrent pontos${_pointsEarnedForCurrent > Competition.pointsPerCorrect ? ' — bônus de rapidez!' : ''}'
        : (timedOut ? 'Tempo esgotado!' : 'Resposta incorreta');
    final String body = wasCorrect
        ? (widget.trainingMode
              ? 'Muito bem! Você ganhou os pontos-base no modo treino.'
              : _pointsEarnedForCurrent > Competition.pointsPerCorrect
              ? 'Resposta rápida! Você acertou nos primeiros ${Competition.doublePointsWindowSeconds} segundos e dobrou os pontos desta pergunta.'
              : 'Muito bem! Você ganhou os pontos-base. Responda nos primeiros ${Competition.doublePointsWindowSeconds} segundos para receber o dobro.')
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
                  wasCorrect ? '$body\n\n${_question.explanation}' : body,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.35,
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
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? (color == AppColors.error
                      ? semanticStatusColor(context, success: false)
                      : Theme.of(context).colorScheme.primary)
                : color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
