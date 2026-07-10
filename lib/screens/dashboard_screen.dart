// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   bool _loading = true;
//   int _totalNotes = 0;
//   int _quizzesTaken = 0;
//   double _avgScore = 0;
//   List<Map<String, dynamic>> _recentQuizzes = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadStats();
//   }
//
//   Future<void> _loadStats() async {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//
//     final notesSnap = await FirebaseFirestore.instance
//         .collection('notes')
//         .where('userId', isEqualTo: userId)
//         .get();
//
//     final quizAttemptsSnap = await FirebaseFirestore.instance
//         .collection('quizAttempts')
//         .where('userId', isEqualTo: userId)
//         .orderBy('date', descending: true)
//         .limit(5)
//         .get();
//
//     final scores = quizAttemptsSnap.docs
//         .map((d) => (d['score'] as num).toDouble())
//         .toList();
//     final avg = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
//
//     if (mounted) {
//       setState(() {
//         _totalNotes = notesSnap.docs.length;
//         _quizzesTaken = quizAttemptsSnap.docs.length;
//         _avgScore = avg;
//         _recentQuizzes = quizAttemptsSnap.docs.map((d) {
//           final data = d.data();
//           return {
//             'subject': data['subject'] ?? 'Untitled',
//             'score': data['score'] ?? 0,
//             'date': data['date'] ?? '',
//           };
//         }).toList();
//         _loading = false;
//       });
//     }
//   }
//
//   Color _scoreColor(int score) {
//     if (score >= 85) return AppColors.success;
//     if (score >= 65) return const Color(0xFFFFB300);
//     return AppColors.error;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: AppColors.primary));
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Stats row — now using real data
//           Row(
//             children: [
//               _StatCard(
//                 label: 'Total Notes',
//                 value: '$_totalNotes',
//                 icon: Icons.folder_rounded,
//                 color: AppColors.primary,
//               ),
//               const SizedBox(width: 10),
//               _StatCard(
//                 label: 'Quizzes Taken',
//                 value: '$_quizzesTaken',
//                 icon: Icons.quiz_rounded,
//                 color: const Color(0xFF00BFA5),
//               ),
//               const SizedBox(width: 10),
//               _StatCard(
//                 label: 'Avg Score',
//                 value: '${_avgScore.round()}%',
//                 icon: Icons.star_rounded,
//                 color: const Color(0xFFFFB300),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           // Recent quiz scores — now using real data
//           const Text(
//             'Recent Quiz Scores',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
//           ),
//           const SizedBox(height: 12),
//
//           if (_recentQuizzes.isEmpty)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppColors.borderColor),
//               ),
//               child: const Center(
//                 child: Text(
//                   'No quizzes taken yet — complete a quiz to see your scores here!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: AppColors.textSecondary),
//                 ),
//               ),
//             )
//           else
//             ..._recentQuizzes.map(
//                   (quiz) => Container(
//                 margin: const EdgeInsets.only(bottom: 10),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: AppColors.borderColor),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(
//                         color: _scoreColor(quiz['score'] as int).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${quiz['score']}',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w800,
//                             color: _scoreColor(quiz['score'] as int),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             quiz['subject'] as String,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             quiz['date'] as String,
//                             style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: 6,
//                       width: 80,
//                       decoration: BoxDecoration(
//                         color: AppColors.borderColor,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: FractionallySizedBox(
//                         widthFactor: (quiz['score'] as int) / 100,
//                         alignment: Alignment.centerLeft,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: _scoreColor(quiz['score'] as int),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;
//
//   const _StatCard({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: AppColors.borderColor),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 10),
//             Text(
//               value,
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../widgets/decorative_background.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;
  String? _error;
  int _totalNotes = 0;
  int _quizzesTaken = 0;
  double _avgScore = 0;
  List<Map<String, dynamic>> _recentQuizzes = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Not logged in';
          _loading = false;
        });
        return;
      }

      final notesSnap = await FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: user.uid)
          .get();

      final quizAttemptsSnap = await FirebaseFirestore.instance
          .collection('quizAttempts')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      final scores = quizAttemptsSnap.docs
          .map((d) {
        final data = d.data();
        final score = data['score'];
        if (score is num) return score.toDouble();
        return 0.0;
      })
          .toList();

      final avg = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;

      if (!mounted) return;

      setState(() {
        _totalNotes = notesSnap.docs.length;
        _quizzesTaken = quizAttemptsSnap.docs.length;
        _avgScore = avg;
        _recentQuizzes = quizAttemptsSnap.docs.map((d) {
          final data = d.data();
          return {
            'subject': data['subject']?.toString() ?? 'Untitled',
            'score': (data['score'] is num) ? (data['score'] as num).toInt() : 0,
            'date': data['date']?.toString() ?? '',
          };
        }).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _scoreColor(int score) {
    if (score >= 85) return AppColors.success;
    if (score >= 65) return const Color(0xFFFFB300);
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 56, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Could not load dashboard',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadStats,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return DecorativeBackground(
      child: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StatCard(
                    label: 'Total Notes',
                    value: '$_totalNotes',
                    icon: Icons.folder_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Quizzes Taken',
                    value: '$_quizzesTaken',
                    icon: Icons.quiz_rounded,
                    color: const Color(0xFF00BFA5),
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Avg Score',
                    value: '${_avgScore.round()}%',
                    icon: Icons.star_rounded,
                    color: const Color(0xFFFFB300),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _totalNotes > 0 ? 'Keep learning!' : 'Get started!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _totalNotes > 0
                              ? "You've uploaded $_totalNotes note${_totalNotes == 1 ? '' : 's'}!"
                              : "Upload your first note to begin",
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Recent Quiz Scores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),

              if (_recentQuizzes.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: const Center(
                    child: Text(
                      'No quizzes taken yet — complete a quiz to see your scores here!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ..._recentQuizzes.map(
                      (quiz) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _scoreColor(quiz['score'] as int).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${quiz['score']}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: _scoreColor(quiz['score'] as int),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz['subject'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                quiz['date'] as String,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 6,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.borderColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: (quiz['score'] as int).clamp(0, 100) / 100,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _scoreColor(quiz['score'] as int),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}