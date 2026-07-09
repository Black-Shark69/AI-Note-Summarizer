import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  // Register
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Get Notes
  static Future<Map<String, dynamic>> getNotes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes'),
      headers: {'authorization': token},
    );
    return jsonDecode(response.body);
  }

  // Save Note
  static Future<Map<String, dynamic>> saveNote(
      String token, String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': token,
      },
      body: jsonEncode({'title': title, 'content': content}),
    );
    return jsonDecode(response.body);
  }

  // Save Summary
  static Future<Map<String, dynamic>> saveSummary(
      String token, int noteId, String summaryText, String lengthType) async {
    final response = await http.post(
      Uri.parse('$baseUrl/summaries'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': token,
      },
      body: jsonEncode({
        'note_id': noteId,
        'summary_text': summaryText,
        'length_type': lengthType,
      }),
    );
    return jsonDecode(response.body);
  }

  // Get Summaries
  static Future<Map<String, dynamic>> getSummaries(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/summaries'),
      headers: {'authorization': token},
    );
    return jsonDecode(response.body);
  }
}