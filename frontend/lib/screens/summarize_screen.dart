import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/gemini_service.dart';
import '../widgets/custom_button.dart';

class SummarizeScreen extends StatefulWidget {
  const SummarizeScreen({super.key});

  @override
  State<SummarizeScreen> createState() => _SummarizeScreenState();
}

class _SummarizeScreenState extends State<SummarizeScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedLength = 'short';
  bool _isLoading = false;
  bool _hasSummary = false;
  String _summaryText = '';
  String _error = '';
  String _loadingMessage = 'Analysing your notes…';

  final List<String> _loadingMessages = [
    'Analysing your notes…',
    'Extracting key concepts…',
    'Generating summary with Gemini AI…',
    'Almost ready…',
  ];

  Future<void> _generateSummary() async {
    if (_contentController.text.isEmpty) {
      setState(() => _error = 'Please enter note content');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = '';
      _hasSummary = false;
      _loadingMessage = _loadingMessages[0];
    });

    // Cycle loading messages
    int msgIndex = 0;
    final msgTimer = Stream.periodic(const Duration(seconds: 2), (i) => i);
    final sub = msgTimer.listen((_) {
      msgIndex = (msgIndex + 1) % _loadingMessages.length;
      if (mounted) setState(() => _loadingMessage = _loadingMessages[msgIndex]);
    });

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        setState(() { _error = 'Not logged in'; _isLoading = false; });
        sub.cancel();
        return;
      }

      // Save note to backend
      final noteRes = await ApiService.saveNote(
        token,
        _titleController.text.isEmpty ? 'Untitled Note' : _titleController.text,
        _contentController.text,
      );

      if (noteRes['noteId'] != null) {
        // Generate real AI summary with Gemini
        final summary = await GeminiService.summarize(
          content: _contentController.text,
          length: _selectedLength,
        );

        // Save summary to backend
        await ApiService.saveSummary(
          token,
          noteRes['noteId'],
          summary,
          _selectedLength,
        );

        sub.cancel();
        setState(() {
          _summaryText = summary;
          _hasSummary = true;
          _isLoading = false;
        });
      } else {
        sub.cancel();
        setState(() {
          _error = noteRes['message'] ?? 'Failed to save note';
          _isLoading = false;
        });
      }
    } catch (e) {
      sub.cancel();
      setState(() {
        _error = 'Error: Is server running?';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Summarization',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Paste your notes and get a smart summary',
              style: TextStyle(color: Color(0xFF5F5E5A), fontSize: 13)),
          const SizedBox(height: 16),

          // Input card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0DED8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Title (optional)',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F5E5A))),
                const SizedBox(height: 6),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Machine Learning Notes',
                    hintStyle: const TextStyle(color: Color(0xFF9C9A92)),
                    filled: true,
                    fillColor: const Color(0xFFEFEFEB),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Note content',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F5E5A))),
                const SizedBox(height: 6),
                TextField(
                  controller: _contentController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText:
                    'Paste your lecture notes, article, or study material here…',
                    hintStyle: const TextStyle(color: Color(0xFF9C9A92)),
                    filled: true,
                    fillColor: const Color(0xFFEFEFEB),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Summary length',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F5E5A))),
                const SizedBox(height: 8),
                Row(
                  children: ['short', 'medium', 'detailed'].map((type) {
                    final isSelected = _selectedLength == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedLength = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEEEDFE)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF534AB7)
                                    : const Color(0xFFE0DED8)),
                          ),
                          child: Text(
                            type[0].toUpperCase() + type.substring(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF534AB7)
                                  : const Color(0xFF5F5E5A),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                if (_error.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFCEBEB),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Color(0xFFA32D2D), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_error,
                              style: const TextStyle(
                                  color: Color(0xFFA32D2D), fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                CustomButton(
                  text: '✦  Generate summary',
                  onPressed: _generateSummary,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),

          // Loading card
          if (_isLoading) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0DED8)),
              ),
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFF534AB7),
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _loadingMessage,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A18)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Powered by Gemini AI',
                    style: TextStyle(fontSize: 12, color: Color(0xFF5F5E5A)),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: const LinearProgressIndicator(
                      backgroundColor: Color(0xFFEEEDFE),
                      color: Color(0xFF534AB7),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Result card
          if (_hasSummary) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0DED8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Color(0xFF0F6E56), size: 18),
                      const SizedBox(width: 6),
                      const Text('Summary ready',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F6E56))),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEDFE),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome,
                                size: 12, color: Color(0xFF534AB7)),
                            const SizedBox(width: 4),
                            const Text('Gemini AI',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF534AB7),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy,
                            size: 18, color: Color(0xFF5F5E5A)),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: _summaryText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard!'),
                              backgroundColor: Color(0xFF0F6E56),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEB),
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(
                          left: BorderSide(
                              color: Color(0xFF534AB7), width: 3)),
                    ),
                    child: Text(_summaryText,
                        style: const TextStyle(
                            fontSize: 13,
                            height: 1.7,
                            color: Color(0xFF1A1A18))),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statPill(
                          '${_contentController.text.split(' ').length}',
                          'Original words'),
                      const SizedBox(width: 8),
                      _statPill(
                          '${_summaryText.split(' ').length}',
                          'Summary words'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasSummary = false;
                          _titleController.clear();
                          _contentController.clear();
                        });
                      },
                      icon: const Icon(Icons.refresh,
                          color: Color(0xFF534AB7), size: 16),
                      label: const Text('Summarize another note',
                          style: TextStyle(color: Color(0xFF534AB7))),
                      style: OutlinedButton.styleFrom(
                        side:
                        const BorderSide(color: Color(0xFF534AB7)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statPill(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF5F5E5A))),
          ],
        ),
      ),
    );
  }
}