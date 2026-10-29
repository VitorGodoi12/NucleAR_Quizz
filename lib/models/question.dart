class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final text = json['text'];
    final rawOptions = json['options'];
    final correctIndex = json['correctIndex'];
    final explanation = json['explanation'];
    if (text is! String ||
        rawOptions is! List ||
        rawOptions.any((option) => option is! String) ||
        correctIndex is! int ||
        explanation is! String) {
      throw const FormatException('Formato de pergunta inválido.');
    }
    final options = rawOptions.cast<String>();
    if (options.isEmpty || correctIndex < 0 || correctIndex >= options.length) {
      throw const FormatException('Alternativas ou resposta inválidas.');
    }
    return Question(
      text: text,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
    );
  }
}

/// Pergunta respondida de forma incorreta (ou sem resposta, se chosenIndex for null).
class WrongAnswer {
  final Question question;
  final int? chosenIndex;

  const WrongAnswer({required this.question, required this.chosenIndex});
}
