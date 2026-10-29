class Participant {
  final String name;
  final int score;
  final bool isCurrentUser;
  final String avatar;

  const Participant({
    required this.name,
    required this.score,
    this.isCurrentUser = false,
    this.avatar = '👤',
  });
}
