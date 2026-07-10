import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/notes';

  static Future<String> _authHeader() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    return 'Bearer $token';
  }

  static Future<Map<String, dynamic>> getSummary(String noteId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final res = await http.post(
      Uri.parse('$baseUrl/$noteId/summary?userId=$userId'),
      headers: {'Authorization': await _authHeader()},
    );
    if (res.statusCode != 200) throw Exception('Failed to load summary');
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getQuiz(String noteId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final res = await http.post(
      Uri.parse('$baseUrl/$noteId/quiz?userId=$userId'),
      headers: {'Authorization': await _authHeader()},
    );
    if (res.statusCode != 200) throw Exception('Failed to load quiz');
    return jsonDecode(res.body)['quiz'];
  }

  static Future<String> sendChatMessage(String noteId, String question) async {
    final res = await http.post(
      Uri.parse('$baseUrl/$noteId/chat'),
      headers: {
        'Authorization': await _authHeader(),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question}),
    );
    if (res.statusCode != 200) throw Exception('Chat failed');
    return jsonDecode(res.body)['answer'];
  }
}