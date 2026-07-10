import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/decorative_background.dart';

class QuizScreen extends StatefulWidget {
  final String noteId;
  const QuizScreen({super.key, required this.noteId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {


  int _timeLeft = 30;
  late AnimationController _timerController;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _questions = [];

  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  bool _quizFinished = false;



  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(() {
      setState(() {
        _timeLeft = (30 - (_timerController.value * 30)).ceil();
      });
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed && !_answered) {
        setState(() {
          _answered = true;
        });
      }
    });

    _loadQuiz();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    try {
      final data = await ApiService.getQuiz(widget.noteId);
      setState(() {
        _questions = data.map<Map<String, dynamic>>((q) {
          final options = List<String>.from(q['options']);
          return {
            'question': q['question'],
            'options': options,
            'correct': options.indexOf(q['correctAnswer']),
          };
        }).toList();
        _loading = false;
      });
      _timerController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _saveQuizAttempt() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final percent = (_score / _questions.length * 100).round();

    await FirebaseFirestore.instance
        .collection('quizAttempts')
        .add({
      'userId': user.uid,
      'noteId': widget.noteId,
      'score': percent,
      'date': Timestamp.now(),
      'subject': 'Quiz',
    });
  }

  void _startNextTimer() {
    _timerController.reset();
    _timeLeft = 30;
    _timerController.forward();
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _timerController.stop();
      if (index == _questions[_currentQuestion]['correct']) {
        _score++;
      }
    });
  }

  // void _nextQuestion() {
  //   if (_currentQuestion < _questions.length - 1) {
  //     setState(() {
  //       _currentQuestion++;
  //       _selectedAnswer = null;
  //       _answered = false;
  //     });
  //     _startNextTimer();
  //   } else async {
  //     await _saveQuizAttempt();
  //
  //     setState(() {
  //       _quizFinished = true;
  //     });
  //   }
  // }

  Future<void> _nextQuestion() async {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _answered = false;
      });
      _startNextTimer();
    } else {
      await _saveQuizAttempt();

      setState(() {
        _quizFinished = true;
      });
    }
  }

  Color _optionColor(int index) {
    if (!_answered) return Colors.white;
    if (index == _questions[_currentQuestion]['correct']) return AppColors.success;
    if (index == _selectedAnswer) return AppColors.error;
    return Colors.white;
  }

  Color _optionTextColor(int index) {
    if (!_answered) return AppColors.textPrimary;
    if (index == _questions[_currentQuestion]['correct']) return Colors.white;
    if (index == _selectedAnswer) return Colors.white;
    return AppColors.textSecondary;
  }



  Widget _buildFinishScreen() {
    final percent = (_score / _questions.length * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: percent >= 60 ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: percent >= 60 ? AppColors.success : AppColors.error,
                    ),
                  ),
                  Text(
                    'Score',
                    style: TextStyle(
                      color: percent >= 60 ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              percent >= 80
                  ? 'Excellent Work!'
                  : percent >= 60
                  ? 'Good Job!'
                  : 'Keep Practicing!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_score out of ${_questions.length} questions correct',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentQuestion = 0;
                  _selectedAnswer = null;
                  _answered = false;
                  _score = 0;
                  _quizFinished = false;
                });
                _startNextTimer();
              },
              child: const Text('Retry Quiz'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text(
                'Back to Notes',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(body: Center(child: Text('Error: $_error')));
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: _quizFinished ? const Text('Quiz Results') : const Text('Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecorativeBackground(
        child:_quizFinished
          ? _buildFinishScreen()
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress + timer
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${_currentQuestion + 1} of ${_questions.length}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_currentQuestion + 1) / _questions.length,
                          minHeight: 8,
                          backgroundColor: AppColors.borderColor,
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _timeLeft <= 10
                        ? AppColors.error.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$_timeLeft',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _timeLeft <= 10 ? AppColors.error : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                _questions[_currentQuestion]['question'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Options
            ...List.generate(4, (index) {
              final labels = ['A', 'B', 'C', 'D'];
              return GestureDetector(
                onTap: () => _selectAnswer(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: _optionColor(index),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: !_answered
                          ? AppColors.borderColor
                          : index == _questions[_currentQuestion]['correct']
                          ? AppColors.success
                          : index == _selectedAnswer
                          ? AppColors.error
                          : AppColors.borderColor,
                      width: _answered && (index == _selectedAnswer ||
                          index == _questions[_currentQuestion]['correct'])
                          ? 2
                          : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _answered
                              ? _optionColor(index).withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _answered
                                  ? _optionTextColor(index)
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _questions[_currentQuestion]['options'][index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _optionTextColor(index),
                          ),
                        ),
                      ),
                      if (_answered && index == _questions[_currentQuestion]['correct'])
                        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                      if (_answered &&
                          index == _selectedAnswer &&
                          index != _questions[_currentQuestion]['correct'])
                        const Icon(Icons.cancel_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),

            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestion < _questions.length - 1 ? 'Next Question' : 'See Results',
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
