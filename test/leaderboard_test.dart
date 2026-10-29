import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/data/competition_catalog.dart';
import 'package:nuclear_quizdefinitivo/screens/leaderboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppProgress progress;
  late CompetitionCatalog catalog;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    progress = AppProgress();
    catalog = await CompetitionCatalog.load();
    progress.quizzesCompleted = 0;
    progress.questionsAnswered = 0;
    progress.correctAnswers = 0;
    progress.totalPoints = 0;
    progress.currentStreak = 0;
    progress.lastStudyDay = '';
    progress.displayName = 'Estudante';
    progress.avatar = '🚀';
    progress.topicLastScore.clear();
    progress.topicBestScore.clear();
    progress.topicAttempts.clear();
    progress.topicCorrect.clear();
    progress.reviewItems.clear();
  });

  testWidgets('placar inclui o usuário e ordena pela pontuação total', (
    tester,
  ) async {
    progress.totalPoints = 1500;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: progress),
          Provider.value(value: catalog),
        ],
        child: MaterialApp(
          home: LeaderboardScreen(
            competition: catalog.competitions.first,
            startGeneral: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sua posição: 1º lugar • 1500 pontos'), findsOneWidget);
    expect(find.text('Você'), findsOneWidget);
    expect(find.text('1500 pts'), findsOneWidget);
    expect(find.text('Ranking geral'), findsOneWidget);
  });

  testWidgets('placar abre no tema escolhido e usa a melhor pontuação', (
    tester,
  ) async {
    progress.topicBestScore['medicina'] = 500;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: progress),
          Provider.value(value: catalog),
        ],
        child: MaterialApp(
          home: LeaderboardScreen(competition: catalog.competitions.first),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ranking · Nuclear na Medicina'), findsOneWidget);
    expect(find.text('Sua posição: 1º lugar • 500 pontos'), findsOneWidget);
    expect(find.text('Jogar este quiz'), findsOneWidget);
  });
}
