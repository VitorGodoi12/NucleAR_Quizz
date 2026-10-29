import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/screens/register_screen.dart';
import 'package:nuclear_quizdefinitivo/utils/validators.dart';

String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
late AppProgress progress;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    progress = AppProgress();
    final p = progress;
    p.quizzesCompleted = 0;
    p.questionsAnswered = 0;
    p.correctAnswers = 0;
    p.totalPoints = 0;
    p.currentStreak = 0;
    p.lastStudyDay = '';
    p.dailyDay = '';
    p.dailyAnswered = 0;
    p.topicLastScore.clear();
    p.topicBestScore.clear();
    p.topicAttempts.clear();
    p.topicCorrect.clear();
    p.reviewItems.clear();
  });

  group('Validators', () {
    test('e-mail', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('abc'), isNotNull);
      expect(Validators.email('nome@exemplo.com'), isNull);
    });

    test('senha com no mínimo 6 caracteres', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });

    test('nome com no mínimo 2 caracteres', () {
      expect(Validators.name(null), isNotNull);
      expect(Validators.name(' a '), isNotNull);
      expect(Validators.name('Ana'), isNull);
    });

    test('nome de exibição a partir do e-mail', () {
      expect(Validators.nameFromEmail('maria@exemplo.com'), 'Maria');
    });
  });

  group('AppProgress', () {
    test('missão diária conta apenas perguntas respondidas hoje', () {
      final p = progress;
      p.dailyDay = '2000-1-1';
      p.dailyAnswered = 7;
      expect(p.answeredToday, 0);

      p.recordQuiz(topicId: 'medicina', correct: 3, total: 4, score: 50);
      expect(p.answeredToday, 4);
      p.recordQuiz(topicId: 'medicina', correct: 4, total: 4, score: 80);
      expect(p.answeredToday, 8);
    });

    test('sequência antiga não é exibida', () {
      final p = progress;
      p.currentStreak = 5;
      p.lastStudyDay = '2000-1-1';
      expect(p.activeStreak, 0);

      p.lastStudyDay = _dayKey(DateTime.now());
      expect(p.activeStreak, 5);
    });
  });

  testWidgets('cadastro vazio mostra erros de validação e SnackBar', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    final button = find.widgetWithText(ElevatedButton, 'Criar conta');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    expect(find.text('Informe o nome.'), findsOneWidget);
    expect(find.text('Informe o e-mail.'), findsOneWidget);
    expect(find.text('Informe a senha.'), findsOneWidget);
    expect(find.text('Confirme a senha.'), findsOneWidget);
    expect(
      find.text('Revise os campos destacados em vermelho.'),
      findsOneWidget,
    );
  });
}
