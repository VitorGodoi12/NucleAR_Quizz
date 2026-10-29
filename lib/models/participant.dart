class Participant {
  final String name;
  final int score;
  final bool isCurrentUser;
  final String avatar;

  /// Pontuação por tema (id do tema -> pontos). Vazio para o usuário real.
  final Map<String, int> topicScores;

  const Participant({
    required this.name,
    required this.score,
    this.isCurrentUser = false,
    this.avatar = '👤',
    this.topicScores = const {},
  });

  /// Pontos no tema informado, ou o total geral quando [topicId] é nulo.
  int scoreIn(String? topicId) =>
      topicId == null ? score : (topicScores[topicId] ?? 0);
}
