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
}

/// Pergunta respondida de forma incorreta (ou sem resposta, se chosenIndex for null).
class WrongAnswer {
  final Question question;
  final int? chosenIndex;

  const WrongAnswer({required this.question, required this.chosenIndex});
}
