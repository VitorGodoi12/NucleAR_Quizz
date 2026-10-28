import 'package:flutter_test/flutter_test.dart';
import 'package:nuclear_quizdefinitivo/data/mock_competitions.dart';
import 'package:nuclear_quizdefinitivo/data/mock_participants.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';

void main() {
  test('cada pergunta tem alternativas e uma resposta válida', () {
    for (final competition in mockCompetitions) {
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

  test('quiz usa 30 segundos por pergunta', () {
    expect(Competition.secondsPerQuestion, 30);
  });

  test(
    'mural possui participantes fictícios suficientes e placares liberados',
    () {
      expect(mockParticipants.length, greaterThanOrEqualTo(10));
      expect(
        mockCompetitions.every((competition) => competition.resultsReleased),
        isTrue,
      );
    },
  );
}
