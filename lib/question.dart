// lib/question.dart
class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}
