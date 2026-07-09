import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AQ.Ab8RN6L-gobVlgai-L98a3PCsypinCQcnj5mw4Zm5lwXMHK3QQ';

  static Future<String> summarize({
    required String content,
    required String length,
  }) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-3.5-flash',
        apiKey: _apiKey,
      );

      int wordLimit = length == 'short' ? 80 : length == 'medium' ? 150 : 250;

      final prompt = '''
You are an academic note summarizer for students.
Summarize the following educational content in maximum $wordLimit words.
Keep the most important concepts, key points, and definitions.
Write in clear, simple English suitable for students.
Do not add any introduction like "Here is a summary" - just write the summary directly.

Content to summarize:
$content
''';

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Could not generate summary. Please try again.';
    }  catch (e) {
  print('Gemini Error: $e');
  return 'Error: $e';
  }
  }
}