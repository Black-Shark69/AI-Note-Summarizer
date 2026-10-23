
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl =
      'https://ai-note-summarizer-272z.onrender.com';

  static Future<String> summarize({
    required String content,
    required String length,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/summaries/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content': content,
          'length': length,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['summary']?.toString() ??
            'Could not generate summary. Please try again.';
      }

      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Summary request failed (${response.statusCode}).';
    } catch (e) {
      return 'Could not connect to the server. Please try again.';
    }
  }
}
