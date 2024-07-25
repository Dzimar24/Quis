import 'package:flutter/material.dart';
import 'data/questions.dart';
import 'question.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        brightness: Brightness.dark, // Mengatur tema menjadi tema gelap
        primarySwatch: Colors.blue,
      ),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool showExplanation = false;
  int correctAnswers = 0;
  List<Question> shuffledQuestions = [];

  @override
  void initState() {
    super.initState();
    shuffledQuestions = List.from(questions);
    shuffledQuestions.shuffle(); // Acak urutan soal sebelum ditampilkan
  }

  void _checkAnswer(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      showExplanation = true;
      if (selectedIndex == shuffledQuestions[currentQuestionIndex].correctOptionIndex) {
        correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < shuffledQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        showExplanation = false;
      } else {
        _showResultPage();
      }
    });
  }

  void _showResultPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultPage(correctAnswers: correctAnswers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = shuffledQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Pertanyaan dan jawaban diatur di tengah
            children: [
              Text(
                currentQuestion.questionText,
                style: TextStyle(fontSize: 24.0, color: Color(0xFF78B7FF)),
                textAlign: TextAlign.center, // Pertanyaan diatur menjadi pusat
              ),
              SizedBox(height: 20.0),
              ...currentQuestion.options.asMap().entries.map((entry) {
                int idx = entry.key;
                String option = entry.value;
                return GestureDetector(
                  onTap: () {
                    if (!showExplanation) {
                      _checkAnswer(idx);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Menyusun Radio dan Text di tengah
                    children: [
                      showExplanation
                          ? Icon(
                              idx == currentQuestion.correctOptionIndex
                                  ? Icons.check_circle
                                  : (selectedAnswerIndex == idx
                                      ? Icons.cancel
                                      : Icons.radio_button_unchecked),
                              color: idx == currentQuestion.correctOptionIndex
                                  ? Colors.green
                                  : (selectedAnswerIndex == idx
                                      ? Colors.red
                                      : Colors.grey),
                            )
                          : Radio(
                              value: idx,
                              groupValue: selectedAnswerIndex,
                              onChanged: (int? value) {
                                _checkAnswer(idx);
                              },
                            ),
                      SizedBox(width: 5), // Menambahkan jarak tetap antara ikon dan teks
                      Text(
                        option,
                        textAlign: TextAlign.center, // Jawaban diatur menjadi pusat
                        style: TextStyle(color: Color(0xFF78B7FF)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (showExplanation)
                Column(
                  children: [
                    Text(
                      currentQuestion.explanation,
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center, // Penjelasan diatur menjadi pusat
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      child: Text('Next Question'),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int correctAnswers;

  ResultPage({required this.correctAnswers});

  String _convertScoreToReadableFormat(int score) {
    if (score == 100) {
      return "Perfect!";
    } else if (score >= 50) {
      return "Good Job!";
    } else {
      return "Better Luck Next Time!";
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalQuestions = questions.length;
    int score = ((correctAnswers / totalQuestions) * 100).round();
    String readableScore = _convertScoreToReadableFormat(score);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24.0, color: Color(0xFF78B7FF)),
              ),
              SizedBox(height: 20.0),
              Text(
                'Correct Answers: $correctAnswers',
                style: TextStyle(fontSize: 20.0, color: Colors.green),
              ),
              Text(
                'Incorrect Answers: ${totalQuestions - correctAnswers}',
                style: TextStyle(fontSize: 20.0, color: Colors.red),
              ),
              Text(
                'Your Score: $score',
                style: TextStyle(fontSize: 20.0, color: Colors.white), // Mengubah warna skor menjadi putih
              ),
              SizedBox(height: 10.0),
              Text(
                readableScore,
                style: TextStyle(fontSize: 20.0, color: Colors.yellow),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                child: Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
