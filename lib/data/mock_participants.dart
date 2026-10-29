import 'package:nuclear_quizdefinitivo/models/participant.dart';

/// Participantes fictícios (apenas nomes e avatares; as pontuações são
/// geradas por [participantsFor], diferentes para cada quiz).
const List<Participant> mockParticipants = [
  Participant(name: 'Ana Souza', avatar: '🧬', score: 0),
  Participant(name: 'Felipe Costa', avatar: '🛰️', score: 0),
  Participant(name: 'Carla Mendes', avatar: '🔬', score: 0),
  Participant(name: 'Bruno Lima', avatar: '⚛️', score: 0),
  Participant(name: 'Elisa Rocha', avatar: '🧪', score: 0),
  Participant(name: 'Diego Alves', avatar: '🔭', score: 0),
  Participant(name: 'Marina Oliveira', avatar: '🌎', score: 0),
  Participant(name: 'Rafael Santos', avatar: '💡', score: 0),
  Participant(name: 'Júlia Martins', avatar: '🚀', score: 0),
  Participant(name: 'Lucas Ferreira', avatar: '☢️', score: 0),
];

const List<String> _topicIds = ['medicina', 'agricultura', 'industria', 'energia'];

/// Semente estável a partir do texto (o mesmo quiz gera sempre o mesmo placar).
int _seedFor(String key) =>
    key.codeUnits.fold<int>(7, (a, b) => (a * 31 + b) % 2147483646) + 1;

/// Gerador pseudoaleatório simples (MINSTD): pontuações de 20 a 110.
List<int> _randomScores(String key, int count) {
  var state = _seedFor(key);
  final scores = <int>[];
  for (var i = 0; i < count; i++) {
    state = (state * 48271) % 2147483647;
    scores.add((2 + (state ~/ 7) % 10) * 10);
  }
  return scores;
}

/// Participantes com pontuação sorteada para o quiz [topicId]. Cada quiz tem
/// uma ordem diferente; com [topicId] nulo (ranking geral) soma os quatro quizzes.
List<Participant> participantsFor(String? topicId) {
  final count = mockParticipants.length;
  final totals = List<int>.filled(count, 0);
  for (final id in (topicId == null ? _topicIds : [topicId])) {
    final scores = _randomScores(id, count);
    for (var i = 0; i < count; i++) {
      totals[i] += scores[i];
    }
  }
  return [
    for (var i = 0; i < count; i++)
      Participant(
        name: mockParticipants[i].name,
        avatar: mockParticipants[i].avatar,
        score: totals[i],
      ),
  ];
}
