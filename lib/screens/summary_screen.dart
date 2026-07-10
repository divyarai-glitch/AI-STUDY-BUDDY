import '../widgets/decorative_background.dart';
  import 'package:flutter/material.dart';
  import '../theme/app_theme.dart';
  import '../services/api_service.dart';
  import 'quiz_screen.dart';
  import 'chat_screen.dart';

  class SummaryScreen extends StatefulWidget {
  final String noteId;
  final String pdfName;

  const SummaryScreen({super.key, required this.noteId, required this.pdfName});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
  }

  class _SummaryScreenState extends State<SummaryScreen> {
  bool _loading = true;
  String? _error;
  String _summary = '';
  List<String> _keyPoints = [];

  @override
  void initState() {
  super.initState();
  _loadSummary();
  }

  Future<void> _loadSummary() async {
  try {
  final data = await ApiService.getSummary(widget.noteId);
  setState(() {
  _summary = data['summary'] ?? '';
  _keyPoints = List<String>.from(data['keyPoints'] ?? []);
  _loading = false;
  });
  } catch (e) {
  setState(() {
  _error = e.toString();
  _loading = false;
  });
  }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: AppColors.background,
  appBar: AppBar(
  title: Text(widget.pdfName, overflow: TextOverflow.ellipsis),
  leading: IconButton(
  icon: const Icon(Icons.arrow_back_ios_new_rounded),
  onPressed: () => Navigator.pop(context),
  ),
  ),
      body: DecorativeBackground(
        child:_loading
  ? const Center(child: CircularProgressIndicator())
      : _error != null
  ? Center(child: Text('Error: $_error'))
      : SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
  gradient: LinearGradient(
  colors: [AppColors.primary.withOpacity(0.08), AppColors.primary.withOpacity(0.02)],
  ),
  borderRadius: BorderRadius.circular(20),
  ),
  child: Text(_summary, style: const TextStyle(fontSize: 14, height: 1.7)),
  ),
  const SizedBox(height: 24),
  const Text('Key Points', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
  const SizedBox(height: 12),
  ..._keyPoints.map((point) => Container(
  margin: const EdgeInsets.only(bottom: 10),
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: AppColors.borderColor),
  ),
  child: Text(point),
  )),
  const SizedBox(height: 28),
  ElevatedButton.icon(
  onPressed: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => QuizScreen(noteId: widget.noteId)),
  ),
  icon: const Icon(Icons.quiz_outlined, color: Colors.white),
  label: const Text('Generate Quiz'),
  ),
  const SizedBox(height: 12),
  OutlinedButton.icon(
  onPressed: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => ChatScreen(noteId: widget.noteId, noteName: widget.pdfName)),
  ),
  icon: const Icon(Icons.chat_bubble_outline_rounded),
  label: const Text('Chat with Notes'),
  ),
  ],
  ),
  ),
      ),
  );
  }
  }