import 'package:flutter_test/flutter_test.dart';
import 'package:nuclear_quizdefinitivo/data/competition_catalog.dart';
import 'package:nuclear_quizdefinitivo/data/mock_participants.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CompetitionCatalog catalog;
  setUpAll(() async {
    catalog = await CompetitionCatalog.load();
  });

  test('cada pergunta tem alternativas e uma resposta válida', () {
    for (final competition in catalog.competitions) {
      expect(competition.questions, isNotEmpty);
      for (final question in competition.questions) {
        expect(question.options, isNotEmpty);
        expect(
          question.correctIndex,
          inInclusiveRange(0, question.options.length - 1),
        );
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('cada tema tem 12 perguntas', () {
    for (final competition in catalog.competitions) {
      expect(competition.questions.length, 12, reason: competition.id);
    }
  });

  test('cada quiz tem um ranking de participantes diferente e estável', () {
    List<String> order(String? topic) {
      final list = [...participantsFor(topic)]
        ..sort(
          (a, b) => b.score != a.score
              ? b.score.compareTo(a.score)
              : a.name.compareTo(b.name),
        );
      return list.map((p) => p.name).toList();
    }

    expect(order('medicina'), isNot(order('agricultura')));
    expect(order('industria'), isNot(order('energia')));
    expect(order('medicina'), order('medicina'));
    for (final p in participantsFor('medicina')) {
      expect(p.score, inInclusiveRange(20, 110));
    }
  });

  test('quiz usa 40 segundos por pergunta', () {
    expect(Competition.secondsPerQuestion, 40);
  });

  test(
    'mural possui participantes fictícios suficientes e placares liberados',
    () {
      expect(mockParticipants.length, greaterThanOrEqualTo(10));
      expect(
        catalog.competitions.every(
          (competition) => competition.resultsReleased,
        ),
        isTrue,
      );
    },
  );
}
